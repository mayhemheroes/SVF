#! /bin/bash

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 [FILE]"
    exit 1
fi

ulimit -v 8388608
timeout 2 /saber $1
