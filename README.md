Steps to run the experiments

## Install Mini-NDN
-- Mini-NDN installation can be found here: https://github.com/named-data/mini-ndn/blob/master/docs/install.rst

## Install/verify ndn-tools 
-- If installed as instructed in the Mini-NDN documentation, ndn-tools should come pre-installed. However, if it's not, go through the following link to install/verify ndn-tools thttps://github.com/named-data/ndn-tools/blob/master/INSTALL.md

## Running the experiments
1. Configure the number of consumer/producer in the code (options are provided in the code itself) `experiment_new_paper.py#L67-L80`, and manually run the `python experiment_new_paper.py`
- python experiment_new_paper.py -f new-files/<encrypted-video-file> -a new-files/<ciphertext-height-file> topologies/<topology e.g. testbed.conf> -n <number-of-consumers-per-node>
        
2. User runner.py `./runner.sh` 
-- This script runs `experiment_new_paper.py` for different configurations, stores the results in the given directories, and repeats this process for various consumer `1 5 10 15 20 25` counts and height files (3, 5, 7, 9).


