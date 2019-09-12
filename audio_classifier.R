library(tidyverse)
library(tidymodels)


#------------------------------------------------------------------------------#
#                           tidyverse data cleaning                            #
#------------------------------------------------------------------------------#
chart_analysis <- read_csv("data/chart_analysis.csv")

# audio features -----------
# remove unwanted vars
clean_chart <- select(chart_analysis, 
                      -c("duration_ms", "time_signature", "type", "mode",
                         "rank", "year", "artist", "featured_artist", "title")) %>%
  mutate(chart = as.factor(chart),
         key = as.factor(key))


#------------------------------------------------------------------------------#
#                                   rsample                                    #
#------------------------------------------------------------------------------#

# set seed
set.seed(0)

# partition data
init_split <- initial_split(clean_chart, strata = "chart")

# extract training set
train_df <- training(init_split)

# extract testing set
test_df <- testing(init_split)

#------------------------------------------------------------------------------#
#                                   Recipes                                    #
#------------------------------------------------------------------------------#

# define recipe: center and scale 
# keep it simple for example purposes
audio_rec <- recipe(chart ~ ., data = train_df)  %>%
  step_center(all_numeric()) %>%
  step_scale(all_numeric()) %>%
  prep()

# apply pre-processing to create tibbles ready for modeling
audio_train <- bake(audio_rec, train_df)
audio_test <- bake(audio_rec, test_df)

#------------------------------------------------------------------------------#
#                                   parsnip                                    #
#------------------------------------------------------------------------------#

audio_classifier <- rand_forest(mode = "classification") %>%
  set_engine("ranger") %>%
  fit(chart ~ ., data = audio_train)

#------------------------------------------------------------------------------#
#                                  yardstick                                   #
#------------------------------------------------------------------------------#

audio_estimates <- predict(audio_classifier, audio_test) %>%
  bind_cols(audio_test) %>%
  metrics(truth = chart, estimate = .pred_class)

audio_estimates
