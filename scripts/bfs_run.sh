#!/bin/bash
eval ${PRELOAD_FLAG} ${BIN_DIR}/cudaBFS --input $RB_HOME/data/bfs/graph1MW_6.txt --gold stdout.txt --iterations 1 --verbose --generate > stderr.txt