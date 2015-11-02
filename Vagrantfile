# -*- mode: ruby -*-
# vi: set ft=ruby :

$update = <<END
	sudo apt-get Update	
	sudo apt-get upgrade -y 
END

$addEditors = <<END
  sudo apt-get install vim nano git -y
END

# Update to the latest Docker
$installLatestDocker = <<END
	 if hash docker 2>/dev/null; then
     echo 'Docker already installed'
   else
     apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
     echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
     apt-get update
     apt-get purge lxc-docker*
     sudo apt-get install docker-engine -y
     usermod -aG docker vagrant
   fi 
END

$pullDemoContainers = <<END
  docker pull kitematic/hello-world-nginx
  docker pull tutum/influxdb
  docker pull grafana/grafana
END

# Add Dcoker Compose to the image
# https://docs.docker.com/compose/install/
$installCompose = <<END
	sudo curl -L https://github.com/docker/compose/releases/download/1.4.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
	sudo chmod +x /usr/bin/docker-compose
END

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.post_up_message = "Project files will be available at /vagrant on the VM"

  # nginx
  config.vm.network "forwarded_port", guest: 80, host: 9123

  # Graphana / Influx
  config.vm.network "forwarded_port", guest: 8083, host: 8083
  config.vm.network "forwarded_port", guest: 8086, host: 8086
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  
  config.vm.provider "virtualbox" do |vb|
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
  end

  	config.vm.provision "shell", name: "Update Machine", inline: $update
    config.vm.provision "shell", name: "Install Tools", inline: $addEditors
	  config.vm.provision "shell", name: "Install Docker", inline: $installLatestDocker
    config.vm.provision "shell", name: "Install Docker-Compose", inline: $installCompose
    config.vm.provision "shell", name: "Install Demo Containers", inline: $pullDemoContainers
end
