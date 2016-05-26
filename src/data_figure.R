#!/usr/bin/Rscript
suppressMessages(require(docopt))
'Usage:
   data_figure.R [-d <data> -o <outdir>]

Options:
   -d CSV file with samples [default: output/samples.csv]
   -o Output directory [default: output/figures]
 ]' -> doc

opts <- docopt(doc)

suppressMessages(require(ggplot2))
suppressMessages(require(rstan))
suppressMessages(require(gridExtra))

df <- read_csv(opts$d)

#######################################################
## Plot input data

data_g <- ggplot(df, aes(x)) +
    geom_histogram(aes(y=..density..), binwidth = 0.1, alpha = 0.5) +
    geom_density()

data_g <- data_g + theme(axis.line = element_line(colour = "black"),
                panel.border = element_blank(),
                panel.background = element_blank())+
    theme(axis.text.x = element_text(colour = "black"),
          axis.text.y = element_text(colour = "black"),
          plot.title = element_text(face = "bold"),
          axis.ticks = element_line(colour="black"))

ggsave(file.path(opts$o, "d_density.pdf"), width = 8, height = 4)
