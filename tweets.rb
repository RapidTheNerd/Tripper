class Tweets

  require 'rubygems'
  require 'twitter'
  require 'json'

  USER = "enterUsername"
  TWEET_AGE = 1 #enter the age of tweets to kill

  CONSUMER_KEY = "key"
  CONSUMER_SECRET = "secret"
  QAUTH_TOKEN = "token"
  QAUTH_SECRET = "scecret"

  AGE_SECONDS = TWEET_AGE * 24 * 60 * 60
  SECONDS = Time.now
end