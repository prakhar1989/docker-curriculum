# Tutorial 
# https://docker-curriculum.com/#our-first-image

# We start with specifying our base image.
FROM python:3.8

# The next step usually is to write the commands of copying the files and installing the dependencies. 
# First, we set a working directory and then copy all the files for our app.
# set a direcotry for the app
WORKDIR /usr/src/app

# copy all the files to the container
COPY . .

# install dependancies
RUN pip install --no-cache-dir -r requirements.txt
# RUN pip install --no-cache-dir

# expose the working port
EXPOSE 5000

# The last step is to write the command for running the application, which is simply - python ./app.py. We use the CMD command to do that -
CMD ["python", "./app.py"]

# Now that we have our Dockerfile, we can build our image. The docker build command does the heavy-lifting of creating a Docker image from a Dockerfile.

# Before you run the command yourself (don't forget the period), make sure to replace my username with yours. 
# This username should be the same one you created when you registered on Docker hub. If you haven't done that yet, please go ahead and create an account. 
# The docker build command is quite simple - it takes an optional tag name with -t and a location of the directory containing the Dockerfile.

# build command
# docker build -t yourusername/catnip .
# docker build -t netjimb/catnip .

# The last step in this section is to run the image and see if it actually works (replacing my username with yours).
# docker run -p 8888:5000 yourusername/catnip
# docker run -p 8888:5000 netjimb/catnip