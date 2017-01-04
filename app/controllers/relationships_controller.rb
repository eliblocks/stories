class RelationshipsController < ApplicationController

  def create
    if params[:block] == "false"
      current_user.active_relationships.create!(relationships_params)
      flash[:success] = "Favorited user"
      redirect_back fallback_location: root_url
    elsif params[:block] == "true"
      current_user.unfollow(other_user) if current_user.following?(other_user)
      current_user.active_relationships.create!(relationships_params)
      flash[:success] = "Blocked user"
      redirect_back fallback_location: root_url
    else
      debugger
    end
  end

  def destroy
    current_user.unfollow(other_user)
    flash.now[:success] = "unfollowed"
    redirect_back fallback_location: root_url
  end

  private

  def relationships_params
    params.permit(:follower_id, :followed_id, :block, :story_id)
  end

  def other_user
    User.find(params[:followed_id])
  end



end
