#!/bin/bash

which podman &> /dev/null && BUILD=podman || BUILD=docker

$BUILD build --pull . -t ghcr.io/andreas-hofmann/dadamail $*
