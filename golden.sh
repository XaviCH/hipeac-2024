#!/bin/bash

# stop after first error 
set -e 

# Uncomment for verbose output
# set -x 

CWD=`pwd`
echo "Current working directory: $CWD"

SRC_DIR=$CWD/radiation-benchmarks/src/cuda

SRC_OBJS=(bfs gemm)

###############################################################################

for OBJ in $SRC_OBJS; do
    echo "Creating golden at $SRC_DIR/$OBJ."
    make -C $SRC_DIR/$OBJ generate GOLD=$SRC_DIR/$OBJ/gold.data SMS=64
done



