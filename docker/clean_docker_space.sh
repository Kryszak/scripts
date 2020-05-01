#!/bin/bash

# This script cleans disk space by removing docker unused data

docker system prune -af volumes
