#!/usr/bin/Rscript
suppressMessages(require(docopt))
'Usage:
   make_figures.R [-s <samples> -p <parameters> -o <outdir>]

Options:
   -s RDS file with samples [default: output/stan_samples.Rds]
   -p RDS file with parameters [default: output/parameters.Rds]
   -o Output directory [default: output/figures]
 ]' -> doc

opts <- docopt(doc)

suppressMessages(require(ggplot2))
suppressMessages(require(rstan))
suppressMessages(require(gridExtra))

## Load samples
m <- readRDS(opts$s)

## Extract into list for easy access
z <- extract(m)

## Load input parameters for comparisons
pars <- readRDS(opts$p)

#######################################################
## Plot Means
## First component mu
df <- data.frame(x = z$mu[,1])
mu1_g <- ggplot(df, aes(x)) + geom_density(fill = "gray") +
    geom_vline(xintercept = pars$m1, linetype = "dashed") +
    xlab("mu 1")

mu1_g  <- mu1_g + theme(axis.line = element_line(colour = "black"),
                panel.border = element_blank(),
                panel.background = element_blank())+
    theme(axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
          plot.title = element_text(face = "bold"),
          axis.ticks = element_line(colour="black"))


## Second component mu
df <- data.frame(x = z$mu[,2])
mu2_g <- ggplot(df, aes(x)) + geom_density(fill = "gray") +
    geom_vline(xintercept = pars$m2, linetype = "dashed") +
    xlab("mu 2")


mu2_g  <- mu2_g + theme(axis.line = element_line(colour = "black"),
                panel.border = element_blank(),
                panel.background = element_blank())+
    theme(axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
          plot.title = element_text(face = "bold"),
          axis.ticks = element_line(colour="black"))

pdf(file.path(opts$o, "mu.pdf"), width = 10, height = 5)
grid.arrange(mu1_g, mu2_g, ncol = 2, nrow = 1)
dev.off()

#######################################################
## Plot SDs
## First component mu
df <- data.frame(x = z$sigma[,1])
sd1_g <- ggplot(df, aes(x)) + geom_density(fill = "gray") +
    geom_vline(xintercept = pars$sd1, linetype = "dashed") + xlab("SD 1")

sd1_g  <- sd1_g + theme(axis.line = element_line(colour = "black"),
                panel.border = element_blank(),
                panel.background = element_blank())+
    theme(axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
          plot.title = element_text(face = "bold"),
          axis.ticks = element_line(colour="black"))


## Second component mu
df <- data.frame(x = z$sigma[,2])
sd2_g <- ggplot(df, aes(x)) + geom_density(fill = "gray") +
    geom_vline(xintercept = pars$sd2, linetype = "dashed") + xlab("SD 2")

sd2_g  <- sd2_g + theme(axis.line = element_line(colour = "black"),
                panel.border = element_blank(),
                panel.background = element_blank())+
    theme(axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
          plot.title = element_text(face = "bold"),
          axis.ticks = element_line(colour="black"))


pdf(file.path(opts$o, "sd.pdf"), width = 10, height = 5)
grid.arrange(sd1_g, sd2_g, ncol = 2, nrow = 1)
dev.off()

###########################################
## Mixture probability
df <- data.frame(x = z$p)
p_g <- ggplot(df, aes(x)) + geom_density(fill = "gray") +
    geom_vline(xintercept = pars$p, linetype = "dashed") + xlab("p")

p_g  <- p_g + theme(axis.line = element_line(colour = "black"),
                panel.border = element_blank(),
                panel.background = element_blank())+
    theme(axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
          plot.title = element_text(face = "bold"),
          axis.ticks = element_line(colour="black"))

ggsave(file.path(opts$o, "p.pdf"))
