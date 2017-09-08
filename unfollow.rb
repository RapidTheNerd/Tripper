class Unfollow

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
  TIMEOUT = 5

  REQ = 200

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = CONSUMER_KEY
    config.consumer_secret = CONSUMER_SECRET
    config.access_token = OAUTH_TOKEN
    config.access_token_secret = OAUTH_SECRET
  end
  the_preserved = ["usernames", "that aren't going to be unfollowed", "input here"]
  the_preserved = the_preserved.map {|username| username.downcase}

  puts "Preserving"
  puts the_preserved.display

  following_ids = client.friend_ids(USER).to_a
  save_file = File.open("following-bkup.txt", "a")

  following_ids.each do |id|
    name = client.user(id).screen_name.downcase
    if the_preserved.include?(name)
      puts "You will continue to following #{name}"
    else
      begin
        puts "Unfollowing #{name}"
        client.unfollow(id)
        save_file.puts name
        save_file.flush
      rescue Twitter::Error::HTTPTooManyRequests => e
        puts "Reached rate limit"
        sleep(error.rate_limit.rest_in)
      end
    end
    sleep(TIMEOUT)
  end
  puts "Unfollowed all apart from preserved"
end