

Artifacts: Forward to Hell? On the Potentials of Misusing Transparent DNS Forwarders in Reflective Amplification Attacks
===

This repository contains the artifacts for the following paper:
```
Forward to Hell? On the Potentials of Misusing Transparent DNS Forwarders in Reflective Amplification Attacks
Maynard Koch, Florian Dolzmann, Thomas C. Schmidt, and Matthias Wählisch
Proc. of ACM Conference on Computer and Communications Security (CCS)
```

# Reproduction of paper artifacts

## Requirements
 - OS: Linux, tested under Ubuntu 22.04 
 - 32 GB of RAM
 - 50 GB free disk space

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
Therefore copy & edit the template file.

1. ```cp scan/odns-measurement-tools/src/scanner/udp/config.yml.template scan/odns-measurement-tools/src/scanner/udp/config.yml && vim scan/odns-measurement-tools/src/scanner/udp/config.yml```

2. Fill in the missing variables:

    1. Name and IP-address of the interface the scanner will be running on.
    2. A domain used during scan. The authoritative nameserver of this domain, must be set up to reply with the two A records: IP-address of requesting DNS client on the nameserver; an IP as control record (which is currently hardcoded to `91.216.216.216` in the postprocessing)

3. ```cd scan && ./run_scan.sh udp```

#### Periodic scans:

#### DNSSEC & ANY:

#### Ratelimit Tests:

#### (Lab Setup?):

## Cleaning the environment
- `make clean` to remove figures and the table.html file.
