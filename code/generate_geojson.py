import json
import requests

def getData(url):
    r = requests.get(url)
    return r.json()

def convertData(data, msymbol="restaurant", msize="medium"):
    data_dict = []
    for d in data:
        if d.get('longitude') and d.get("latitude"):
            data_dict.append({
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [float(d["longitude"]),
                                    float(d["latitude"])]
                },
                "properties": {
                    "name": d.get("applicant", ""),
                    "marker-symbol": msymbol,
                    "marker-size": msize,
                    "marker-color": "#CC0033",
                    "fooditems": d.get('fooditems', ""),
                    "address": d.get("address", "")
                }
            })
    return data_dict

def writeToFile(data, filename="data.geojson"):
    template = {
                "type": "FeatureCollection",
                "crs": {
                    "type": "name",
                    "properties": {
                      "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
                    },
                },
                "features": data }
    with open(filename, "w") as f:
        json.dump(template, f, indent=2)
    print "Geojson generated"

if __name__ == "__main__":
    data = getData("http://data.sfgov.org/resource/rqzj-sfat.json")
    writeToFile(convertData(data[:350]), filename="trucks.geojson")
