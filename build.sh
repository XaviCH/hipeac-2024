#!/bin/bash

set -e 

# Configuration for GTX 1080Ti
SMS=61

# Project directory
CWD=`pwd`

############################
# Download and setup NVBitFi
echo Setup NVBitFi

wget https://github.com/NVlabs/NVBit/releases/download/1.5.5/nvbit-Linux-aarch64-1.5.5.tar.bz2
tar xvfj nvbit-Linux-aarch64-1.5.5.tar.bz2
cd nvbit_release/tools/

git clone https://github.com/NVlabs/nvbitfi
cd nvbitfi
find . -name "*.sh" | xargs chmod +x
./test.sh

# Override scripts
cp $CWD/scripts/test.sh test.sh
cp $CWD/scripts/params.py ./scripts/params.py

############################
# Setup radiation-benchmarks
echo Setup radiation-benchmarks

RB_HOME=$CWD/radiation-benchmarks

# TODO checkout if necesary
cd $RB_HOME/scripts
python install.sh

cd $RB_HOME/libLogHelper
mkdir build && cd build
cmake ..
make
# cp libLogHelper.so libLogHelper.so.1.0.0 _log_helper.so ..

# Setup test
TESTS=(bfs)
for TEST in $TESTS; do
    cd $RB_HOME/src/cuda/$TEST
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$RB_HOME/libLogHelper/build make LOGS=0 SMS=$SMS
    cp $CWD/scripts/($TEST)_run.sh run.sh
    cp $CWD/scripts/sdc_check.sh sdc_check.sh
end

# Extract test data
cd $RADIATION_BENCHMARKS_DIR/data/bfs
tar -xvf graphs_rodinia.tar.gz


cd $CWD
echo Build done.