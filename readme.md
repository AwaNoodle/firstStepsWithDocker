# AwaNoodle/firstStepsWithDocker

## The Demo Environment

A starting point for a Docker demo. 

Make sure you've installed Vagrant and VirtualBox and then 
    
    > vagrant up

The machine will start up and download the latest version of Docker, Docker-Compose, and add some base images needed for the session.

We are making use of
- [Grafana Official](https://hub.docker.com/r/grafana/grafana/)
- [Tutum InfluxDb](https://hub.docker.com/r/tutum/influxdb/)
- [Kitematic Nginx Hello World](https://hub.docker.com/r/kitematic/hello-world-nginx/)

## Exercises

For all exercises, you will need to remote into the virtual machine created by Vagrant. You can do this easily with 

    > vagrant ssh

### Exercise 1 - Testing Docker is Working

Our first exercise is to show that Docker is installed and working correctly. We can show this by running a simple container. For this, we are going to use the [Whalesay](https://hub.docker.com/r/docker/whalesay/) container. 

On the VM command line type:

    > docker run docker/whalesay cowsay "Hello from Docker"
    Unable to find image 'docker/whalesay:latest' locally
    latest: Pulling from docker/whalesay
    e9e06b06e14c: Pull complete
    a82efea989f9: Pull complete
    ... elided ...
    Status: Downloaded newer image for docker/whalesay:latest

What we are seeing is Docker looking for the container image locally, and when it doesn't find it, it's pulling down the image. 

Each of the hashcodes represents a layer. A Docker image is made of layers, which when put together, form your full image. You can read more about images [here](http://tuhrig.de/layering-of-docker-images/). You can see a visual representation of the **docker/whalesay** container using [ImageLayer.io](https://imagelayers.io/?images=docker%2Fwhalesay:latest)

Once the image has downloaded, you should see a fancy picture of a Whale saying hello. You've consumed your first Docker container!

What has happened is we've asked Docker to run the Whalesay application. It's not found it locally, so it's gone to online to find the image and pull it down. Once the image was down it's started an instance of the container which executed the Whalesay application and produced the output on screen. Once Whalesay exited, the container shut down, it's job being done. 

We can see the instance of the container in the Docker process list. While the application and instance have stopped, it will stay resident until we remove it. 

    > docker ps -a

The process list will show you an exited container using the docker/whalesay image. The first line will be the container ID. Take a copy of that ID and type:

    > docker rm <the container ID here>

The container will be removed. 

## Examples

The examples folder contains an example Dockerfile from the **kitematic/nginx-hello-world** project. It also contains an example on a small stack with Docker-Compose.
