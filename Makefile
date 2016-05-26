## First, extract parameters from the text-based makefile into an R
## list saved into an RDS object file. This just makes it easier to access
## parameters by name during model execution and post-processing
output/parameters.Rds : munge/extract_parameters.R  data/parameters.csv
	@echo --- Extracting parameters from CSV ---
	@mkdir -p $(@D)
	./$< -o $@ -p $(word 2, $^)


## Using the parameter values from the input data, simulate a data file
output/samples.csv : src/simdata.R output/parameters.Rds
	@echo --- Simulating data ---
	@mkdir -p $(@D)
	./$< -o $@ -p $(word 2, $^)


## Run the stan model, and save the stanmodel object to an RDS file
output/stan_samples.Rds : src/runmodel.R src/model.stan output/samples.csv 
	@echo --- Running Stan mixture model ---
	@mkdir -p $(@D)
	./$< -o $@ -m $(word 2, $^) -d $(word 3, $^)  -c 2 -i 5000

## Generate figures using the posterior distributions of model parameters.
## Note the additional dependency on the input parameters, which we use to
## get a sense of goodness-of-fit in the posterior plots
output/figures/p_*.pdf : src/make_figures.R output/stan_samples.Rds output/parameters.Rds
	@echo --- Generating figures ---
	@mkdir -p $(@D)
	./$< -o output/figures -s $(word 2, $^) -p $(word 3, $^)

output/results.md : presentations/results.Rmd 
	@echo ----Translating results from RMD to Markdown----
	Rscript \
		-e "require(knitr)" \
                -e "knitr::render_markdown()"\
		-e "knitr::knit('$<','$@')"


output/results.pdf : output/results.md output/figures/*.pdf
	@echo ----Generating PDF from Markdown----
	pandoc $< -V geometry:margin=1.0in --from=markdown -t latex -s -o $@  


.PHONY: clean
clean :
	@echo --- Removing generated files ---
	rm -r output
