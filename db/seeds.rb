# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

the_garbage_collector = File.read('pdf/the_garbage_collector.txt')
a_thousand_deaths = File.read('pdf/a_thousand_deaths.txt')
murderer = File.read('pdf/murderer.txt')
before_eden = File.read('pdf/before_eden.txt')

Story.create!(title: 'The Garbage Collector',
              description: 'In this story "The Garbage Collector," Ray Bradbury uses symbolism',
              body: the_garbage_collector,
              user: User.first)

Story.create!(title: 'A Thousand Deaths',
              description: 'I had been in the water about an hour, and cold, exhausted, with a terrible cramp in my right calf',
              body: a_thousand_deaths,
              user: User.first)

Story.create!(title: 'Murderer',
              description: 'Music moved with him in the white halls. He passed an office door.',
              body: murderer,
              user: User.last)

Story.create!(title: 'Before Eden',
              description: '“I guess,” said Jerry Garfield, cutting the engines, “that this is the end of the line.”',
              body: before_eden,
              user: User.second)
