#!/usr/bin/Rscript
suppressMessages(require(docopt))

'Usage:
   runmodel.R [-d <data> -m <model> -o <output> -c <chains> -i <iterations>]

Options:
   -d CSV file with samples [default: output/samples.csv]
   -m Stan model file [default: src/model.stan]
   -o Output file [output/stan_samples.Rds]
   -c Number of chains [default: 4]
   -i Number of MCMC iterations [default: 2000]
 ]' -> doc

opts <- docopt(doc)

suppressMessages(require(rstan))
suppressMessages(require(readr))

## Set stan options
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


## Load the samples
d <- read_csv(opts$d)

## Make an R list for stan input
data_in <- list(N = nrow(d),
                X = d$x)

m <- stan(opts$m,
          iter = as.numeric(opts$i),
          chains = as.numeric(opts$c),
          data = data_in)

saveRDS(m, opts$o)
