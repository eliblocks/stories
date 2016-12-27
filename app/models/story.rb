class Story < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3, maximum: 25}
  validates :description, presence: true, uniqueness: true,
            length: { minimum: 10, maximum: 140 }
  validates :body, presence: true, uniqueness: true,
            length: { minimum: 1000, maximum: 50000 }
end
