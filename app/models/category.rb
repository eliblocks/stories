class Category < ApplicationRecord
  has_many :stories
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 15 }
end
