library(plumber)
library(dplyr)
library(parsnip)
library(ranger)

#------------------------------------------------------------------------------#
#                                    Global                                    #
#------------------------------------------------------------------------------#
#--------------- This code is sourced and available to the API ----------------#
#------------------------------------------------------------------------------#

audio_classifier <- readr::read_rds("models/audio_classifier.rds")
audio_rec <- readr::read_rds("models/audio_rec.rds")

# create function for getting song features
track_audio_features <- function(artist, title, type = "track") {
  
  search_results <- spotifyr::search_spotify(paste(artist, title), 
                                             type = type, 
                                             authorization =  spotifyr::get_spotify_access_token(
                                               client_id = Sys.getenv("SPOTIFY_CLIENT_ID"),
                                               client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET")
                                             )
  )
  
  track_audio_feats <- spotifyr::get_track_audio_features(search_results$id[[1]]) %>%
    dplyr::select(-id, -uri, -track_href, -analysis_url)
  
  return(track_audio_feats)
}


#------------------------------------------------------------------------------#
#                                API definition                                #
#------------------------------------------------------------------------------#


# plumber.R

#* @apiTitle Country or Rap predictor


#* Predict if a song is country or rap based on its audio features
#* @param artist name of the artist
#* @param title the name of the song / track
#* @get /track
function(artist, title) {
  
  dat <- track_audio_features(artist, title)
  baked <- recipes::bake(audio_rec, dat)
  
  parsnip::predict.model_fit(audio_classifier, baked, type = "prob") 
  
}
