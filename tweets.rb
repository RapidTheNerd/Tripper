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

  while got_tweets do
    begin
      new_tweets = client.user_timeline(TWITTER_USER,  {:count => REQ,
      :max_id => oldest_tweet_id,
      :include_entities => false,
      :include_retweets => true}) #change to false if you don't want your rt's deleted

      if(new_tweets.length > 0) then
        puts "Obtained: #{new_tweets.length}"
        tweets += new_tweets
      else
        got_tweets = false
      end
    rescue Twitter::Error::HTTPTooManyRequests => e
      puts "Rate limit reached. Pausing on #{e.rate_limit.rest_in} seconds"
      sleep e.rate_limit.rest_in
      retry #will continue to retry until the limit fucks off

    rescue StandardError => e
      puts e.inspect
      exit(1)
    end
  end
    tweets.each do |tweet|
      begin
        tweet_age = SECONDS - tweet_created_at
        tweet_age_in_days = (tweet_age/(24 * 60 * 60)).round
        if(tweet_age > AGE_SECONDS) then
          puts "Ignored tweets from #{tweet_age_in_days}D old"
        end
        puts "#{tweet.text}"

      rescue Twitter::Error::HTTPTooManyRequests => e
      puts "Rate limit reached. Pausing on #{e.rate_limit.rest_in} seconds"
      sleep e.rate_limit.rest_in
      retry #will continue to retry until the limit fucks off

      rescue StandardError => e
        puts e.inspect
        exit
        end
    end
end