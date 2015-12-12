#!/bin/bash
# Deploy-to-vagrant, version 1

# This script assumes a Vagrantfile in the same working
# directory from which you run it.

move-it-all () {
		vagrant ssh -c "rm -rf /home/vagrant/polyvox"
		git archive HEAD --format=zip > archive.zip
		zip -u archive.zip ./config/prod.secret.exs
		vagrant up
		vagrant scp ./archive.zip /home/vagrant/archive.zip
		rm ./archive.zip
		vagrant ssh -c "unzip /home/vagrant/archive.zip -d /home/vagrant/polyvox"
		vagrant ssh -c "rm -f /home/vagrant/archive.zip /home/vagrant/polyvox/Vagrantfile /home/vagrant/polyvox/deploy-to-vagrant.sh"
		vagrant ssh -c "pushd ~/polyvox && npm install && mix deps.get && mix deps.compile && mix ecto.reset && brunch build --production && mix phoenix.digest && mix phoenix.server"
}

move-it-all

exit
