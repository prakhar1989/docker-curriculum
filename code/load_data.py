import requests
import sys
from elasticsearch import Elasticsearch
from optparse import OptionParser


usage = "%prog [options]\n\
       eg. python %prog -p 9200 -i 127.0.0.1"

parser = OptionParser(usage)
parser.add_option("-p", "--port", action="store",
                  help="port number of the ES service")
parser.add_option("-i", "--ip", action="store",
                  help="ip / host name of the ES service")

def getData(url):
    r = requests.get(url)
    return r.json()

def loadToES(es):
    url = "http://data.sfgov.org/resource/rqzj-sfat.json"
    data = getData(url)
    print "Loading data ..."
    for id, truck in enumerate(data):
        res = es.index(index="sfdata", doc_type="truck", id=id, body=truck)
    print "Total trucks loaded: ", len(data)

if __name__ == "__main__":
    (options, args) = parser.parse_args()
    if not options.ip or not options.port:
        print "Please provide port and ip. see -h"
        sys.exit()
    es = Elasticsearch(options.ip, port=options.port)
    loadToES(es)
