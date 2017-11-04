# OxGarage Docker Image

This is the Docker image description for [OxGarage](https://github.com/TEIC/oxgarage), a "a web, and RESTful, service to manage the transformation of documents between a variety of formats."

## Build

Install [Docker](https://www.docker.com) for your OS, change into the root directory of the current repo and enter 

```
# docker build -t oxgarage . 
```

This will create an image with the tag "oxgarage".

## Run

To run the image, enter

```
# docker run -p 8080:8080 --rm --name oxgarage oxgarage:latest        
``` 

This will run the image and propagate the container port 8080 to your local port 8080.
