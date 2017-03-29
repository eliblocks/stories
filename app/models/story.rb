class Story < ApplicationRecord
  include AlgoliaSearch

  belongs_to :user
  belongs_to :category
  has_many :relationships

  validates :title, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50}
  validates :description, presence: true, uniqueness: true,
            length: { minimum: 10, maximum: 140 }
  validates :body, presence: true, uniqueness: true,
            length: { minimum: 5000, maximum: 60000 }
  validate :story_length

  algoliasearch do
    attribute :title
    searchableAttributes ['title']
    customRanking ['desc(favorites_count)']
    hitsPerPage 30
  end

  def story_length
    if category_id != 1
      if body.length < 10000
        errors.add(:body, "Must be greater than 10000 characters")
      elsif body.length > 30000
        errors.add(:body, "Must be less than 30000 characters")
      end
    end
  end

  def favorite_count
    relationships.where(block: false).count
  end

  def block_count
    relationships.where(block: true).count
  end

  def self.reset_favorites_count
    Story.all.each do |story|
      story.update(favorites_count: story.favorite_count)
    end
  end

  def self.reset_blocks_count
    Story.all.each do |story|
      story.update(blocks_count: story.block_count)
    end
  end

  def self.sorted_pages(params)
    order(favorites_count: :desc).page(params[:page]).per(30)
  end

  def min_story_length
    category_id == 1 ? 5000 : 10000
  end

  def max_story_length
    category_id == 1 ? 60000 : 30000
  end


end
