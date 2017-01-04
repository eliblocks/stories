class Story < ApplicationRecord
  belongs_to :user
  has_many :relationships

  validates :title, presence: true, length: { minimum: 3, maximum: 25}
  validates :description, presence: true, uniqueness: true,
            length: { minimum: 10, maximum: 140 }
  validates :body, presence: true, uniqueness: true,
            length: { minimum: 1000, maximum: 50000 }

  def favorite_count
    relationships.where(block: false).count
  end

  def block_count
    relationships.where(block: true).count
  end

end
