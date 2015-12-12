#!/bin/bash
# Deploy-to-vagrant, version 1

# This script assumes a Vagrantfile in the same working
# directory from which you run it.

VERSION=0.0.1
STOP_CMD="if [ -f ~/polyvox/rel/polyvox/releases/${VERSION}/polyvox.sh ]; then ~/polyvox/rel/polyvox/releases/${VERSION}/polyvox.sh stop; fi"
START_CMD="~/polyvox/rel/polyvox/releases/${VERSION}/polyvox.sh start && ~/polyvox/rel/polyvox/releases/${VERSION}/polyvox.sh ping"

move-it-all () {
		vagrant up
		vagrant ssh -c "${STOP_CMD}"
		vagrant ssh -c "rm -rf /home/vagrant/polyvox"
		git archive HEAD --format=zip > archive.zip
		zip -u archive.zip ./config/prod.secret.exs
		vagrant scp ./archive.zip /home/vagrant/archive.zip
		rm ./archive.zip
		vagrant ssh -c "unzip /home/vagrant/archive.zip -d /home/vagrant/polyvox"
		vagrant ssh -c "rm -f /home/vagrant/archive.zip /home/vagrant/polyvox/Vagrantfile /home/vagrant/polyvox/build-ubuntu.sh"
		vagrant ssh -c "pushd ~/polyvox && npm install && mix deps.get && mix compile && mix ecto.reset && brunch build --production"
		vagrant ssh -c "pushd ~/polyvox && mix phoenix.digest"
		vagrant ssh -c "pushd ~/polyvox && mix release"
		vagrant ssh -c "${START_CMD}"
		mkdir -p rel/ubuntu
		vagrant scp default:~/polyvox/rel/polyvox/releases/${VERSION}/polyvox.tar.gz rel/ubuntu/polyvox-${VERSION}.tar.gz
		open http://localhost:8080
}

move-it-all

exit
