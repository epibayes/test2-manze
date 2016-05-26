#!/usr/bin/env bash

## This just makes sure everything is re-run even if parameters file
## hasn't been updated
touch data/parameters.csv

## Run in a detached Docker instance
JOB=$(docker run -v `pwd`:/example -u rstudio -d jonzelner/rstan-geo /bin/bash -c "cd example && make pdf")

## Write job ID out to a file in case we want to keep track of a long-running job
echo $JOB > dockerjob

## Follow the logged output from the Docker instance
docker logs -f $JOB
