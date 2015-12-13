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

SRC_PATH=./rel/ubuntu/trusty64/polyvox-$1.tar.gz

if [ ! -f $SRC_PATH ]; then
		echo "Could not find version $1"
		echo "  Searched ${SRC_PATH}"
		exit 1
fi

DEST_DIR="/var/www/polyvox.fm/polyvox-$1"
PRIV_DIR="${DEST_DIR}/lib/polvyox-$1/priv/static"
DEST_PATH="${DEST_DIR}/polyvox-$1.tar.gz"

CLEAN_COMMAND="rm -rf ${DEST_DIR} /var/www/polyvox.fm/latest"
STAGE_COMMAND="mkdir -p ${DEST_DIR}"
UNTAR_COMMAND="pushd ${DEST_DIR} && tar xvzf polyvox-$1.tar.gz"
CLEANUP_COMMAND="rm -f ${DEST_PATH}"
LINK_COMMAND="ln -s ${DEST_DIR} /var/www/polyvox.fm/latest-rel"
LINKWWW_COMMAND="ln -s ${PRIV_DIR} /var/www/polyvox.fm/latest"

ssh curweb1.curtissimo.com "sudo /var/www/polyvox.fm/stop-site.sh"
ssh curweb1.curtissimo.com "${CLEAN_COMMAND}"
ssh curweb1.curtissimo.com "${STAGE_COMMAND}"
scp ${SRC_PATH} curweb1.curtissimo.com:${DEST_DIR}
ssh curweb1.curtissimo.com "${UNTAR_COMMAND}"
ssh curweb1.curtissimo.com "${CLEANUP_COMMAND}"
ssh curweb1.curtissimo.com "${LINK_COMMAND}"
ssh curweb1.curtissimo.com "${LINKWWW_COMMAND}"
ssh curweb1.curtissimo.com "sudo /var/www/polyvox.fm/start-site.sh"
