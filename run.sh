#!/bin/sh
docker run \
  -dit \
  -v $PWD:/workspace \
  -p 8888:8888 \
  --name tomoino_ubuntu\
  --rm \
  ubuntu:latest