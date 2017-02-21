class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:destroy]
  before_action :set_story, only: [:create, :destroy]
  before_action :authenticate_user

  def index
    @stories = current_user.favorite_stories.sorted_pages(params)
    @categories = Category.all

  end

  def blocked_users
    @users = current_user.blocking.joins(:passive_relationships).where(relationships: { follower_id: current_user.id} )
  end

  def create
    follow_other_user
    increment_story_count
    increment_user_count
    redirect_back fallback_location: root_url
  end

  def destroy
    current_user.unfollow(other_user)
    decrement_story_count
    decrement_user_count
    redirect_back fallback_location: root_url
  end

  private

  def follow_other_user
    if params[:block] == "false"
      @relationship = current_user.favorite(other_user, @story)
    elsif params[:block] == "true"
      current_user.unfollow(other_user) if current_user.following?(other_user)
      @relationship = current_user.block_user(other_user, @story)
    else
      byebug
    end
  end

  def increment_story_count
    if params[:block] == "true" && @story && @relationship.persisted?
      Story.increment_counter(:blocks_count, @story.id)
    elsif params[:block] == "false" && @story && @relationship.persisted?
      Story.increment_counter(:favorites_count, @story.id)
    end
  end

  def decrement_story_count
    if params[:block] == "true"
      Story.decrement_counter(:blocks_count, @relationship.story_id)
    elsif params[:block] = "false"
      Story.decrement_counter(:favorites_count, @relationship.story_id)
    end
  end

  def increment_user_count
    if params[:block] == "true" && @relationship.persisted?
      User.increment_counter(:blocks_count, other_user)
    elsif params[:block] == "false" && @relationship.persisted?
      User.increment_counter(:favorites_count, other_user)
    end
  end

  def decrement_user_count
    if params[:block] == "true"
      User.decrement_counter(:blocks_count, other_user)
    elsif params[:block] == "false"
      User.decrement_counter(:favorites_count, other_user)
    end
  end

  def other_user
    if params[:user_id]
      User.find(params[:user_id])
    elsif params[:story_id]
      Story.find(params[:story_id]).user
    end
  end

  def relationships_params
    params.permit(:follower_id, :followed_id, :block, :story_id)
  end

  def set_relationship
    @relationship = Relationship.find(params[:id])
  end

  def set_story
    if params[:story_id]
      @story = Story.find(params[:story_id])
    end
  end
end












