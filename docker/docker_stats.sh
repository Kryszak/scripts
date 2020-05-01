#!/bin/bash

# This scripts runs live docker containers statistics

docker stats $(docker ps --format={{.Names}})
