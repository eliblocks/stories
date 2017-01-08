module ApplicationHelper

  def favorite_button(object)
    favorite_params = { follower_id: current_user.id,
                        followed_id: followed_id(object),
                        story_id: story_id(object),
                        block: false }
    render 'shared/favorite', favorite_params: favorite_params, count: count(object)
  end

  def unfavorite_button(object)
    unfavorite_params = { follower_id: current_user.id,
                          story_id: story_id(object) }
    render 'shared/unfavorite', unfavorite_params: unfavorite_params,
                                count: count(object),
                                relationship: relationship(object)
  end

  def hide_button(object)
    hide_params = { follower_id: current_user.id,
                    followed_id: followed_id(object),
                    story_id: story_id(object),
                    block: true }
    render 'shared/block', hide_params: hide_params, count: count(object)
  end

  def count(object)
    object.favorite_count
  end

  def followed_id(object)
    if object.class == Story
      return object.user.id
    else
      return user.id
    end
  end

  def story_id(object)
    if object.class == Story
      return object.id
    else
      return nil
    end
  end

  def relationship(object)
    current_user.active_relationship(User.find(followed_id(object)))
  end

end
