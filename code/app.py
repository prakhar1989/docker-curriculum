from elasticsearch import Elasticsearch
from flask import Flask, jsonify, request

es = Elasticsearch()
app = Flask(__name__)

@app.route('/')
def index():
    return "hello world"

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
    app.run(debug=True)
