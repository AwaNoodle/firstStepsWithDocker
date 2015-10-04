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


![Exercise 1 Demo](/exercises/exercise1/demo.gif)


What we are seeing is Docker looking for the container image locally, and when it doesn't find it, it's pulling down the image. 

Each of the hash codes represents a layer. A Docker image is made of layers, which when put together, form your full image. You can read more about images [here](http://tuhrig.de/layering-of-docker-images/). You can see a visual representation of the **docker/whalesay** container using [ImageLayer.io](https://imagelayers.io/?images=docker%2Fwhalesay:latest)

Once the image has downloaded, you should see a fancy picture of a Whale saying hello. You've consumed your first Docker container!

What has happened is we've asked Docker to run the Whalesay application. It's not found it locally, so it's gone to online to find the image and pull it down. Once the image was down it's started an instance of the container which executed the Whalesay application and produced the output on screen. Once Whalesay exited, the container shut down, it's job being done. 

We can see the instance of the container in the Docker process list. While the application and instance have stopped, it will stay resident until we remove it. 

    > docker ps -a

The process list will show you an exited container using the docker/whalesay image. The first line will be the container ID. Take a copy of that ID and type:

    > docker rm <the container ID here>

If you check the Docker process list you will see the container will now be removed. 


## Exercise 2 - Using nginx

Lets use Docker to run a service that we can use to provide a more useful service, like providing a web server to host a site.

We are going to use the kitematic/hello-world-nginx container to run nginx. This provides an instance of nginx which is configured to serve a website from a known location. Lets get the container up and running.

Unlike Whalesay, nginx isn't going to exit quickly. As you'd expect, nginx will run like a service and stay resident until we tell it to stop. If we were to run this like Whalesay, nginx would start up and tie up the terminal until we exited it with ctrl-c. A better approach would be to run nginx in the background. We can do this with the **-d** switch to run the container detached. 

We also need to be able to talk to nginx. The container was created to expose port 80 which nginx is in turn set to listen to. While nginx is listening to port 80 in the container, we still need to tell Docker how we want to bind that port to one on the VM (which is the Docker host). This gives us a point of indirection where we can listen on a VM port (say 9876) and bind that to port 80 on the container. Since we are dealing with a VM built by Vagrant, we have another level of indirection where we need to consider how Vagrant exposes the port to the host. Essentially, with our VM, we end up with

Host Machine (port 9123) -> Vagrant VM (9123 forwards to 80) -> Docker (80 forward to 80)

We tell Docker to bind ports using the **-p** switch, in the form of **-p \<host port\>:\<container port\>**. 

We also want to give our instance a name, instead of relying on a hash code or auto-generated name. Simply, we do this using the **--name** switch.

Putting this all together, this looks like:

    > docker run -d -p 80:80 --name nginx kitematic/hello-world-nginx

The container will now (quickly) start. If you check the Docker process list you will see that the container has started and is showing some uptime. 

On your host machine (not the VM), if you navigate to [http://localhost:9123] you should see a Kitematic Hello World page.

![Running nginx](/exercises/exercise2/demoA.gif)

This is pretty cool: we have a website up and running with next to no time or effort involved. Still, serving someone else's page isn't too much use. We need to be able to supply our own site. We can do this using Mount Points. 

The creator of a container can set paths inside the container than can be redirected to a path of our choose. While the path set by the container author exists only in the container, we can essentially override this to supply files from the Docker hosts file system (our VM). The application in the container still sees this as the original path but we now control the content. 

Mount points are exposed via the **-v** switch, following the pattern of **-v \<full host path\>:\<container mount point path\>**. For the Kitematic container, the author has added a mount point at **/website_files**. Lets override this by stopping and removing our current container and then creating a new one:

    > docker rm $(docker stop nginx)
    > mkdir /vagrant/ourWebsite
    > docker run -d -p 80:80 -v /vagrant/ourWebsite:/website_files --name nginx kitematic/hello-world-nginx

If you navigate to the site on [http://localhost:9123] you will see the same page. However, it's now being served from our folder. We can see this if we look in the folder:

    > ls /vagrant/ourWebsite
    index.html

The index.html has been added by the container. We can now edit this file and supply our own content. Since the folder was created in **/vagrant** it will be available on your host machine in the project folder. Find and open the file and change the content. Once you've finished, save the file and refresh the page.

![Running nginx](/exercises/exercise2/demoB.gif)

You can see the mount point and ports defined for the container in the [Dockerfile](/exercises/exercise2/Dockerfile) used to build the container

## Exercise 3 - Creating a Stack with Docker

We will often want to run several containers together to provide some capability, such as an ELK stack. While it's simple enough to start up and control several containers, it's easier to manage them all together. For this, we can use [Docker-Compose](https://docs.docker.com/compose/) to define the containers we want to run together and to manage starting and stopping them.

For this exercise, we are going to create a simple monitoring stack using [InfluxDb](https://influxdb.com/) and [Grafana](http://grafana.org/). We are going to use the [tutum/influxdb](https://hub.docker.com/r/tutum/influxdb/) and [official Grafana](https://hub.docker.com/r/grafana/grafana/) containers to achieve this.

Inside the exercises/exercise3 folder is a pre-built Docker Compose yml file, [docker-compose.yml](/exercises/exercise3/docker-compose.yml). Lets have a look at what it does:

```yml
influx:
  container_name: influxdb
  image: tutum/influxdb
  ports:
    - "8083:8083"
    - "8086:8086"
  environment:
    - PRE_CREATE_DB=db1
graphana:
  container_name: grafana
  image: grafana/grafana
  stdin_open: true
  ports: 
    - "3000:3000"
  environment:
    - GF_AUTH_ANONYMOUS_ENABLED=false
```

We're not doing anything complex here, just telling Docker-Compose to bring up and configure the two containers. Most of the options should be familiar as we've covered them before, there are a few new ones:
- **environment** is essentially the same as supplying the **-e** argument to **docker run**. It will set an environment variable in the container which will be picked up by the software running inside. Influx is using it to create a database for us. Grafana is turning off anonymous authentication
- ** stdin_open** is the same as passing the **-i** to **docker run**. It will keep STDIN open even if we are not attached to the container

To use the file, we need to move to the folder inside the VM and start the containers. Let's ask Docker-Compose to bring the stack up:

```bash
> cd /vagrant/exercises/exercise3
> docker-compose up -d
```

If you check your Docker process list, you'll see two new containers, **influx** and **grafana**. We can now access both from our host machine. Influx is available at (http://localhost:8083) and Grafana is located at (http://localhost:3000).

![Starting up Influx and Grafana](/exercises/exercise3/demoA.gif)