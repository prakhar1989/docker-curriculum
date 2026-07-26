# Project Overview

This repository contains the source code for the Docker Curriculum, an interactive tutorial for learning Docker. The project consists of two main parts:

1. **Documentation Website:** An interactive, responsive tutorial site built with **Astro and Starlight**. The source content is located in the `starlight` directory.
2. **Flask Application:** A simple Python Flask application included as a practical example for demonstrating how to containerize a web application. The source code is in the `flask-app` directory.

The main technologies used in this project are:

* **Node.js:** For building the static tutorial website.
* **Astro / Starlight:** Modern static site generator and documentation framework used for the curriculum.
* **Python / Flask:** For the example web application.
* **Docker:** The subject of the curriculum.

# Building and Running

To build and run the tutorial website locally:

```bash
# Install dependencies in the starlight app
npm --prefix starlight install

# Run the local development server (http://localhost:4321)
npm run dev

# Build the production static site
npm run build
```

To run the Flask application locally:

```bash
python flask-app/app.py
```
