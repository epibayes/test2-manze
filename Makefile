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
	./$< -o $@ -m $(word 2, $^) -d $(word 3, $^)  -c 2 -i 2000

## Generate figures using the posterior distributions of model parameters.
## Note the additional dependency on the input parameters, which we use to
## get a sense of goodness-of-fit in the posterior plots
output/figures/p_*.pdf : src/make_figures.R output/stan_samples.Rds output/parameters.Rds
	@echo --- Generating figures ---
	@mkdir -p $(@D)
	./$< -o output/figures -s $(word 2, $^) -p $(word 3, $^)

output/figures/d_density.pdf : src/data_figure.R output/samples.csv
	@echo --- Generating data figure ---
	@mkdir -p $(@D)
	./$< -o output/figures -d $(word 2, $^)

## Translate from Rmarkdown to markdown using knitr
output/results.md : presentations/results.Rmd output/figures/p_*.pdf output/parameters.csv
	@echo ----Translating results from RMD to Markdown----
	@mkdir -p $(@D)
	Rscript \
		-e "require(knitr)" \
                -e "knitr::render_markdown()"\
		-e "knitr::knit('$<','$@')"

## Generate PDF from resulting markdown
output/results.pdf : output/results.md 
	@echo ----Generating PDF from Markdown----
	@mkdir -p $(@D)
	pandoc $< -V geometry:margin=1.0in --from=markdown -t latex -s -o $@  -V fontsize=12pt

.PHONY: pdf
pdf : output/results.pdf

.PHONY: clean
clean :
	@echo --- Removing generated files ---
	rm -r output
