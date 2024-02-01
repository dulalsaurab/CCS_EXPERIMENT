import argparse
import sys
from time import sleep
from pathlib import Path
from subprocess import Popen, PIPE
from os import listdir
from os.path import isfile, join

from mininet.log import setLogLevel, info
from minindn.minindn import Minindn
from mininet.topo import Topo
from minindn.util import MiniNDNCLI
from minindn.apps.app_manager import AppManager
from minindn.apps.nfd import Nfd
from minindn.apps.nlsr import Nlsr

def start(ndn):
    ndn.start()
    AppManager(ndn, ndn.net.hosts, Nfd, logLevel='DEBUG')
    AppManager(ndn, ndn.net.hosts, Nlsr, logLevel='INFO')
    print ("Waiting for NLSR Convergence")
    sleep(300)

def sendFile(node, prefix, path, file, identifier): #filename = filename+filedir
    filePath = '{}/{}'.format(path, file)
    print ("Publishing prefix, file , filepath: ", prefix, file, filePath)
    cmd = 'ndnputchunks {} < {} > chunk_{}_{}.log 2>&1 &'.format(prefix, filePath, file, identifier)
    node.cmd(cmd)
    sleep(3)

def receiveFile(node, prefix, file, identifier):
    cmd = 'ndncatchunks {} > video.{} 2> chunk_{}_{}.log &'.format(prefix, identifier, file, identifier)
    node.cmd(cmd)

def configureProducers(producers):
    for producer in producers:
        host = producers[producer]['host']
        for prefix in producers[producer]['prefix']:
            print( "Prefix Name: ", prefix, "Host Name: ", host.name)
            host.cmd('nlsrc advertise {}'.format(prefix))
            sleep(2)

def sendReceiveHandler(ndn, host, prefix, path, files, type, sleeptime, consumers):
    # publish file or files
    for file in files:
        sendFile(host, prefix, path, file, type)
    # sleep sometime and let files to get publish
    sleep(sleeptime)
    for consumer in consumers:
        for file in files:
            receiveFile(ndn.net[consumer], prefix, file, type)

if __name__ == '__main__':
    setLogLevel('info')
    Popen(['rm','-r', '/tmp/minindn/'], stdout=PIPE, stderr=PIPE).communicate()
    prod = 'urjc'
    # prod = 'a'

    # -------- topo section --------------------
    producers = [prod]
    consumers = ["univh2c", "minho", "msu", "aveiro", "basel"]
    # consumers = ["univh2c", "minho", "msu", "aveiro", "basel", "wu", "neu", "uaslp", "uiuc", "copelabs"]
    # consumers = ["univh2c", "minho", "msu", "aveiro", "basel", "wu", "neu", "uaslp", "uiuc", "copelabs", "padua","cnic","lip6", "anyang", "ufba"]
    # consumers = ["univh2c", "minho", "msu", "aveiro", "basel", "wu", "neu", "uaslp", "uiuc", "copelabs", "padua","cnic","lip6", "anyang", "ufba", "mumbai_aws", "gist", "lacl", "michigan", "afa"]
    # consumer count 5, 10, 15, 20
    # --------- end ----------------------------

    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--file",  dest = "filename", help="input encrypted video file")
    parser.add_argument("-a", "--height",  dest = "height_file", help="input height file")

    ndn = Minindn(parser=parser)
    args = ndn.args
    consumers = [x.name for x in ndn.net.hosts if x.name in consumers]

    absFilePath = str(Path(args.filename).resolve())
    heightFilePath = str(Path(args.height_file).resolve())

    if not args.filename:
        print ("Missing file, please supply filename")
        exit(0)

    print (absFilePath.split("/")[-1], heightFilePath.split("/")[-1])
    files = [absFilePath.split("/")[-1], heightFilePath.split("/")[-1]]

    print (files)
    producers = {prod: {'host': ndn.net[prod], 'prefix': ['/prod/'+prod+'/video', '/prod/'+prod+'/height']}}

    print(producers)
    start(ndn)

    configureProducers(producers)

    producer = ndn.net[prod]
    cmdV = 'ndnputchunks {} < {} > chunk_{}_{}.log 2>&1 &'.format(producers[prod]['prefix'][0], absFilePath, files[0], 'video')
    cmdH = 'ndnputchunks {} < {} > chunk_{}_{}.log 2>&1 &'.format(producers[prod]['prefix'][1], heightFilePath, files[1], 'height')
    producer.cmd(cmdV)
    sleep(10)
    producer.cmd(cmdH)
    sleep(10)

    for consumer in consumers:
        receiveFile(ndn.net[consumer], producers[prod]['prefix'][0], files[0], 'video')
        receiveFile(ndn.net[consumer], producers[prod]['prefix'][1], files[1], 'height')

    # sleep(100)
    MiniNDNCLI(ndn.net)

    ndn.stop()
