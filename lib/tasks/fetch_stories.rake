require 'aws-sdk'
require 'open-uri'
require 'cgi'

class StoryFetcher
  attr_accessor :stories, :urls

  def initialize(bucket)
    @bucket = bucket
    @base_url = 'https://s3-us-west-1.amazonaws.com/amlit-text-stories/'
    @stories = []
  end

  def make_stories
    @bucket.objects.each do |obj|
      puts "\n\n\n"
      p "#{@base_url}#{obj.key}"
      puts "\n\n\n"
      story_file = open("#{@base_url}#{obj.key}")
      story_file = story_file.readlines
      puts story_file
      title = story_file[0]
      author = story_file[1]
      description = story_file[2]
      body = story_file[3]
      user_id = User.find_by(name: author)
      @stories << Story.new(title: title, description: description, body: body, user_id: user_id)
    end
  end

  def save_stories
    @stories.each do |story|
      story.save!
    end
  end
end


desc "Create user and story records from S3 text file directory"
task fetch_stories: [:environment] do
  s3 = Aws::S3::Resource.new(
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION'])

  bucket = s3.bucket('amlit-text-stories')

  fetcher = StoryFetcher.new(bucket)
  fetcher.make_stories
end
