

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
8. To get a clean starting environment run `make clean` first.

Now you can reproduce the paper plots with: 

9. `make plots`

The plots are then stored under `reports/figures/`

To reproduce the paper tables you can simply run:

10. `make tables`

This command runs the jupyter notebook `notebooks/tables.ipynb` and creates the `notebooks/tables.html` file which contains all the tables from the paper.

## Cleaning the environment
- `make clean` to remove figures and the table.html file.
