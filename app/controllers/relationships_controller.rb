class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:destroy]
  before_action :set_story, only: [:create, :destroy]

  def index
    @favorites = current_user.favorite_stories
  end

  def blocked_users
    @users = current_user.blocking
  end

  def create
    follow_other_user
    increment_story_count
    redirect_after_vote
  end

  def destroy
    current_user.unfollow(other_user)
    decrement_story_count
    redirect_back fallback_location: root_url
  end

  private

  def follow_other_user
    if params[:block] == "false"
      current_user.favorite(other_user, @story)
    elsif params[:block] == "true"
      current_user.unfollow(other_user) if current_user.following?(other_user)
      current_user.block_user(other_user, @story)
    else
      debugger
    end
  end

  def increment_story_count
    if params[:block] == "true" && @story
      Story.increment_counter(:blocks_count, @story.id)
    elsif params[:block] == "false" && @story
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

  def other_user
    if params[:followed_id]
      User.find(params[:followed_id])
    elsif !params[:story_id].empty?
      Story.find(params[:story_id]).user
    elsif params[:id]
      User.find(@relationship.followed_id)
    end
  end

  def relationships_params
    params.permit(:follower_id, :followed_id, :block, :story_id)
  end

  def set_relationship
    @relationship = Relationship.find(params[:id])
  end

  def set_story
    @story = Story.find(params[:story_id]) unless params[:story_id].empty?
  end

  def redirect_after_vote
    if request.referer == stories_url ||
      request.referer == root_url
      redirect_to root_url
    elsif request.referer == user_url(other_user) ||
      request.referer == story_url(@story)
      redirect_back fallback_location: root_url
    else
      redirect_back fallback_location: root_url
    end
  end
end












