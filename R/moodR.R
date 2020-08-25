

# set working directory
setwd('C:/Users/klotz/Desktop/code/lyrics NLP')


# import list of listened tracks from "https://benjaminbenben.com/lastfm-to-csv/"
# after tracking my spotify usage for ~ 1 year using LastFM
 
tracklist <- read.csv( 'kinimod21.csv', header = FALSE )
names(tracklist) <- c( 'artist', 'album', 'title','date' )   # given headers

tracklist$artist <-  as.character(tracklist$artist)          # declare appropriate the headers
tracklist$album  <-  as.character(tracklist$album)
tracklist$title  <-  as.character(tracklist$title)

library(lubridate)

tracklist$date    <- dmy_hm(as.character(tracklist$date))    # convert the datetime into various date information formats
tracklist$month   <- month(tracklist$date)
tracklist$weekday <- wday(tracklist$date)
tracklist$time    <- hour(tracklist$date)

attach(tracklist)                                            # attach headers for easier referencing

# first look at some basic data exploration of the tracklist

 
print('first entry:')
  min(date)
print('last entry:')
  max(date)
print('approximate sample period hence')
  (max(date)-min(date))

library(ggplot2) 
library(ggthemes)
library(gridExtra)

ggplot(data = tracklist) +
  geom_bar( aes ( factor ( month ) ) ) +
  theme_economist(base_size = 10, base_family = "verdana",
                  horizontal = TRUE, dkpanel = FALSE) +
  xlab('month') +
  ylab('total count of songs listened') +
  theme(axis.title.x = element_text(face="bold"), axis.title.y = element_text(face="bold") )

print('total no of entries:')
 length(title)


# and illustrate the hourly, weekly and monthly density of the data

 
  
hourly <- ggplot(data = tracklist) +
          geom_bar( aes ( factor ( time ) ), fill = c ('#014d64','#014d64','#014d64','#014d64','#014d64','#014d64','#014d64',
                                                       '#6794a7','#6794a7','#6794a7','#6794a7','#6794a7','#6794a7','#6794a7',
                                                       '#6794a7','#6794a7','#6794a7','#6794a7','#6794a7','#6794a7','#6794a7',
                                                       '#014d64','#014d64','#014d64') ) +
          coord_polar(start = -0.13, direction = 1) +
          theme_economist(base_size = 10, base_family = "verdana",
                  horizontal = TRUE, dkpanel = FALSE) + 
          theme(axis.title.y = element_blank(), axis.title.x = element_blank(), axis.ticks.x = element_blank(), axis.text.x = element_text(face="bold"), axis.text.y = element_blank())

weekly <- ggplot(data = tracklist) +
            geom_bar( aes ( factor ( weekday ) ), fill = c('#6794a7','#6794a7','#6794a7','#6794a7','#6794a7','#014d64','#014d64' )) +
            scale_x_discrete( breaks= c (1,2,3,4,5,6,7) ,
                              labels= c ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday','Saturday', 'Sunday' ) ) +  
            xlab('Total count of songs listened') +
            theme_economist(base_size = 10, base_family = "verdana",
                              horizontal = TRUE, dkpanel = FALSE) +
            theme(axis.title.x = element_blank(), axis.title.y = element_blank(), axis.text.x = element_text(face="bold"), axis.text.y = element_text(face="bold") ) 


monthly <- ggplot(data = tracklist) +
           scale_x_discrete( limits = c(12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1) ,
                             labels= c ('January', 'February', 'March','April','May', 'June','July','August', 'September', 'October', 'November', 'December')) +         
           geom_bar( aes ( factor ( month) ), fill = c('#6794a7','#6794a7','#6794a7', '#014d64', '#6794a7', '#6794a7', '#014d64','#014d64','#014d64','#6794a7','#6794a7','#6794a7')  ) + 
           theme_economist(base_size = 10, base_family = "verdana",
                  horizontal = TRUE, dkpanel = FALSE) + 
           coord_flip() +
           theme(axis.title.y = element_blank(), axis.title.x = element_blank(), axis.text.x = element_text(face="bold"), axis.text.y = element_text(face="bold") ) 

 
 
# using the spotifyR wrapper for the spotify API we can query spotify for their 'audio feature' of the tracks in my tracklist.
# Only spotify knows exactly how these metrics are calculated, but given their huge success at modelling music taste, it is more 
# than fair to assume that they know what they're doing - and has there ever been a cooler metric to work with than 'danceability'
# their definitions: https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-features/
library(spotifyr)

Sys.setenv(SPOTIFY_CLIENT_ID = '6a390e38490049879fc06a268024f91e')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '4c7e77c64455484496af46093683a176')
access_token <- get_spotify_access_token()

library(purrr)
library(dplyr)

number_unique    <- dim(distinct(tracklist, title, .keep_all = TRUE))[1]

# creds to https://mirr.netlify.app/audio-features-spotify.html

track_audio_features <- function(artist, title, type = "track") {
  search_results <- search_spotify(paste(artist, title), type = type)
  
  track_audio_feats <- get_track_audio_features(search_results$id[[1]]) %>%
    dplyr::select(-id, -uri, -track_href, -analysis_url)
  
  return(track_audio_feats)
}

possible_feats <- possibly(track_audio_features, otherwise = tibble())

feature_data <- possible_feats("Bob Marley", "Is this Love")
empty <- feature_data
empty$type <- 0

for (i in 1:dim(tracklist)[1])
{
  artist <- tracklist$artist[i]
  title  <- tracklist$title[i]
  track_audio_feats <- possible_feats(artist, title, type = "track")
  
  if (nrow(track_audio_feats) == 0)
    {
      feature_data <- rbind(feature_data, empty)
    }
    else
    {
      feature_data <- rbind(feature_data, track_audio_feats)
    }
}

# delete bob marley and bind audio data to track data
feature_data <- feature_data[-1, ]
tracklist <- cbind(tracklist, feature_data)

# give a result statement
imported <- round((1-sum(tracklist$type == 0)/length(tracklist$type))*100, 3)
print(paste0("successfully imported audio feature data for ", imported, "% of songs in tracklist"))

# now drop all tracks for which no audio info was found
tracklist <- tracklist[tracklist$type != 0,]
feature_data <- feature_data[feature_data$type != 0,]

## KMEANS CLUSTERING


# drop type, duration, time signature, key, mode and create a kmeans data set

drops <- c('type', 'duration_ms', 'time_signature', 'key', 'mode')
kmdata <- feature_data[ , !(names(feature_data) %in% drops)]

# create seperate frame with titles for illustration purposes
kmtitle <- tracklist[tracklist$type != 0,]
kmtitle <- select(kmtitle, title)


# normalise loudness and tempo
kmdata$loudness <- -kmdata$loudness / (max(kmdata$loudness) - min(kmdata$loudness))
kmdata$tempo <- kmdata$tempo / (max(kmdata$tempo) - min(kmdata$tempo))

# set seed and get TSQE within clusters for n clusters
kmeansresult <- data.frame(TSQEwithin=double(11))
set.seed(404)

for (i in 1:11)
{
  km.res <- kmeans(kmdata, i, iter.max = 50, nstart = 25)
  kmeansresult$TSQEwithin[i] <- sum(km.res$withins)
}

# plot TSQE to find the elbow point
ggplot(data = kmeansresult, mapping = aes(x = 1:11, y = TSQEwithin) ) +
  geom_line(size = 1) +
  geom_point( size = 4, shape = 18) +
  labs(x = 'k-means clusters', y = 'total square error within clusters' ) +
  ylab('total square error within clusters') +
  theme_economist(base_size = 10, base_family = "verdana",
                  horizontal = TRUE, dkpanel = FALSE) +
  theme(axis.title.x = element_text(face="bold"), axis.title.y = element_text(face="bold", vjust = +3), axis.text.x = element_text(face="bold"), axis.text.y = element_text(face="bold")) +
  geom_vline(xintercept = 4, linetype = 'dashed')

library(factoextra)

km.res <- kmeans(kmdata, 3, iter.max = 50, nstart = 25)
three <- fviz_cluster(km.res, kmdata, ellipse.type = "norm", geom = "point", xlab = "PC1 (30.1%)", ylab ="PC2 (15.7%)", main ="3-means PC-Plot") + theme(legend.position = "none") 

km.res <- kmeans(kmdata, 4, iter.max = 50, nstart = 25)
four <- fviz_cluster(km.res, kmdata, ellipse.type = "norm", geom = "point", xlab = "PC1 (30.1%)", ylab ="PC2 (15.7%)", main ="4-means PC-Plot") + theme(legend.position = "none") 

km.res <- kmeans(kmdata, 5, iter.max = 50, nstart = 25)
five <- fviz_cluster(km.res, kmdata, ellipse.type = "norm", geom = "point", xlab = "PC1 (30.1%)", ylab ="PC2 (15.7%)", main ="5-means PC-Plot") + theme(legend.position = "none") 

library(gridExtra)

PCAnmeans <- grid.arrange(three, four, five, ncol=3)

# 3D












  