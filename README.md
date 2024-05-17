
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggerrorbard

<!-- badges: start -->
<!-- badges: end -->

The goal of `ggerrorbard` is to draw errorbars diagonally instead of
vertically or horizontally.

## Installation

You can install the development version of `ggerrorbard` like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Example

This is a basic example which shows you how to solve a common problem:

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
                 mapping = aes(xcenter = x, ycenter = y, # center point of errorbar
                               group = group,
                               color = group,
                               latitude = 2*se, # width of errorbar
                               angle = -45), # angle of errorbar
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
