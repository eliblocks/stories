class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  belongs_to :story, optional: true

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  def self.user_story_relationships(user, stories)
    Relationship.where(follower_id: user.id, story_id: stories.ids)
  end

  def self.user_user_relationships(user, users)
    Relationship.where(follower_id: user.id, followed_id: users.ids)
  end
end
