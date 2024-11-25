#!/bin/bash
eval ${PRELOAD_FLAG} ${BIN_DIR}/gemm --size 4096 --verbose \
                        --precision float --dmr none \
                        --iterations 1  \
                        --alpha 1.0 --beta 0.0 \
                        --input_a $RB_HOME/src/cuda/gemm/a.matrix \
                        --input_b $RB_HOME/src/cuda/gemm/b.matrix \
                        --input_c $RB_HOME/src/cuda/gemm/c.matrix \
                        --gold  $RB_HOME/src/cuda/gemm/golden.txt    \
                        --opnum 1  > stdout.txt 2> stderr.txt