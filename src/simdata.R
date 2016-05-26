#!/usr/bin/Rscript
suppressMessages(require(docopt))

'Usage:
   simdata.R [-p <pars> -o <output>]

Options:
   -p Parameters file [default: output/parameters.Rds]
   -o Output file [default: output/samples.csv]
 ]' -> doc

opts <- docopt(doc)

suppressMessages(require(readr))
suppressMessages(require(dplyr))

## Load parameters
pars <- readRDS(opts$p)

## Draw component for each sample
component <- rbinom(pars$n,1,pars$p)

## Sample values for each component
c1_vals <- rnorm(pars$n, mean = pars$m1, sd = pars$sd1)
c2_vals <- rnorm(pars$n, mean = pars$m2, sd = pars$sd2)

## Create mixture output using component indicator variables
## in component
sample_vals <- component*c1_vals + (1-component)*c2_vals

## Put into a data frame for easy saving
out_df <- data.frame(x = sample_vals)

## Write to file
write_csv(out_df, opts$o)
