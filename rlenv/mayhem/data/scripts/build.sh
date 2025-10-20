#!/bin/bash
set -euo pipefail

# RLENV Build Script
# This script rebuilds the application from source located at /rlenv/source/svf/
#
# Original image: ghcr.io/mayhemheroes/svf:master
# Git revision: 1a1999f5a4683d6bea74bcf18b1c53375d4787fe

# Change to the source directory
cd /rlenv/source/svf

# Set up build variables
SVFHOME=$(pwd)
jobs=1

# Set up LLVM_DIR and Z3_DIR environment variables
# These should point to the already-installed LLVM and Z3 from the initial build
export LLVM_DIR="$SVFHOME/llvm-13.0.0.obj"
export Z3_DIR="$SVFHOME/z3.obj"
export PATH=$LLVM_DIR/bin:$PATH

echo "Building SVF from source..."
echo "LLVM_DIR=$LLVM_DIR"
echo "Z3_DIR=$Z3_DIR"

# Create build directory
cd ./Release-build

# Build SVF
make -j ${jobs}

# Return to source root
cd ../

# Set up SVF environment variables (passing 'release' parameter)
. ./setup.sh release

# Copy build artifacts to expected locations
# These locations must be writable by unprivileged users (set up during Docker build)
echo "Copying build artifacts to expected locations..."
if [ -w / ]; then
    # Use cat for busybox compatibility when we can't remove the file
    cat ./Release-build/bin/saber > /saber
    cp -rf ./include /include
    cp -rf ./testsuite /testsuite
else
    echo "Warning: Root filesystem not writable. Artifacts remain in build directory."
fi

echo "Build completed successfully!"

# Verify build artifacts exist (check both locations)
if [ -f /saber ] || [ -f ./Release-build/bin/saber ]; then
    echo "Build verification passed!"
else
    echo "Error: Build artifact saber not found"
    exit 1
fi
