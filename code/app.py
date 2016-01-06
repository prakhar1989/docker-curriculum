from elasticsearch import Elasticsearch
from flask import Flask, jsonify, request
from urllib3 import exceptions

from elasticsearch import Elasticsearch
es = Elasticsearch()

app = Flask(__name__)

@app.route('/')
def index():
    return "hello world"

@app.route('/debug')
def test_es():
    resp = {}
    try:
        msg = es.cat.indices()
        resp["msg"] = msg
        resp["status"] = "success"
    except:
        resp["status"] = "failure"
        resp["msg"] = "Unable to reach ES"
    return jsonify(resp)

@app.route('/search')
def search():
    key = request.args.get('q')
    if not key:
        return "nothing found"
    res = es.search(index="sfdata", body={"query":
      {"match": {"fooditems": key}}
    })
    return jsonify(res["hits"])

if __name__ == "__main__":
    app.run(host="0.0.0.0")
