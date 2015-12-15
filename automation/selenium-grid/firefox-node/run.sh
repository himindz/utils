#!/bin/bash
export GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"

if [ ! -e /opt/selenium/config.json ]; then
  echo No Selenium Node configuration file, the node-base image is not intended to be run directly. 1>&2
  exit 1
fi

if [ -z "$HUB_PORT_4444_TCP_ADDR" ]; then
  echo Not linked with a running Hub container 1>&2
  exit 1
fi

function shutdown {
  kill -s SIGTERM $NODE_PID
  wait $NODE_PID
}

NODE_HOST_PARAM=""
if [ ! -z "$NODE_HOST" ]; then
  echo "NODE_HOST variable is set, appending -host"
  NODE_HOST_PARAM="-host $NODE_HOST"
fi

NODE_PORT_PARAM=""
if [ ! -z "$NODE_PORT" ]; then
  echo "NODE_PORT variable is set, appending -host"
  NODE_PORT_PARAM="-port $NODE_PORT"
fi


REMOTE_HOST_PARAM=""
if [ ! -z "$REMOTE_HOST" ]; then
  echo "REMOTE_HOST variable is set, appending -remoteHost"
  REMOTE_HOST_PARAM="-remoteHost $REMOTE_HOST"
fi


sudo -E -i -u selenium \
  DISPLAY=$DISPLAY \
  xvfb-run --server-args="$DISPLAY -screen 0 $GEOMETRY -ac +extension RANDR" \
  java -jar /opt/selenium/selenium-server-standalone.jar \
    ${JAVA_OPTS} \
    -role node \
    -hub http://$HUB_PORT_4444_TCP_ADDR:$HUB_PORT_4444_TCP_PORT/grid/register \
    ${REMOTE_HOST_PARAM} \
    ${NODE_HOST_PARAM} \
    ${NODE_PORT_PARAM} \
    -browser browserName=firefox,version=34.0,maxInstances=5 \
    -nodeConfig /opt/selenium/config.json &
NODE_PID=$!

trap shutdown SIGTERM SIGINT
for i in $(seq 1 10)
do
  xdpyinfo -display $DISPLAY >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    break
  fi
  echo Waiting xvfb...
  sleep 0.5
done

fluxbox -display $DISPLAY &

x11vnc -forever -usepw -shared -rfbport 5900 -display $DISPLAY &

wait $NODE_PID

