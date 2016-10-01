# Instructions copied from - https://hub.docker.com/_/python/
FROM python:3-onbuild

# tell the port number the container should expose
EXPOSE 5000

# Run as non-root user, for Heroku
RUN useradd -m myuser
USER myuser

# run the command
CMD ["python", "./app.py"]
