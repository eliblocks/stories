module ApplicationHelper

  def unfollow_button(object, type)
    unfollow_params = { story_id: story_id(object),
                        block: type }

    render 'shared/unfollow', unfollow_params: unfollow_params,
                              count: count(object, type),
                              icon: type == true ? "fa fa-times" : "fa fa-heart",
                              relationship: find_relationship(object)
  end

  def follow_button(object, type)
    follow_params = { followed_id: followed_id(object),
                      story_id: story_id(object),
                      block: type }

    render 'shared/follow', follow_params: follow_params,
                            count: count(object, type),
                            icon: type == true ? "fa fa-times" : "fa fa-heart"
  end

  def count(object, type)
    type == true ? object.block_count : object.favorite_count
  end

  def followed_id(object)
    if object.class == Story
      return object.user.id
    else
      return object.id
    end
  end

  def story_id(object)
    if object.class == Story
      return object.id
    else
      return nil
    end
  end

  def find_relationship(object)
    current_user.active_relationship(User.find(followed_id(object)))
  end

  def active_if(path)
    if current_page?(path) || path == stories_path && current_page?(root_url)
      ' active'
    elsif path == 'dropdown' && ( params[:action] == 'blocked_users' ||
                                  params[:controller] == 'users'||
                                  params[:id] == current_user.id.to_s)
      ' active'
    else
     ''
    end
  end

end
