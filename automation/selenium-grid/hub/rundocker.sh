#!/bin/bash
docker rm selenium-hub
nohup docker run -d -p 4444:4444 --name selenium-hub  selenium-hub &
