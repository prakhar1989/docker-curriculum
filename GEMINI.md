# Project Overview

This repository contains the source code for the Docker Curriculum, an interactive tutorial for learning Docker. The project consists of three main parts:

1.  **Tutorial Content:** The core curriculum is written in Markdown and generated into a static website using Metalsmith. The source files are located in the `tutorial/src` directory.
2.  **Flask Application:** A simple Python Flask application is included as a practical example for demonstrating how to containerize a web application. The source code for this application is in the `flask-app` directory.
3.  **Documentation Website:** A documentation website built with Astro and Starlight provides a structured way to navigate the curriculum. The source for this site is in the `starlight` directory.

The main technologies used in this project are:

*   **Node.js:** For building the static tutorial website.
*   **Metalsmith:** A static site generator used for the tutorial.
*   **Python/Flask:** For the example web application.
*   **Astro/Starlight:** For the documentation website.
*   **Docker:** The subject of the curriculum.

# Building and Running

To build and run the tutorial website locally, you can use the following commands:

```bash
# Install dependencies
npm install

# Build the static site and watch for changes
npm run generate

# Serve the website
npm run serve

# Run all of the above in parallel
npm start
```

To run the Flask application, you will need to have Python and Flask installed. You can then run the following command from the `flask-app` directory:

```bash
python app.py
```

# Development Conventions

The project uses `nodemon` for automatically restarting the server during development and `browser-sync` for live-reloading the website. The `package.json` file contains a `css-watch` script for compiling SASS to CSS.
