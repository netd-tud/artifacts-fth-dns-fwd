#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = artifacts-fth-dns-fwd
PYTHON_VERSION = 3.10
PYTHON_INTERPRETER = python3
SHELL := /bin/bash

#################################################################################
# COMMANDS                                                                      #
#################################################################################


## Install Python dependencies
.PHONY: requirements
requirements:
	$(PYTHON_INTERPRETER) -m pip install -U pip
	$(PYTHON_INTERPRETER) -m pip install -r requirements.txt
	



## Delete all compiled Python files
.PHONY: clean
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete


## Lint using ruff (use `make format` to do formatting)
.PHONY: lint
lint:
	ruff format --check
	ruff check

## Format source code with ruff
.PHONY: format
format:
	ruff check --fix
	ruff format


python_env:
	$(PYTHON_INTERPRETER) -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt

notebooks = notebooks/tables.ipynb
notebooks_html = notebooks/tables.html

%.html: %.ipynb
	jupyter nbconvert $(NBCONVERT_PARAMS) --to html $<

tables: NBCONVERT_PARAMS=--execute
tables: $(notebooks_html)


#################################################################################
# PROJECT RULES                                                                 #
#################################################################################


## Make dataset
.PHONY: data
data: requirements
	$(PYTHON_INTERPRETER) artifacts_fth_dns_fwd/dataset.py

.PHONY: plots
plots: requirements
	$(PYTHON_INTERPRETER) artifacts_fth_dns_fwd/plots.py

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys; \
lines = '\n'.join([line for line in sys.stdin]); \
matches = re.findall(r'\n## (.*)\n[\s\S]+?\n([a-zA-Z_-]+):', lines); \
print('Available rules:\n'); \
print('\n'.join(['{:25}{}'.format(*reversed(match)) for match in matches]))
endef
export PRINT_HELP_PYSCRIPT

help:
	@$(PYTHON_INTERPRETER) -c "${PRINT_HELP_PYSCRIPT}" < $(MAKEFILE_LIST)
