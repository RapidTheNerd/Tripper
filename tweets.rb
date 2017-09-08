class Tweets

  require 'rubygems'
  require 'twitter'
  require 'json'

  USER = "enterUsername"
  TWEET_AGE = 1 #enter the age of tweets to kill

  CONSUMER_KEY = "key"
  CONSUMER_SECRET = "secret"
  OAUTH_TOKEN = "token"
  OAUTH_SECRET = "scecret"

  AGE_SECONDS = TWEET_AGE * 24 * 60 * 60
  SECONDS = Time.now

  REQ = 200

  def delete(tweet, client)
    begin
      client.destroy_status(tweet.id)
    rescue StandardError => e
      puts e.inspect
      puts "Error encountered tweet #{tweet.id}"
      exit
    else
      puts "Removed tweet: #{tweet.id}"
    end
  end

  client Twitter::REST::Client.new do |config|
    config.consumer_key = CONSUMER_KEY
    config.consumer_secret = CONSUMER_SECRET
    config.access_token = OAUTH_TOKEN
    config.access_token_secret = OAUTH_SECRET
  end

  tweets = []
  got_tweets = true
  oldest_tweet_id = 999999999999999999999999
  
end