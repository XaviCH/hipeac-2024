#!/bin/bash
eval ${PRELOAD_FLAG} ${BIN_DIR}/cudaBFS \
    --input $RB_HOME/data/bfs/graph1MW_6.txt \
    --gold $RB_HOME/src/cuda/bfs/golden.txt \
    --iterations 1 \
    --verbose \
    > stdout.txt 2> stderr.txt