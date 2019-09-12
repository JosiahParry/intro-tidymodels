source("audio_classifier.R")
source("lyric_classifier.R")

# Ensemble model 
chart_df <- chart_analysis %>% 
  mutate(id = glue::glue("{artist}....{title}")) %>% 
  inner_join(chart_topics) %>% 
  distinct(chart, id, .keep_all = TRUE) %>% 
  select(-c("duration_ms", "time_signature", "type", "mode",
            "rank", "year", "artist", "featured_artist", "title")) %>%
  mutate(chart = as.factor(chart),
         key = as.factor(key))


# partition
# create training set 
# the predictions of these will be the training data

set.seed(1)
init_split <- initial_split(chart_df, strata = "chart")
train_df <- training(init_split)
test_df <- testing(init_split)

# these data need to be predicted on 
train_preds <- bind_cols(predict(audio_classifier, train_df, type = "prob"),
                         predict(lyric_classifier, train_df, type = "prob")) %>% 
  select(contains("country")) %>% 
  bind_cols(select(train_df, chart)) %>% 
  janitor::clean_names()

test_preds <- bind_cols(predict(audio_classifier, test_df, type = "prob"),
                        predict(lyric_classifier, test_df, type = "prob")) %>% 
  select(contains("country")) %>% 
  bind_cols(select(test_df, chart)) %>% 
  janitor::clean_names()


chart_rec <- recipe(chart ~ ., data = train_preds)  %>%
  step_center(all_numeric()) %>%
  step_scale(all_numeric()) %>%
  prep()


baked_train <- bake(chart_rec, train_preds)
baked_test <- bake(chart_rec, test_preds)

stacked_fit <- decision_tree(mode = "classification") %>%
  set_engine("C5.0") %>%
  fit(chart ~ ., data = baked_train)

stacked_estimates <- predict(stacked_fit, baked_test) %>%
  bind_cols(baked_test) %>%
  yardstick::metrics(truth = chart, estimate = .pred_class)

stacked_estimates