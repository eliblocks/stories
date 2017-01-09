class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:destroy]
  before_action :set_story, only: [:create]

  def index
    @favorites = current_user.favorite_stories
  end

  def blocked_users
    @users = current_user.blocking
  end

  def create
    if params[:block] == "false"
      current_user.favorite(other_user, @story)
      redirect_after_vote
    elsif params[:block] == "true"
      current_user.unfollow(other_user) if current_user.following?(other_user)
      current_user.block_user(other_user, @story)
      redirect_after_vote
    else
      debugger
    end
  end

  def destroy
    current_user.unfollow(other_user)
    redirect_back fallback_location: root_url
  end

  private

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
      debugger
    end
  end
end












