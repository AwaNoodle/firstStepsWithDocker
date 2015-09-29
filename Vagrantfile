# -*- mode: ruby -*-
# vi: set ft=ruby :

$update = <<END
	sudo apt-get Update	
	sudo apt-get upgrade -y 
END

# Update to the latest Docker
$installLatestDocker = <<END
	 curl -sSL https://get.docker.com/ | sh
	 usermod -aG docker vagrant 
END

$pullDemoContainers = <<END
  docker pull Kitematic/hello-world-nginx
  docker pull tutum/influxdb
  docker pull tutum/grafana
END

# Add Dcoker Compose to the image
# https://docs.docker.com/compose/install/
$installCompose = <<END
	sudo curl -L https://github.com/docker/compose/releases/download/1.4.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
	sudo chmod +x /usr/bin/docker-compose
END

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # nginx
  config.vm.network "forwarded_port", guest: 80, host: 9123

  # Graphana / Influx
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8083, host: 8083
  config.vm.network "forwarded_port", guest: 8086, host: 8086
  
  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
  end

  	config.vm.provision "shell", name: "Update Machine", inline: $update
	  config.vm.provision "shell", name: "Install Docker", inline: $installLatestDocker
    config.vm.provision "shell", name: "Install Docker-Compose", inline: $installCompose
    config.vm.provision "shell", name: "Install Demo Containers", inline: $pullDemoContainers
end