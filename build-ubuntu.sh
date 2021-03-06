#!/bin/bash
# build-ubuntu, version 1

# This script assumes a Vagrantfile in the same working
# directory from which you run it.

move-it-all () {
		vagrant up
    vagrant ssh -c "sudo -u postgres psql -c 'drop database polyvox_beta_prod;'"
		vagrant ssh -c "rm -rf /home/vagrant/polyvox"
		git archive HEAD --format=zip > archive.zip
		zip -u archive.zip ./config/prod.secret.exs
		vagrant ssh -c "mv /vagrant/archive.zip /home/vagrant/"
		vagrant ssh -c "unzip /home/vagrant/archive.zip -d /home/vagrant/polyvox"
		vagrant ssh -c "rm -f /home/vagrant/archive.zip /home/vagrant/polyvox/Vagrantfile /home/vagrant/polyvox/build-ubuntu.sh"
		vagrant ssh -c "pushd ~/polyvox && npm install && mix deps.get && mix compile && gulp build --production"
		vagrant ssh -c "pushd ~/polyvox && mix phoenix.digest"
		vagrant ssh -c "pushd ~/polyvox && mix release"
		VERSION=$(vagrant ssh -c "ls ~/polyvox/rel/polyvox_marketing/releases | head -1" | tr -d '\n\r')
		WORKDIR=./rel/tmp
		mkdir -p rel/ubuntu/trusty64
		mkdir -p ${WORKDIR}
		vagrant ssh -c "mv ~/polyvox/rel/polyvox_marketing/releases/${VERSION}/polyvox_marketing.tar.gz /vagrant/rel/tmp/polyvox-marketing-${VERSION}.tar.gz"
		mkdir -p ${WORKDIR}/polyvox_marketing
		tar -x -v -z -C ${WORKDIR}/polyvox_marketing -f ${WORKDIR}/polyvox-marketing-${VERSION}.tar.gz
		rm ${WORKDIR}/polyvox_marketing/releases/${VERSION}/polyvox_marketing.tar.gz
		tar -c -v -z -f rel/ubuntu/trusty64/polyvox-marketing-${VERSION}.tar.gz -C ${WORKDIR}/polyvox_marketing .
		rm -rf ${WORKDIR}
}

move-it-all

exit
