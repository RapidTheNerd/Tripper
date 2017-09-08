class Likes

  require 'rubygems'
  require 'twitter'
  require 'json'
  require 'faraday'

  USER = "enterUsername"
  TWEET_AGE = 1 #enter the age of tweets to kill

  CONSUMER_KEY = "key"
  CONSUMER_SECRET = "secret"
  OAUTH_TOKEN = "token"
  OAUTH_SECRET = "scecret"

  AGE_SECONDS = TWEET_AGE * 24 * 60 * 60
  SECONDS = Time.now

  REQ = 200
end