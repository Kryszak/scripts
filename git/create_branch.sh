#!/bin/bash

# Creates git branch with given name in format 'prefix/name'

prefix=${2}
prefix=${prefix:=feature}
branchName=${prefix}/$(echo $1 | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
git co -b $branchName
git push --set-upstream origin $branchName
