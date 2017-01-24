class Story < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :relationships

  validates :title, presence: true, length: { minimum: 3, maximum: 50}
  validates :description, presence: true, uniqueness: true,
            length: { minimum: 10, maximum: 140 }
  validates :body, presence: true, uniqueness: true,
            length: { minimum: 10000, maximum: 30000 }

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
    order(favorites_count: :desc, title: :asc).page(params[:page]).per(30)
  end


end
