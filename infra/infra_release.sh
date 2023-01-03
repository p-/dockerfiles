#!/bin/bash 
echo "Building a Release Docker image"

# Make it executable 
set -ex 

# Pull the latest 
git pull 

# Bump Version 
docker run --rm -v "$PWD":/release ghrc.io/infra/bump patch
version=`cat VERSION`
echo "version: $version"

# Actual building of the image 
./infra_build.sh 

# Tag the build 
git add -A 
git commit -m "version $version"
git tag -A "$version" -m "version $version"
git push 
git push --tags 

# Tag the image 
docker tag ghrc.io/infra:latest ghrc.io/infra:$version 

# Push it to github 
docker push ghrc.io/infra:$version 