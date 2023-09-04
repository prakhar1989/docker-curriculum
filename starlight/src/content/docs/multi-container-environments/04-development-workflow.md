---
title: Development Workflow
---

Before we jump to the next section, there's one last thing I wanted to cover about docker-compose. As stated earlier, docker-compose is really great for development and testing. So let's see how we can configure compose to make our lives easier during development.

Throughout this tutorial, we've worked with readymade docker images. While we've built images from scratch, we haven't touched any application code yet and mostly restricted ourselves to editing Dockerfiles and YAML configurations. One thing that you must be wondering is how does the workflow look during development? Is one supposed to keep creating Docker images for every change, then publish it and then run it to see if the changes work as expected? I'm sure that sounds super tedious. There has to be a better way. In this section, that's what we're going to explore.

Let's see how we can make a change in the Foodtrucks app we just ran. Make sure you have the app running,

```bash
$ docker container ls
CONTAINER ID        IMAGE                                                 COMMAND                  CREATED             STATUS              PORTS                              NAMES
5450ebedd03c        prakhar1989/foodtrucks-web                            "python3 app.py"         9 seconds ago       Up 6 seconds        0.0.0.0:5000->5000/tcp             foodtrucks_web_1
05d408b25dfe        docker.elastic.co/elasticsearch/elasticsearch:6.3.2   "/usr/local/bin/dock…"   10 hours ago        Up 10 hours         0.0.0.0:9200->9200/tcp, 9300/tcp   es
```

Now let's see if we can change this app to display a `Hello world!` message when a request is made to `/hello` route. Currently, the app responds with a 404.

```bash
$ curl -I 0.0.0.0:5000/hello
HTTP/1.0 404 NOT FOUND
Content-Type: text/html
Content-Length: 233
Server: Werkzeug/0.11.2 Python/2.7.15rc1
Date: Mon, 30 Jul 2018 15:34:38 GMT
```

Why does this happen? Since ours is a Flask app, we can see `app.py` ([link](https://github.com/prakhar1989/FoodTrucks/blob/master/flask-app/app.py#L48-L64)) for answers. In Flask, routes are defined with @app.route syntax. In the file, you'll see that we only have three routes defined - `/`,`/debug`and`/search`. The`/`route renders the main app, the`debug`route is used to return some debug information and finally`search` is used by the app to query elasticsearch.

```bash
$ curl 0.0.0.0:5000/debug
{
  "msg": "yellow open sfdata Ibkx7WYjSt-g8NZXOEtTMg 5 1 618 0 1.3mb 1.3mb\n",
  "status": "success"
}
```

Given that context, how would we add a new route for `hello`? You guessed it! Let's open `flask-app/app.py` in our favorite editor and make the following change

```python
@app.route('/')
def index():
  return render_template("index.html")

# add a new hello route
@app.route('/hello')
def hello():
  return "hello world!"
```

Now let's try making a request again

```bash
$ curl -I 0.0.0.0:5000/hello
HTTP/1.0 404 NOT FOUND
Content-Type: text/html
Content-Length: 233
Server: Werkzeug/0.11.2 Python/2.7.15rc1
Date: Mon, 30 Jul 2018 15:34:38 GMT
```

Oh no! That didn't work! What did we do wrong? While we did make the change in `app.py`, the file resides in our machine (or the host machine), but since Docker is running our containers based off the `prakhar1989/foodtrucks-web` image, it doesn't know about this change. To validate this, lets try the following -

```
$ docker-compose run web bash
Starting es ... done
root@581e351c82b0:/opt/flask-app# ls
app.py        package-lock.json  requirements.txt  templates
node_modules  package.json       static            webpack.config.js
root@581e351c82b0:/opt/flask-app# grep hello app.py
root@581e351c82b0:/opt/flask-app# exit
```

What we're trying to do here is to validate that our changes are not in the `app.py` that's running in the container. We do this by running the command `docker-compose run`, which is similar to its cousin `docker run` but takes additional arguments for the service (which is `web` in our [case](https://github.com/prakhar1989/FoodTrucks/blob/master/docker-compose.yml#L12)). As soon as we run `bash`, the shell opens in `/opt/flask-app` as specified in our [Dockerfile](https://github.com/prakhar1989/FoodTrucks/blob/master/Dockerfile#L13). From the grep command we can see that our changes are not in the file.

Lets see how we can fix it. First off, we need to tell docker compose to not use the image and instead use the files locally. We'll also set debug mode to `true` so that Flask knows to reload the server when `app.py` changes. Replace the `web` portion of the `docker-compose.yml` file like so:

```yaml
version: "3"
services:
  es:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.3.2
    container_name: es
    environment:
      - discovery.type=single-node
    ports:
      - 9200:9200
    volumes:
      - esdata1:/usr/share/elasticsearch/data
  web:
    build: . # replaced image with build
    command: python3 app.py
    environment:
      - DEBUG=True # set an env var for flask
    depends_on:
      - es
    ports:
      - "5000:5000"
    volumes:
      - ./flask-app:/opt/flask-app
volumes:
  esdata1:
    driver: local
```

With that change ([diff](https://github.com/prakhar1989/FoodTrucks/commit/31368936de5959efaf4457a94c678d21e3eefbce)), let's stop and start the containers.

```bash
$ docker-compose down -v
Stopping foodtrucks_web_1 ... done
Stopping es               ... done
Removing foodtrucks_web_1 ... done
Removing es               ... done
Removing network foodtrucks_default
Removing volume foodtrucks_esdata1

$ docker-compose up -d
Creating network "foodtrucks_default" with the default driver
Creating volume "foodtrucks_esdata1" with local driver
Creating es ... done
Creating foodtrucks_web_1 ... done
```

As a final step, lets make the change in `app.py` by adding a new route. Now we try to curl

```bash
$ curl 0.0.0.0:5000/hello
hello world
```

Wohoo! We get a valid response! Try playing around by making more changes in the app.

That concludes our tour of Docker Compose. With Docker Compose, you can also pause your services, run a one-off command on a container and even scale the number of containers. I also recommend you checkout a few other [use-cases](https://docs.docker.com/compose/overview/#common-use-cases) of Docker compose. Hopefully, I was able to show you how easy it is to manage multi-container environments with Compose. In the final section, we are going to deploy our app to AWS!