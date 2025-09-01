#!/bin/bash
set -e
SCANNER_DIR="odns-measurement-tools"
RESULTS_MIDFIX="dataframe_complete"
RESULTS_DIR=../../data/raw

# elevate
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

if [ -z "$1" ]; then
    echo "please specify scan type (udp,tcp)"
    echo "e.g. ./run_scan.sh udp"
    exit 1
fi

cd $SCANNER_DIR/src

if [ ! -e "$VENV_DIR" ]; then
    echo "installing python venv"
    python3 -m venv .venv
fi

mkdir -p $RESULTS_DIR
cur_ts=$(date +%Y-%m-%d_%H-%M-%S)

if [ "$1" == "udp" ]; then
	echo "commencing udp scan" | ts "[BASH] %Y/%m/%d %H:%M:%S"
	# run the scan
	go run dns_tool.go -c scanner/udp/config.yml -m scan -p udp 0.0.0.0/0 2>&1 | sed 's/.*/[SCANNER] &/'
	# python postprocessing follows
	source .venv/bin/activate
    pip install -r requirements.txt
	# classify by resolver type
	python3 postprocessing/postproc_data_udp_pure.py udp_results.csv.gz $RESULTS_DIR/udp_${RESULTS_MIDFIX}_${cur_ts}.csv 2>&1 | ts "[NATIVE-POST] %Y/%m/%d %H:%M:%S"
	deactivate
	gzip $RESULTS_DIR/udp_${RESULTS_MIDFIX}_${cur_ts}.csv
	rm udp_results.csv.gz
elif [ "$1" == "tcp" ]; then
	echo "commencing tcp scan" | ts "[BASH] %Y/%m/%d %H:%M:%S"
	# run the scan
	go run dns_tool.go -c scanner/tcp/config.yml -m scan -p tcp 0.0.0.0/0 2>&1 | sed 's/.*/[SCANNER] &/'
	# python postprocessing follows
	source $VENV_DIR/bin/activate
    pip install -r requirements.txt
	# classify by resolver type
	python3 postprocessing/postproc_data_tcp_pure.py tcp_results.csv.gz $RESULTS_DIR/tcp_${RESULTS_MIDFIX}_${cur_ts}.csv.gz 2>&1 | ts "[NATIVE-POST] %Y/%m/%d %H:%M:%S"
	deactivate
    rm tcp_results.csv.gz
fi

echo "Done" | ts "[BASH] %Y/%m/%d %H:%M:%S"
