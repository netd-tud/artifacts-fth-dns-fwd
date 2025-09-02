#!/usr/bin/env bash

echo "=== System Requirements Check ==="

# Check RAM (32GB or higher)
echo -n "Checking RAM... "
TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
TOTAL_RAM_GB=$((TOTAL_RAM_KB / 1024 / 1024))
if [ "$TOTAL_RAM_GB" -ge 30 ]; then
    echo "OK ($TOTAL_RAM_GB GB detected)"
else
    echo "FAIL ($TOTAL_RAM_GB GB detected, need >= 32 GB)"
fi

# Check CPU cores
echo -n "Checking CPU cores... "
CPU_CORES=$(nproc)
if [ "$CPU_CORES" -ge 4 ]; then
    echo "OK ($CPU_CORES cores detected)"
else
    echo "WARNING ($CPU_CORES cores detected, 4 recommended)"
fi

# Check Python version (>= 3.10)
echo -n "Checking Python... "
if command -v python3 &>/dev/null; then
    PY_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
    REQUIRED_PY="3.10.0"
    if [ "$(printf '%s\n' "$REQUIRED_PY" "$PY_VERSION" | sort -V | head -n1)" = "$REQUIRED_PY" ]; then
        echo "OK (Python $PY_VERSION detected)"
    else
        echo "FAIL (Python $PY_VERSION detected, need >= 3.10)"
    fi
else
    echo "FAIL (Python 3 not found)"
fi

# Check Go version (>= 1.23.0)
echo -n "Checking Go... "
if command -v go &>/dev/null; then
    GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    REQUIRED_GO="1.23.0"
    if [ "$(printf '%s\n' "$REQUIRED_GO" "$GO_VERSION" | sort -V | head -n1)" = "$REQUIRED_GO" ]; then
        echo "OK (Go $GO_VERSION detected)"
    else
        echo "FAIL (Go $GO_VERSION detected, need >= 1.23.0)"
    fi
else
    echo "FAIL (Go not found)"
fi

# Check zgrab2 installation
echo -n "Checking zgrab2... "
if command -v zgrab2 &>/dev/null; then
    echo "OK (zgrab2 detected)"
else
    echo "FAIL (zgrab2 not found)"
fi

# Check libpcap installation
echo -n "Checking libpcap... "
if dpkg -s libpcap0.8 &>/dev/null; then
    echo "OK (libpcap installed)"
else
    echo "FAIL (libpcap not installed)"
fi

echo "=== Check Complete ==="
