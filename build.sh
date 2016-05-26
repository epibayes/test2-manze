#!/usr/bin/env bash

## This just makes sure everything is re-run even if parameters file
## hasn't been updated
touch data/parameters.csv

make pdf
