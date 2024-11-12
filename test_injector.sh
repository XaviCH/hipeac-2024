#!/bin/bash

# stop after first error 
set -e 

# Uncomment for verbose output
# set -x 

CWD=`pwd`
echo "Current working directory: $CWD"

###############################################################################
# Step 0 (1): Provide execute permissions to *.sh scripts 
###############################################################################
find . -name "*.sh" | xargs chmod +x 

###############################################################################
# Step 0 (2): Setup environment 
###############################################################################
printf "\nStep 0 (2): Setting environment variables\n"

# environment variables for NVBit
export NOBANNER=1
# set TOOL_VERBOSE=1 to print debugging information during profling and injection runs 
export TOOL_VERBOSE=0
export VERBOSE=0

export PWD_HOME=$CWD
export RADIATION_BENCHMARKS=$PWD_HOME/radiation-benchmarks
export NVBITFI_HOME=$PWD_HOME/nvbitfi
export CUDA_BASE_DIR=/usr/local/cuda
export PATH=$PATH:$CUDA_BASE_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_BASE_DIR/lib64/:$CUDA_BASE_DIR/extras/CUPTI/lib64/


###############################################################################
# Step 0 (3): Build the nvbitfi injector and profiler tools
###############################################################################
printf "\nStep 0 (3): Build the nvbitfi injector and profiler tools\n"
cd $NVBITFI_HOME/injector 
make
cd ../profiler/
make
cd $CWD

###############################################################################
# Step 0 (4): Run the app without instrumentation. Collect golden stdout and
# stderr files. User must generate this before starting the injection campaign.
###############################################################################
printf "\nStep 0 (4): Run and collect output without instrumentation\n"
source ./golden.sh

###############################################################################
# Step 1: Profile and generate injection list
#
# (1) Profile the workload and collect opcode counts. This needs to be done
# just once for a workload.  
# (2) Generate injection list for architecture-level error injections for the
# selected error injection model. 
###############################################################################
printf "\nStep 1 (1): Profile the application\n"
mv $NVBITFI_HOME/scripts/params.py $NVBITFI_HOME/scripts/__params.py
mv $CWD/params_test_injector.py $NVBITFI_HOME/scripts/params.py
cd $NVBITFI_HOME/scripts/
python run_profiler.py
rm -f stdout.txt stderr.txt ### cleanup
cd -

cd scripts/
printf "\nStep 1 (2): Generate injection list for instruction-level error injections\n"
python generate_injection_list.py 

################################################
# Step 2: Run the error injection campaign 
################################################
printf "\nStep 2: Run the error injection campaign"
python run_injections.py standalone # to run the injection campaign on a single machine with single gpu

################################################
# Step 3: Parse the results
################################################
printf "\nStep 3: Parse results"
python parse_results.py

##
# Step 4: Restore
###
mv $NVBITFI_HOME/scripts/__params.py $NVBITFI_HOME/scripts/params.py
