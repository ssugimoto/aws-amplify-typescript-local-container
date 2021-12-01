#!/usr/bin/env bash
set -eu

APP_SAMPLE_DIRECTORY=/workspaces/amplify-sample
DATE_TIME=`date +%Y%m%d-%H%M%S`
ARCHIVE_NAME=sample${DATE_TIME}.zip
TARGET=${MOUNTED_HOST_DIR_PATH_IN_CONTAINER}/container-backup-work


if [ -f "${TARGET}/${ARCHIVE_NAME}" ]; then
    echo "We can't override the existing \"${MOUNTED_HOST_DIR}/sample/${ARCHIVE_NAME}\" file on your host machine!" 1>&2
    echo "Remove the file first and re-run again :)" 1>&2
    exit 2
fi

echo "Creating an arhive file from \"${APP_SAMPLE_DIRECTORY}\" inside container..."
cd ${APP_SAMPLE_DIRECTORY}/
ZIP_FILE="/tmp/${ARCHIVE_NAME}"
rm -f ${ZIP_FILE} && zip -qr ${ZIP_FILE} ./

echo "Copying the archive file to \"${MOUNTED_HOST_DIR}/sample/${ARCHIVE_NAME}\"..."
mkdir -p ${TARGET}
cp ${ZIP_FILE} ${TARGET}/${ARCHIVE_NAME}

echo "Done! Yay!"
