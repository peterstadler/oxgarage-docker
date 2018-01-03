# OxGarage Docker Image

This is the Docker image description for [OxGarage](https://github.com/TEIC/oxgarage), a "a web, and RESTful, service to manage the transformation of documents between a variety of formats."

## Build

Install [Docker](https://www.docker.com) for your OS, change into the root directory of the current repo and enter 

```
# docker build -t oxgarage . 
```

This will create an image with the tag "oxgarage".

## Dependencies

For running the image you'll need to have the TEI Stylesheets as well as the TEI P5 sources.
There are several ways to obtain these (see "Get and install a local copy" at http://www.tei-c.org/Guidelines/P5/),  
one of them is to download the latest release of both 
[TEI](https://github.com/TEIC/TEI/releases) and [Stylesheets](https://github.com/TEIC/Stylesheets/releases) from GitHub.

## Run

To run the image, enter

```
# docker run --rm \
    -p 8080:8080
    -v /your/path/to/Stylesheets:/usr/share/xml/tei/stylesheet \ 
    -v /your/path/to/TEI/P5:/usr/share/xml/tei/odd \
    -e WEBSERVICE_URL=http://localhost:8080/ege-webservice/   
    --name oxgarage oxgarage:latest
``` 

This will run the image and propagate the container port 8080 to your local port 8080.

### available parameters

* **WEBSERVICE_URL** : The full URL of the RESTful *web service*. 
    This is relevant for the *web client* (aka the GUI) if you are running the docker container on a different port
    or with a different URL.
