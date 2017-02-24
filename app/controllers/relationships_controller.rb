class RelationshipsController < ApplicationController

  before_action :set_story, only: [:create, :destroy]
  before_action :authenticate_user


  def create
    @relationship = Relationship.find_by(follower_id: current_user.id, followed_id: params[:user_id])
    @relationship.destroy if @relationship
    @relationship = Relationship.new(relationship_attributes)
    @relationship.save
    redirect_back fallback_location: root_url
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    redirect_back fallback_location: root_url
  end

  private

  def relationship_attributes
    attrs = { follower_id: current_user.id,
              followed_id: params[:user_id],
              block: params[:block] }
    attrs[:story_id] = params[:story_id] unless params[:story_id].blank?
    return attrs
  end

  def set_story
    if params[:story_id]
      @story = Story.find(params[:story_id])
    end
  end
end












