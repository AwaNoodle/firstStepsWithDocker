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

## Examples

The examples folder contains an example Dockerfile from the **kitematic/nginx-hello-world** project. It also contains an example on a small stack with Docker-Compose.
