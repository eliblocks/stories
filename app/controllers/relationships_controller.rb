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

  def vote
    if params[:story_id]
      story = Story.find(params[:story_id])
      user = story.user
    elsif params[:user_id]
      user = User.find(params[:user_id])
    end
    type = params[:vote_type]
    route_vote(user, type, story)
  end

  private

  def route_vote(user, type, story=nil)
    relationship = Relationship.find_by(follower_id: current_user.id, followed_id: user.id)
    relationship = relationship.try(:destroy!)
    unless relationship && relationship.block.to_s == type
      follow(user, type, story)
    end
    redirect_back(fallback_location: root_url)
  end

  def follow(user, type, story)
    @relationship = Relationship.new(follower_id: current_user.id,
                                      followed_id: user.id,
                                      story_id: story.try(:id),
                                      block: type)
    @relationship.save!
  end

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












