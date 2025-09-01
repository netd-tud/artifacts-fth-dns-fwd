

Artifacts: Forward to Hell? On the Potentials of Misusing Transparent DNS Forwarders in Reflective Amplification Attacks
===

This repository contains the artifacts for the following paper:
```
Forward to Hell? On the Potentials of Misusing Transparent DNS Forwarders in Reflective Amplification Attacks
Maynard Koch, Florian Dolzmann, Thomas C. Schmidt, and Matthias Wählisch
Proc. of ACM Conference on Computer and Communications Security (CCS)
```

# Reproduction of paper artifacts

## Requirements for creating the figures and tables shown in the paper
 - OS: Linux, tested under Ubuntu 22.04 and 24.04
 - 32 GB of RAM
 - 50 GB free disk space
 - Python 3.10

## Additional requirements for performing Internet-wide scans
- An authoritative nameserver under your control
- A domain name under your control
- GOLANG 1.23.0
- ZGrab2 for fingerprinting
- Optional, but highly recommended: A scan server with no upstream filters, allowing for fast Internet-wide scans.

## How to reproduce the artifacts
Clone this repository, then: 
1. Make sure python 3.10 is installed.
2. Make a virtual environment: `make python_env`
3. Activate python env: `source .venv/bin/activate`
4. To get a clean starting environment run `make clean` first.

Now you can reproduce the paper plots with: 

5. `make plots`

The plots are then stored under `reports/figures/`

To reproduce the paper tables you can simply run:

6. `make tables`

This command runs the jupyter notebook `notebooks/tables.ipynb` and creates the `notebooks/tables.html` file which contains all the tables from the paper.

### To reproduce the DNS scanning data

To run the DNS scans you need to do some set up.
Copy and edit the template file:

1. ```cp scan/odns-measurement-tools/src/scanner/udp/config.yml.template scan/odns-measurement-tools/src/scanner/udp/config.yml && vim scan/odns-measurement-tools/src/scanner/udp/config.yml```

2. Fill in the missing variables:

    1. Name and IP-address of the interface the scanner will be running on.
    2. A domain used during scan. The authoritative nameserver of this domain, must be set up to reply with the two A records: IP-address of requesting DNS client on the nameserver; an IP as control record (which is currently hardcoded to `91.216.216.216` in the postprocessing)

3. ```cd scan && ./run_scan.sh udp``` (Note: This performs an Internet-wide scan for open DNS components!)

### Testing for DNSSEC and ANY query support

### Rate-limit tests
This component allows for rate limit and performance testing of DNS resolvers.
A specialized configuration and input file is required to run the tests.
The configuration template is located under ` src/ratelimit/config.yml.template`.
Please refer to [config.go](scan/odns-measurement-tools/src/config/config.go) for an explanation of each parameter that can be adjusted.

**To run the rate limit testing:**\
The input file needs to be in a .csv.gz format, containing two columns: `ip_request` and `ip_response`.
The header needs to be present in the input file.
`ip_request` will be used as target IPs for the rate limit testing while they are grouped by their `ip_response` value respectively.
If `rate_response_ip_only` is set to `true` in the `config.yml` file, the `ip_response` column will be used as target addresses during the test, and the `ip_request` column can be dropped.

Either this can be done with the last UDP scan as follows:
```
cd src
sudo ratelimit/check_pub_resolvers.sh [in: last udp scan] [out: intermediate resolver scan file] [out: intersect file]
```

Or directly:
```
cd src
sudo go run dns_tool.go --mode ratelimit --config scanner/ratelimit/config.yml input.csv.gz
```

**To test the performance of a single resolver:**\
It sufficies to set the desired configuration and run the following:
```
cd src
sudo go run dns_tool.go --mode ratelimit --config scanner/ratelimit/config.yml <1.2.3.4>
```

Results will be in `ratelimit_results/<timestamp>_<config-settings>/`

### Fingerprinting
Fingerprinting of device vendor and model may be performed for ODNS components.
Please read the instructions for [fingerprinting](scan/odns-measurement-tools/src/fingerprinting/README.md).

## Cleaning the environment
- `make clean` to remove figures and the table.html file.
