
require 'open-uri'
require 'nokogiri'
require 'aws-sdk'

class AmlitStory
  attr_accessor :doc, :title, :author, :body

  def initialize(doc)
    @doc = doc
    @title = title
    @author = author
    @paragraphs = paragraphs
    @body = body
  end

  def title
    @doc.at_css("h1[itemprop=name]").text
  end

  def author
    @doc.at_css("a[itemprop=author]").text
  end

  def paras
    @doc.css(".jumbotron > p")
  end

  def paragraphs
    paragraphs = []
    paras.each do |para|
      if para.text.size > 1
        paragraphs << para.text
      end
    end
    return paragraphs
  end

  def body
    @paragraphs.join("\n\n")
  end
end

class StoryBuilder
  attr_accessor :user, :story, :title

  def initialize(author, title, body)
    @author = author
    @title = title
    @body = body
    @description = @body[0..135]
    @category = 1
    @author = build_author
    @story = build_story
  end

  def build_author
    domain = "@example.com"
    email_name = @author.gsub(' ', '.')
    email = "#{email_name}#{domain}"
    @user = User.new(name: @author, email: email)
  end

  def build_story
    @story = Story.new(title: @title,
                        body: @body,
                        description: @description,
                        category_id: @category)
  end
end


class StorySaver
  attr_accessor :story, :user

  def initialize(story_file)
    @story = story_file.story
    @user = story_file.user
    @successful = false
    swap_user
  end

  def swap_user
    if User.find_by(name: @user.name)
      @user = User.find_by(name: @user.name)
      save_story
    else
      validate_user
    end
  end

  def validate_user
    if @user.save
      save_story
    else
      report_user_failure
    end
  end

  def save_story
    @story.user_id = @user.id
    if @story.save
      @successful = true
    else
      report_story_failure
    end
  end

  def report_story_failure
    @story_failure = @story.errors.full_messages
  end

  def report_user_failure
    @user_error = @user.errors.full_messages
  end

  def successful?
    @successful
  end
end

class Downloader
  attr_accessor :saved_stories, :failed_stories
  def initialize(s3)
    @s3 = s3
    @amlit_url = 'https://s3-us-west-1.amazonaws.com/new-stories/'
    @keys = get_keys
    @stories = []
    @saved_stories = []
    @failed_stories = []
    build_stories
    save_stories
  end

  def get_keys
    keys = []
    @s3.list_objects(bucket: 'new-stories').each do |page|
      keys << page.contents.map { |obj| obj.key }
    end
    keys.flatten!
  end

  def build_stories
    @keys.each do |key|
      story_file = Nokogiri::HTML(open("#{@amlit_url}#{key}"))
      story = AmlitStory.new(story_file)
      @stories << StoryBuilder.new(story.author, story.title, story.body)
    end
  end

  def save_stories
    @stories.each do |story|
      story = StorySaver.new(story)
      if story.successful?
        @saved_stories << story
      else
        @failed_stories << story
      end
    end
  end

  def print_success
    @saved_stories.each do |story|
      puts story.user
      puts story.story
      puts story.story.persisted?
    end
  end

  def print_failure
    @failed_stories.each do |story|
      puts story.user
      puts story.story
      puts story.story.persisted?
      puts story.story.errors.full_messages
    end
  end
end

desc "Create user and story records from S3 bucket"
task amlit_extractor: [:environment] do
  s3 = Aws::S3::Client.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION'])
  downloader = Downloader.new(s3)
  File.open("lib/tasks/seeding_log.txt", "a") do |f|
    f.puts "-" * 80
    f.puts "Saving run at: #{Time.now}"
    f.puts "failed saves:"
    f.puts downloader.failed_stories.count
    downloader.failed_stories.each do |s|
      f.puts "." * 20
      f.puts s.user.name
      f.puts s.story.title
      f.puts s.user.errors.full_messages
      f.puts s.story.errors.full_messages
    end
    f.puts "successful saves:"
    f.puts "." * 40
    f.puts downloader.saved_stories.count
    downloader.saved_stories.each do |s|
      f.puts "." * 20
      f.puts s.user.name
      f.puts s.story.title
    end
  end
end

























