data {
  int N; //Number of samples
  vector[N] X; //Data
  
}

parameters {
  ordered[2] mu; //Component means, ordered to avoid label switching, so mu1 < mu2
  real<lower=0> sigma[2]; //Component SDs
  real<lower=0, upper=1> p; //Mixture probability
}

model {
  
  vector[2] component_lp;
  
  sigma ~ cauchy(0,2); // Prior for SDs
  mu ~ normal(0,5); //Prior for means

  for (i in 1:N) {
    component_lp[1] <- log(p) + normal_log(X[i], mu[1], sigma[1]);
    component_lp[2] <- log(1-p) + normal_log(X[i], mu[2], sigma[2]);
    increment_log_prob(log_sum_exp(component_lp));
  }
  
}
