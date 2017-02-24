class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  belongs_to :story, optional: true
  after_create :increment_counters
  after_destroy :decrement_counters



  validates :follower_id, presence: true
  validates :followed_id, presence: true

  def self.user_story_relationships(user, stories)
    Relationship.where(follower_id: user.id, story_id: stories.ids)
  end

  def self.user_user_relationships(user, users)
    Relationship.where(follower_id: user.id, followed_id: users.ids)
  end

  def increment_counters
    if story_id && block == false
      Story.increment_counter(:favorites_count, story_id)
    elsif story_id && block == true
      Story.increment_counter(:blocks_count, story_id)
    end
    if block == false
      User.increment_counter(:favorites_count, followed_id)
    elsif block == true
      User.increment_counter(:blocks_count, followed_id)
    end
  end

  def decrement_counters
    if story_id && block == false
      Story.decrement_counter(:favorites_count, story_id)
    elsif story_id && block == true
      Story.decrement_counter(:blocks_count, story_id)
    end
    if block == false
      User.decrement_counter(:favorites_count, followed_id)
    elsif block == true
      User.decrement_counter(:blocks_count, followed_id)
    end
  end

end
