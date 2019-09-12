# lyrics features -------
library(tidymodels)
chart_topics <- read_csv("data/chart_topics.csv")

set.seed(0)
init_split <- initial_split(chart_topics, strata = "chart")
train_df <- training(init_split)
test_df <- testing(init_split)

# create recipe
chart_rec <- recipe(chart ~ x1 + x2 + x3 + x4 + x5, data = train_df) %>% 
  prep()

# bake the training and testing to have clean dfs
lyric_train <- bake(chart_rec, train_df)
lyric_test <- bake(chart_rec, test_df)


#--------------------------------- model fit ----------------------------------#

lyric_classifier <- rand_forest(mode = "classification") %>%
  set_engine("randomForest") %>%
  fit(chart ~ ., data = lyric_train)



#------------------------------ model evaluation ------------------------------#
lyric_estimates <- predict(lyric_classifier, lyric_test) %>%
  bind_cols(lyric_test) %>%
  yardstick::metrics(truth = chart, estimate = .pred_class)

lyric_estimates
