

Artifacts: Forward to Hell? On the Potentials of Misusing Transparent DNS Forwarders in Reflective Amplification Attacks
===

This repository contains the artifacts for the following paper:
```
```

# Reproduction of paper artifacts

Requirements: 64 GB of RAM, 50 GB free disk space

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

## Cleaning the environment
- `make clean` to remove figures and the table.html file.
- `make clean-cache` to remove the cached pickle files for faster plot rendering
- It is necessary to run these commands when creating new dataframes from the raw files (see below)
