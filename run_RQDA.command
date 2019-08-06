#!/bin/bash

# Start the Docker container
cd "$( dirname "${BASH_SOURCE[0]}" )"
docker-compose up -d
if [ $? -ne 0 ] ; then
  echo "Failed to start the Docker container"
  exit 1
else
  echo "Successfully started the Docker container"
fi

# SSH with X11 forwarding
login_failed() {
  ssh -X -p 2200 root@localhost LIBGL_ALWAYS_INDIRECT=1 QMLSCENE_DEVICE=softwarecontext rstudio --no-sandbox
  [ "$?" != "0" ]
  return $?
}

while login_failed ; do
  echo "Retrying login in 1 second..."
  sleep 1
done
