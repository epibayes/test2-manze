output/parameters.Rds : munge/extract_parameters.R  data/parameters.csv
	@echo --- Extracting parameters from CSV ---
	@mkdir -p $(@D)
	./$< -o $@ -p $(word 2, $^)

output/samples.csv : src/simdata.R output/parameters.Rds
	@echo --- Simulating data ---
	@mkdir -p $(@D)
	./$< -o $@ -p $(word 2, $^)

output/stan_samples.Rds : src/runmodel.R src/model.stan output/samples.csv 
	@echo --- Running Stan mixture model ---
	@mkdir -p $(@D)
	./$< -o $@ -m $(word 2, $^) -d $(word 3, $^)  -c 2 -i 2000

output/figures/*.pdf : src/make_figures.R output/stan_samples.Rds output/parameters.Rds
	@echo --- Generating figures ---
	@mkdir -p $(@D)
	./$< -o output/figures -s $(word 2, $^) -p $(word 3, $^)


.PHONY: clean
clean :
	rm -r output
