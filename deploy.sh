#!/bin/bash
# deploy, version 1

# This script assumes a command-line parameter
# specifying the version to deploy.

if [ "$1" == "" ]; then
		echo "Usage: ./deploy.sh version"
		echo "Deploys the specified version to the polyvox server."
		echo "  version: version to deploy, e.g. 0.0.1"
		exit 1
fi

if [ ! -f ./rel/ubuntu/polyvox-$1.tar.gz ]; then
		echo "Could not find version $1"
		echo "  Searched ./rel/ubuntu/polyvox-$1.tar.gz"
		exit 1
fi

DEST_DIR="/var/www/polyvox.fm/polyvox-$1"
CLEAN_COMMAND="rm -rf ${DEST_DIR}"
STAGE_COMMAND="mkdir -p ${DEST_DIR}"
UNTAR_COMMAND="pushd ${DEST_DIR} && tar xvzf polyvox-$1.tar.gz"

ssh curweb1.curtissimo.com "sudo /var/www/polyvox.fm/stop-site.sh"
ssh curweb1.curtissimo.com "${CLEAN_COMMAND}"
ssh curweb1.curtissimo.com "${STAGE_COMMAND}"
scp ./rel/ubuntu/polyvox-$1.tar.gz curweb1.curtissimo.com:${DEST_DIR}
ssh curweb1.curtissimo.com "${UNTAR_COMMAND}"
ssh curweb1.curtissimo.com "sudo /var/www/polyvox.fm/start-site.sh"
