#!/bin/bash

# Get location of current machine

curl "https://ipvigilante.com/$(curl https://ipinfo.io/ip)" | python -m json.tool
