“Applied” Tidy modeling
================
Josiah Parry
updated: 2019-09-12

## Intro to Tidy modeling

This repository contains the resources used for a brief (~1hr)
introduction to tidymodels.

The slides `xaringan.Rmd` very, very briefly introduce the fundamentals
of the tidymodels (parsnip, recipes, and rsample).

During the slides, I walk through `audio_classifier.R`. This creates a
lyric classifier as outlined in [mirr](https://mirr.netlify.com).

This model is then “productionalized” with plumber (`plumber.R`), and
then wrapped in a small Shiny app (`app.R`).
