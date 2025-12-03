#!/bin/bash
set -e  # Exit on any command failure

# Script to run VHDL testbenches using GHDL
# Usage: ./run_test.sh <testbench_name>

function print_tb_disponiveis(){
    echo ""
    echo "Available testbenches:"
    ls tests/
}

function print_usage(){
    echo "Usage: $0 <testbench_name>"
    echo "Example: $0 tb_reg_deslocamento"
}

# Check if testbench name is provided
if [ $# -eq 0 ]; then
    print_usage
    print_tb_disponiveis
    exit 1
fi


# Check if testbench file exists
TESTNAME=$1
if [ ! -f "tests/$TESTNAME.vhd" ]; then
    echo "Error: Testbench file 'tests/$TESTNAME.vhd' not found!"
    print_tb_disponiveis
    exit 1
fi

echo "Running testbench: $TESTNAME"
echo "==============================="
mkdir -p work
rm -rf work/*

# Step 1: Import/analyze all VHDL files
echo "1. Analyzing VHDL files..."
ghdl -i --workdir=work src/*.vhd src/components/*.vhd tests/$TESTNAME.vhd

# Step 2: Elaborate the testbench
echo "2. Elaborating testbench..."
ghdl -m --workdir=work $TESTNAME

# Step 3: Run simulation with waveform generation
echo "3. Running simulation..."
ghdl -r --workdir=work $TESTNAME --vcd=$TESTNAME.vcd

echo ""
echo "Simulation completed successfully!"
