
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggerrorbard

<!-- badges: start -->
<!-- badges: end -->

<img src="man/figures/logo.svg" align="right" height="139" />

Building on `ggplot2`, the goal of `ggerrorbard` is to draw diagonal
error bars (instead of standard vertical or horizontal error bars).

## Installation

You can install the development version of `ggerrorbard` from GitHub
like this:

``` r
# install.packages("devtools")
devtools::install_github("lmwidmayer/ggerrorbard")
```

## Example

This is a basic example how to plot the error bars:

``` r
library(ggplot2)
library(ggerrorbard)

set.seed(12)

# dummy data
dat <- data.frame(x = c(rnorm(10, m = 1, sd = 1), 
                        rnorm(10, m = 4, sd = 2)), 
                  y = c(rnorm(10, m = 1, sd = 1.5),
                        rnorm(10, m = 3, sd = 1.8)),
                  session = c(rep(letters[1:2], each = 10)))
dat$d <- with(dat, y - x)

# summary of data
m <- aggregate(cbind(x, y) ~ session, 
               data = dat, 
               mean)
m$sd <- aggregate(d ~ session, 
                  data = dat, 
                  sd)[, 2] / sqrt(aggregate(d ~ session, 
                                            data = dat, 
                                            length)[, 2])
m$n <- aggregate(d ~ session, 
                                            data = dat, 
                                            length)[, 2]
m$se <- m$sd / sqrt(m$n)

# plot
ggplot(data = dat,
       mapping = aes(x = x, y = y,
                     group = session,
                     color = session)) +
  geom_abline(intercept = 0, slope = 1) +
  geom_point(alpha = 0.4, size = 2) +
  geom_point(data = m,
             mapping = aes(x = x, y = y,
                           group = session,
                           color = session),
             size = 4) +
  ggerrorbard::geom_errorbard(data = m,
                 mapping = aes(xcenter = x, ycenter = y, # center points of error bars
                               group = session,
                               color = session,
                               latitude = 2*sd / sqrt(2), # width of error bars
                               angle = -45), # angle of error bars
                 # arrows on ends of error bars
                 arrow = arrow(angle = 90, 
                               ends = "both", 
                               length = unit(0.05, "npc")),
                 linewidth = 1.1) +
  ggtitle("Pairwise difference") +
  coord_equal() +
  theme_minimal()
```

<img src="man/figures/README-example-1.png" width="100%" />

## Limitations

- The error bars get distorted by transformations of the plotting
  coordinate system, e.g. `coord(x = "log10", y = "log10")`

<!--
You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this.
-->
