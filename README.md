
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
library("dplyr")
library("ggplot2")
library("ggerrorbard")

# rm(list = ls())
set.seed(12)

# dummy data
n <- 50
alpha.error <- 0.05

dat <- data.frame(
  x = c(
    rnorm(n, m = 8, sd = 1),
    rnorm(n, m = 8, sd = 1.75)
  ),
  y = c(
    rnorm(n, m = 4, sd = 1.5),
    rnorm(n, m = 7, sd = 1.75)
  ),
  cond = rep(c('A', 'B'), each = n)
)


# summary of data
dat$d <- with(dat, y - x) # pairwise difference of x and y
agg <- dat %>%
  group_by(cond) %>%
  summarise(x_M = mean(x),
            x_SD = sd(x),
            x_SE = sd(x) / sqrt(n()),
            y_M = mean(y),
            y_SD = sd(y),
            y_SE = sd(y) / sqrt(n()),
            d_M = mean(d),
            d_SD = sd(d),
            d_SE = sd(d) / sqrt(n()),
            n = n())

# plot
plt <- ggplot(
  data = dat,
  mapping = aes(
    x = x, y = y,
    group = cond,
    color = cond
  )
) +
  geom_abline(intercept = 0, slope = 1) +
  # observations
  geom_point(alpha = 0.3, shape = 20, size = 3) +
  # means
  geom_point(
    data = agg,
    mapping = aes(
      x = x_M, y = y_M,
      group = cond,
      color = cond
    ),
    shape = 19, size = 3
  ) +
  # errors of means
  ggerrorbard::geom_errorbard(
    data = agg,
    mapping = aes(
      x = x_M, y = y_M, # center points of error bars
      group = cond,
      color = cond,
      radius = y_SD, # radius of y error bars
      angle_deg = 0
    ),
    arrow = arrow(
      angle = 90,
      ends = "both",
      length = unit(0.025, "npc")
    ),
    linewidth = 1
  ) +
    ggerrorbard::geom_errorbard(
    data = agg,
    mapping = aes(
      x = x_M, y = y_M, # center points of error bars
      group = cond,
      color = cond,
      radius = x_SD, # radius of x error bars
      angle_deg = 90
    ),
    arrow = arrow(
      angle = 90,
      ends = "both",
      length = unit(0.025, "npc")
    ),
    linewidth = 1
  ) +
  # error of differences of means
  ggerrorbard::geom_errorbard(
    data = agg,
    mapping = aes(
      x = x_M, y = y_M, # center points of error bars
      group = cond,
      color = cond,
      radius = d_SD / 2 * sqrt(2), # radius of error bars, adjusted of 45° rotation (?)
      angle_deg = 45
    ),
    # arrows on ends of error bars
    arrow = arrow(
      angle = 90,
      ends = "both",
      length = unit(0.025, "npc")
    ),
    linewidth = 1
  ) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 12)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 12)) +
  guides(color = guide_legend(override.aes = list(linetype = 0))) +
  coord_equal() +
  theme_minimal() +
  theme(legend.position = "top")

print(plt)
```

<div class="figure">

<img src="man/figures/README-example-1.png" alt="Pairwise differences. Error bars represent the standard deviations." width="100%" />
<p class="caption">
Pairwise differences. Error bars represent the standard deviations.
</p>

</div>

Use `angle_deg = 0` for standard vertical error bars and
`angle_deg = 90` for horizontal error bars. For diagonal error bars,
specify `angle_deg = 45`.

## Limitations

- The error bars get distorted by transformations of the plotting
  coordinate system, e.g. `coord(x = "log10", y = "log10")`

<!--
You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this.
-->
