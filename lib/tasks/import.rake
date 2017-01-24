desc "Create user and story records from text file directory"
task import: [:environment] do
  scraped_stories = 'scraped_stories'
  Dir.foreach(scraped_stories) do |fname|
    story_path = "#{scraped_stories}/#{fname}"
    next if fname.starts_with?('.')

    story_file = File.readlines(story_path)
    title = story_file[0].truncate(50)
    writer = story_file[1]
    description = story_file[2].truncate(140)
    body = story_file[3..story_file.size].join

    next if body.chars.size < 10000 || body.chars.size > 28000

    if User.pluck(:name).include?(writer)
      user = User.find_by(name: writer)
      user.update(image: 'blank_image.png')
    else
      user = User.new(name: writer, image: 'blank_image.png')
    end
    begin
      user.save!(validate: false)
    rescue
    end
    if Story.pluck(:title).include?(title)
      story = Story.find_by(title: title)
      Story.update(description: description, body: body)
    else
      story = Story.new(title: title, user_id: user.id, description: description, body: body, category_id: 4)
    end
    begin
      story.save!
    rescue
    end
  end
end

