---
title: SF Food Trucks
---

The app that we're going to Dockerize is called SF Food Trucks. My goal in building this app was to have something that is useful (in that it resembles a real-world application), relies on at least one service, but is not too complex for the purpose of this tutorial. This is what I came up with.

![SF Food trucks](../../../assets/foodtrucks.webp)

The app's backend is written in Python (Flask) and for search it uses [Elasticsearch](https://www.elastic.co/products/elasticsearch). Like everything else in this tutorial, the entire source is available on [Github](http://github.com/prakhar1989/FoodTrucks). We'll use this as our candidate application for learning out how to build, run and deploy a multi-container environment.

First up, let's clone the repository locally.

```bash
$ git clone https://github.com/prakhar1989/FoodTrucks
$ cd FoodTrucks
$ tree -L 2
.
├── Dockerfile
├── README.md
├── aws-compose.yml
├── docker-compose.yml
├── flask-app
│   ├── app.py
│   ├── package-lock.json
│   ├── package.json
│   ├── requirements.txt
│   ├── static
│   ├── templates
│   └── webpack.config.js
├── setup-aws-ecs.sh
├── setup-docker.sh
├── shot.png
└── utils
    ├── generate_geojson.py
    └── trucks.geojson
```

The `flask-app` folder contains the Python application, while the `utils` folder has some utilities to load the data into Elasticsearch. The directory also contains some YAML files and a Dockerfile, all of which we'll see in greater detail as we progress through this tutorial. If you are curious, feel free to take a look at the files.

Now that you're excited (hopefully), let's think of how we can Dockerize the app. We can see that the application consists of a Flask backend server and an Elasticsearch service. A natural way to split this app would be to have two containers - one running the Flask process and another running the Elasticsearch (ES) process. That way if our app becomes popular, we can scale it by adding more containers depending on where the bottleneck lies.

Great, so we need two containers. That shouldn't be hard right? We've already built our own Flask container in the previous section. And for Elasticsearch, let's see if we can find something on the hub.

```bash
$ docker search elasticsearch
NAME                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
elasticsearch                     Elasticsearch is a powerful open source se...   697       [OK]
itzg/elasticsearch                Provides an easily configurable Elasticsea...   17                   [OK]
tutum/elasticsearch               Elasticsearch image - listens in port 9200.     15                   [OK]
barnybug/elasticsearch            Latest Elasticsearch 1.7.2 and previous re...   15                   [OK]
digitalwonderland/elasticsearch   Latest Elasticsearch with Marvel & Kibana       12                   [OK]
monsantoco/elasticsearch          ElasticSearch Docker image                      9                    [OK]
```

Quite unsurprisingly, there exists an officially supported [image](https://store.docker.com/images/elasticsearch) for Elasticsearch. To get ES running, we can simply use `docker run` and have a single-node ES container running locally within no time.

> Note: Elastic, the company behind Elasticsearch, maintains its [own registry](https://www.docker.elastic.co/) for Elastic products. It's recommended to use the images from that registry if you plan to use Elasticsearch.

Let's first pull the image

```bash
$ docker pull docker.elastic.co/elasticsearch/elasticsearch:6.3.2
```

and then run it in development mode by specifying ports and setting an environment variable that configures the Elasticsearch cluster to run as a single-node.

```bash
$ docker run -d --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.3.2
277451c15ec183dd939e80298ea4bcf55050328a39b04124b387d668e3ed3943
```

> Note: If your container runs into memory issues, you might need to [tweak some JVM flags](https://github.com/elastic/elasticsearch-docker/issues/43#issuecomment-289377878) to limit its memory consumption.

As seen above, we use `--name es` to give our container a name which makes it easy to use in subsequent commands. Once the container is started, we can see the logs by running `docker container logs` with the container name (or ID) to inspect the logs. You should see logs similar to below if Elasticsearch started successfully.

> Note: Elasticsearch takes a few seconds to start so you might need to wait before you see `initialized` in the logs.

```bash
$ docker container ls
CONTAINER ID        IMAGE                                                 COMMAND                  CREATED             STATUS              PORTS                                            NAMES
277451c15ec1        docker.elastic.co/elasticsearch/elasticsearch:6.3.2   "/usr/local/bin/dock…"   2 minutes ago       Up 2 minutes        0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp   es

$ docker container logs es
[2018-07-29T05:49:09,304][INFO ][o.e.n.Node               ] [] initializing ...
[2018-07-29T05:49:09,385][INFO ][o.e.e.NodeEnvironment    ] [L1VMyzt] using [1] data paths, mounts [[/ (overlay)]], net usable_space [54.1gb], net total_space [62.7gb], types [overlay]
[2018-07-29T05:49:09,385][INFO ][o.e.e.NodeEnvironment    ] [L1VMyzt] heap size [990.7mb], compressed ordinary object pointers [true]
[2018-07-29T05:49:11,979][INFO ][o.e.p.PluginsService     ] [L1VMyzt] loaded module [x-pack-security]
[2018-07-29T05:49:11,980][INFO ][o.e.p.PluginsService     ] [L1VMyzt] loaded module [x-pack-sql]
[2018-07-29T05:49:11,980][INFO ][o.e.p.PluginsService     ] [L1VMyzt] loaded module [x-pack-upgrade]
[2018-07-29T05:49:11,980][INFO ][o.e.p.PluginsService     ] [L1VMyzt] loaded module [x-pack-watcher]
[2018-07-29T05:49:11,981][INFO ][o.e.p.PluginsService     ] [L1VMyzt] loaded plugin [ingest-geoip]
[2018-07-29T05:49:11,981][INFO ][o.e.p.PluginsService     ] [L1VMyzt] loaded plugin [ingest-user-agent]
[2018-07-29T05:49:17,659][INFO ][o.e.d.DiscoveryModule    ] [L1VMyzt] using discovery type [single-node]
[2018-07-29T05:49:18,962][INFO ][o.e.n.Node               ] [L1VMyzt] initialized
[2018-07-29T05:49:18,963][INFO ][o.e.n.Node               ] [L1VMyzt] starting ...
[2018-07-29T05:49:19,218][INFO ][o.e.t.TransportService   ] [L1VMyzt] publish_address {172.17.0.2:9300}, bound_addresses {0.0.0.0:9300}
[2018-07-29T05:49:19,302][INFO ][o.e.x.s.t.n.SecurityNetty4HttpServerTransport] [L1VMyzt] publish_address {172.17.0.2:9200}, bound_addresses {0.0.0.0:9200}
[2018-07-29T05:49:19,303][INFO ][o.e.n.Node               ] [L1VMyzt] started
[2018-07-29T05:49:19,439][WARN ][o.e.x.s.a.s.m.NativeRoleMappingStore] [L1VMyzt] Failed to clear cache for realms [[]]
[2018-07-29T05:49:19,542][INFO ][o.e.g.GatewayService     ] [L1VMyzt] recovered [0] indices into cluster_state
```

Now, lets try to see if can send a request to the Elasticsearch container. We use the `9200` port to send a `cURL` request to the container.

```bash
$ curl 0.0.0.0:9200
{
  "name" : "ijJDAOm",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "a_nSV3XmTCqpzYYzb-LhNw",
  "version" : {
    "number" : "6.3.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "053779d",
    "build_date" : "2018-07-20T05:20:23.451332Z",
    "build_snapshot" : false,
    "lucene_version" : "7.3.1",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

Sweet! It's looking good! While we are at it, let's get our Flask container running too. But before we get to that, we need a `Dockerfile`. In the last section, we used `python:3.8` image as our base image. This time, however, apart from installing Python dependencies via `pip`, we want our application to also generate our minified Javascript file for production. For this, we'll require Nodejs. Since we need a custom build step, we'll start from the `ubuntu` base image to build our `Dockerfile` from scratch.

> Note: if you find that an existing image doesn't cater to your needs, feel free to start from another base image and tweak it yourself. For most of the images on Docker Hub, you should be able to find the corresponding `Dockerfile` on Github. Reading through existing Dockerfiles is one of the best ways to learn how to roll your own.

Our [Dockerfile](https://github.com/prakhar1989/FoodTrucks/blob/master/Dockerfile) for the flask app looks like below -

```dockerfile
# start from base
FROM ubuntu:18.04

MAINTAINER Prakhar Srivastav <prakhar@prakhar.me>

# install system-wide deps for python and node
RUN apt-get -yqq update
RUN apt-get -yqq install python3-pip python3-dev curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -yq nodejs

# copy our application code
ADD flask-app /opt/flask-app
WORKDIR /opt/flask-app

# fetch app specific deps
RUN npm install
RUN npm run build
RUN pip3 install -r requirements.txt

# expose port
EXPOSE 5000

# start app
CMD [ "python3", "./app.py" ]
```

Quite a few new things here so let's quickly go over this file. We start off with the [Ubuntu LTS](https://wiki.ubuntu.com/LTS) base image and use the package manager `apt-get` to install the dependencies namely - Python and Node. The `yqq` flag is used to suppress output and assumes "Yes" to all prompts.

We then use the `ADD` command to copy our application into a new volume in the container - `/opt/flask-app`. This is where our code will reside. We also set this as our working directory, so that the following commands will be run in the context of this location. Now that our system-wide dependencies are installed, we get around to installing app-specific ones. First off we tackle Node by installing the packages from npm and running the build command as defined in our `package.json` [file](https://github.com/prakhar1989/FoodTrucks/blob/master/flask-app/package.json#L7-L9). We finish the file off by installing the Python packages, exposing the port and defining the `CMD` to run as we did in the last section.

Finally, we can go ahead, build the image and run the container (replace `prakhar1989` with your username below).

```bash
$ docker build -t prakhar1989/foodtrucks-web .
```

In the first run, this will take some time as the Docker client will download the ubuntu image, run all the commands and prepare your image. Re-running `docker build` after any subsequent changes you make to the application code will almost be instantaneous. Now let's try running our app.

```bash
$ docker run -P --rm prakhar1989/foodtrucks-web
Unable to connect to ES. Retying in 5 secs...
Unable to connect to ES. Retying in 5 secs...
Unable to connect to ES. Retying in 5 secs...
Out of retries. Bailing out...
```

Oops! Our flask app was unable to run since it was unable to connect to Elasticsearch. How do we tell one container about the other container and get them to talk to each other? The answer lies in the next section.