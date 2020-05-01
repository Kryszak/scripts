#!/bin/bash

# This scripts removes all local git branches other than master

git branch | grep -v '^* master$' | grep -v '^  master$' | xargs -n 1 git branch -d
