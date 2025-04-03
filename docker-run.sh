#!/bin/bash
docker build -t adaptive-fpu .
docker run --rm -it -v $(pwd):/app adaptive-fpu
