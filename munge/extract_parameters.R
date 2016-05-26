#! /usr/bin/Rscript
suppressMessages(require(docopt))

'Usage:
   extract_parameters.R [-p <data> -o <output> ]

Options:
   -p CSV file with parameters [default: data/parameters.csv]
   -o RDS file for parameter list [default: output/parameters.Rds]
 ]' -> doc

opts <- docopt(doc)

suppressMessages(require(readr))


## Load model parameters
pd <- read_csv(opts$p)

## Convert parameter data frame to list for easy access
pars <- list()
for (i in 1:nrow(pd)) {
    pars[pd$parameter[i]] <- pd$value[i]
}

saveRDS(pars, opts$o)
