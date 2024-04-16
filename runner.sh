#!/bin/bash

cleanup() {
    mn -c
    rm -rf /tmp/minindn/*
}

cleanup

runScript() {
    for i in 3 5 7 9;
    do
        python experiment_new_paper.py -f new-files/video_1.webm.enc -a new-files/cipher_Height-$i.txt topologies/testbed.conf -n $1
        sleep 100
        mkdir -p /home/map901/sdulal/ccs_paper/CCS_NEW/results/new_results_apr11/height$i/$1_consumer/
        mv /tmp/minindn/* /home/map901/sdulal/ccs_paper/CCS_NEW/results/new_results_apr11/height$i/$1_consumer/
        cleanup
    done
}

for con_count in 1 5 10 15 20 25;
do
    runScript $con_count
done