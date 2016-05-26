# Reproducible research with Stan

This is a simple example of how a fully reproducible analysis looks using Stan and Docker. All it does is simulate from a 2-component Gaussian finite mixture model, fit a Stan model to the results, and generate a PDF with a summary of inputs and results.

An example of what the output should look like is available [here](https://dl.dropboxusercontent.com/s/e99l7q4c3toderd/mixture_model_output.pdf).

If you want to run locally and have `ggplot2, rstan, dplyr` and `readr` installed in R, as well as a working Pandoc and LaTeX installation, just type `make pdf` at the *nix/Mac command line.

Otherwise, running everything in here without doing any local config relies on the docker image [jonzelner/rstan](https://hub.docker.com/r/jonzelner/rstan/) on Docker Hub.

Provided that you have Docker installed and up and running, all you need to do it to `docker pull jonzelner/rstan`, and then run everything from within the `reproducible-stan` directory using `./dockerbuild.sh`.

Note that `dockerbuild.sh` assumes that you are running in an environment where it is straightforward to attach a volume from the working directory using the `-v` option in `docker run`. For example, in Docker for Linux or the Docker for Mac/Windows beta this will work seamlessly. On the older VirtualBox based version of Docker for Mac/Windows, this may be a bit trickier.

Stay tuned for updates that package everything including source in a single image using the Gitlab [container registry](https://about.gitlab.com/2016/05/23/gitlab-container-registry/) to make this process just a bit more seamless.


