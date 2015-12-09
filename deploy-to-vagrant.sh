#!/bin/bash

git archive HEAD --format=zip > archive.zip
vagrant up
vagrant scp ./archive.zip /home/vagrant/archive.zip
vagrant ssh -c "unzip /home/vagrant/archive.zip -d /home/vagrant/polyvox"
vagrant ssh -c "rm /home/vagrant/archive.zip"
