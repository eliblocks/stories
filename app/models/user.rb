class User < ApplicationRecord

  has_many :stories
  has_many :active_relationships, class_name:   "Relationship",
                                  foreign_key:  "follower_id",
                                  dependent:    :destroy
  has_many :passive_relationships, class_name:    "Relationship",
                                   foreign_key:  "followed_id",
                                   dependent:    :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :facebook_id, uniqueness: true, allow_nil: true

  def self.followed_ids
    Relationship.select(:followed_id).distinct
  end

  def self.writers
    User.joins(:stories).distinct
  end

  def unblocked_writers
    User.writers.where.not(id: blocking.ids)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def blocking
    blocked = active_relationships.where(block: 't').pluck(:followed_id)
    User.where(id: blocked)
  end

  def favoriting
    favorited = active_relationships.where(block: 'f').pluck(:followed_id)
    User.where(id: favorited)
  end

  def favoriters
    passive_relationships.where(block: false)
  end

  def blockers
    passive_relationships.where(block: true)
  end

  def favorite(other_user, story = nil)
    active_relationships.create!(followed_id: other_user.id,
                                  block: false,
                                  story_id: (story.id if story))
  end

  def block_user(other_user, story = nil)
    if active_relationship(other_user)
      active_relationship(other_user).destroy!
    end
    active_relationships.create!(followed_id: other_user.id,
                block: true, story_id: (story.id if story))
  end

  def unfavorite(other_user)
    unfollow(other_user)
  end

  def unblock(other_user)
    unfollow(other_user)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def favoriting?(other_user)
    following.include?(other_user) &&
    active_relationship(other_user).block == false
  end

  def blocking?(other_user)
    following.include?(other_user) &&
    active_relationship(other_user).block == true
  end

  def active_relationship(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  def passive_relationship(other_user)
    passive_relationship.find_by(follower_id: other_user.id)
  end

  def favorite_stories
    Story.where(user_id: favoriting.ids)
  end

  def blocked_stories
    Story.where(user_id: blocking.ids)
  end

  def unblocked_stories
    Story.where.not(user_id: blocking.ids)
  end

  def unblocked_users
    User.where.not(id: blocking.ids)
  end


  def self.reset_favorites_count
    User.all.each do |user|
      if user.favoriters.count
        user.update_attribute(:favorites_count, user.favoriters.count)
      else
        user.update_attribute(:favorites_count, 0)
      end
    end
  end

  def self.reset_blocks_count
    User.all.each do |user|
      if user.favoriters.count
        user.update_attribute(:blocks_count, user.blockers.count)
      else
        user.update_attribute(:blocks_count, 0)
      end
    end
  end

  def process(auth)
    if auth.extra.raw_info.nil?
      process_guest(auth)
    else
      self.email ||= auth.info.email
      self.name = auth.info.name
      self.image = auth.info.image
      self.verified = auth.info.verified
      self.facebook_id ||= auth.extra.raw_info.id
      self.first_name = auth.extra.raw_info.first_name
      self.last_name = auth.extra.raw_info.last_name
      self.link = auth.extra.raw_info.link
      self.gender = auth.extra.raw_info.gender
      self.picture = auth.extra.raw_info.picture.data.url
      self.timezone = auth.extra.raw_info.timezone
      self.updated_time = auth.extra.raw_info.updated_time
      self.locale = auth.extra.raw_info.locale
      self.age_range = auth.extra.raw_info.age_range.min.join
      self.favorites_count = 0
      self.blocks_count = 0
    end
  end

  def age_group
    case self.age_range
    when 'min21'
      'Over 21'
    when 'max20'
      'Over 18'
    when 'max17'
      'Under 18'
    end
  end
end
