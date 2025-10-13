#! /bin/bash

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 [FILE]"
    exit 1
fi

/saber $1