#!/usr/bin/env bash

JOB=$(docker run -v `pwd`:/example -u rstudio -d jonzelner/rstan-geo /bin/bash -c "cd example && make pdf")

echo $JOB > dockerjob

docker logs -f $JOB
