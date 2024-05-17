
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggerrorbard

<!-- badges: start -->
<!-- badges: end -->

<img src="man/figures/logo.svg" align="right" height="139" />

Building on `ggplot2`, the goal of `ggerrorbard` is to draw diagonal
errorbars (instead of standard vertical or horizontal errorbars).

## Installation

You can install the development version of `ggerrorbard` from GitHub
like this:

``` r
# install.packages("devtools")
devtools::install_github("lmwidmayer/errorbard")
```

## Example

This is a basic example how to plot the errorbars:

``` r
library(ggplot2)
library(ggerrorbard)

set.seed(12)

# dummy data
dat <- data.frame(x = c(rnorm(10, m = 1, sd = 1), 
                        rnorm(10, m = 4, sd = 2)), 
                  y = c(rnorm(10, m = 1, sd = 1.5),
                        rnorm(10, m = 3, sd = 1.8)),
                  group = c(rep(letters[1:2], each = 10)))
dat$d <- with(dat, y - x)

# summary of data
m <- aggregate(cbind(x, y) ~ group, 
               data = dat, 
               mean)
m$sd <- aggregate(d ~ group, 
                  data = dat, 
                  sd)[, 2] / sqrt(aggregate(d ~ group, 
                                            data = dat, 
                                            length)[, 2])
m$n <- aggregate(d ~ group, 
                                            data = dat, 
                                            length)[, 2]
m$se <- m$sd / sqrt(m$n)

# plot
ggplot(data = dat,
       mapping = aes(x = x, y = y,
                     group = group,
                     color = group)) +
  geom_abline(intercept = 0, slope = 1) +
  geom_point(alpha = 0.4, size = 2) +
  geom_point(data = m,
             mapping = aes(x = x, y = y,
                           group = group,
                           color = group),
             size = 4) +
  ggerrorbard::geom_errorbard(data = m,
                 mapping = aes(xcenter = x, ycenter = y, # center points of errorbars
                               group = group,
                               color = group,
                               latitude = 2*se, # width of errorbars
                               angle = -45), # angle of errorbars
                 # arrows on ends of errorbars
                 arrow = arrow(angle = 90, 
                               ends = "both", 
                               length = unit(0.05, "npc")),
                 linewidth = 1.1) +
  coord_equal() +
  theme_minimal()
```

<img src="man/figures/README-example-1.png" width="100%" />

<!--
You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this.
-->
