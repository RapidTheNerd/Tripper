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

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = CONSUMER_KEY
    config.consumer_secret = CONSUMER_SECRET
    config.access_token = OAUTH_TOKEN
    config.access_token_secret = OAUTH_SECRET
  end

  likes = []
  oldest_like_id = 99999999999999999999
  got_likes = true

  puts "Collecting likes"

  while got_likes do
    begin
      new_likes = client.likes(USER,{:count => 200, :max_id => oldest_like_id})
      if(new_likes.length > 0) then
        oldest_like_id = new_likes.id - 1
        likes += new_likes
        puts "Got more likes #{new_likes.id}"
      else
        puts "No more to obtain"
        got_likes = false
      end
    rescue Twitter::Error::HTTPTooManyRequests => e
      puts "Hit the request limit for #{e.rate_limit.rest_in} seconds"
      sleep e.rate_limit.rest_in
      retry

    rescue StandardError => e
      puts e.inspect
      exit
    end
  end

  puts "Removing likes"

  likes.each do |fave|
    puts "Removing likes from #{likes.id}"
    begin
      client.unlike(likes.id)

    rescue Twitter::Error::HTTPTooManyRequests => e
      puts "Hit the request limit for #{e.rate_limit.rest_in} seconds"
      sleep e.rate_limit.rest_in
      retry

    rescue StandardError => e
      puts e.inspect
      exit
    end
  end

    puts "Finished removing likes"
end