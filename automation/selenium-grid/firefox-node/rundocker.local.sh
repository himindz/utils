#!/bin/bash
docker run -d -P -p $2:$2 -e "NODE_HOST=$1" -e "NODE_PORT=$2" -e "HUB_PORT_4444_TCP_ADDR=$1" -e "HUB_PORT_4444_TCP_PORT=4444" firefox-node

