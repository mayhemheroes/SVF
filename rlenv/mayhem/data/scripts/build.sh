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
jobs=4

# Set up LLVM_DIR and Z3_DIR environment variables
# These should point to the already-installed LLVM and Z3 from the initial build
export LLVM_DIR="$SVFHOME/llvm-13.0.0.obj"
export Z3_DIR="$SVFHOME/z3.obj"
export PATH=$LLVM_DIR/bin:$PATH

echo "Building SVF from source..."
echo "LLVM_DIR=$LLVM_DIR"
echo "Z3_DIR=$Z3_DIR"

# Clean previous build if it exists
rm -rf ./Release-build

# Create build directory
mkdir ./Release-build
cd ./Release-build

# Run cmake to configure the build
cmake ../

# Build SVF
make -j ${jobs}

# Return to source root
cd ../

# Set up SVF environment variables (passing 'release' parameter)
. ./setup.sh release

# Copy build artifacts to expected locations
echo "Copying build artifacts to expected locations..."
cp ./Release-build/bin/saber /
cp -r ./include /include
cp -r ./testsuite /testsuite

echo "Build completed successfully!"

# Verify build artifacts exist
if [ ! -f /saber ]; then
    echo "Error: Build artifact /saber not found"
    exit 1
fi

if [ ! -d /include ]; then
    echo "Error: Include directory not found"
    exit 1
fi

echo "Build verification passed!"
