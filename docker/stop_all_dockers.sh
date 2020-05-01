#!/bin/bash

# This script stops all running docker containers

docker stop $(docker ps -q)
