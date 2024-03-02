## MISX
- hgt = height (3, 5, 7, 9) 
- con = number of consumer (2,4,6,8,10,12,14) 
  -- each consumer is a node, and each of them have additional 5 consumer attached. So number of consumer in each node is 2 = 10, 4 = 20 ..... 14 = 70 
- tt = time used to transfer a file, either video or height
- gp = Goodput achieved when transfering the file
- minrtt = min RTT
- avgrtt = Average RTT
- maxrtt = Maximum RTT

## experiment setup:
- one producer and variable number of consumer i.e. 10, 20, 30.....70
- transferred both height and video files

## results:
- result_vid and result_height contains the computed average results
