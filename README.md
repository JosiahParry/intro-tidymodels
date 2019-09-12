“Applied” Tidy modeling
================
Josiah Parry
updated: 2019-09-12

## Intro to Tidy modeling

  - [Prediction API](https://colorado.rstudio.com/rsc/genre-pred/)
  - [Prediction
    App](https://colorado.rstudio.com/rsc/hiphop-or-country/)

This repository contains the resources used for a brief (~1hr)
introduction to tidymodels.

The slides `xaringan.Rmd` very, very briefly introduce the fundamentals
of the tidymodels (parsnip, recipes, and rsample).

During the slides, I walk through `audio_classifier.R`. This creates a
lyric classifier as outlined in [mirr](https://mirr.netlify.com).

This model is then “productionalized” with plumber (`plumber.R`), and
then wrapped in a small Shiny app (`app.R`).

#### Important notes

In order to run the prediction plumber API and Shiny App, a Spotify API
key will be needed. The training data was collected with the `spotifyr`
package. Refer to the spotifyr
[README](https://github.com/charlie86/spotifyr/) for insstructions. I
stored the credentials in an `.Renviron` file.
