import requests
from elasticsearch import Elasticsearch

es = Elasticsearch()

def getData(url):
    r = requests.get(url)
    return r.json()

def loadToES():
    url = "http://data.sfgov.org/resource/rqzj-sfat.json"
    data = getData(url)
    print "Loading data ..."
    for id, truck in enumerate(data):
        res = es.index(index="sfdata", doc_type="truck", id=id, body=truck)
    print "Total trucks loaded: ", len(data)

if __name__ == "__main__":
    loadToES()
