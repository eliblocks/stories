module ApplicationHelper

  def vote_button(object, type, size="sm")
    if logged_in?
      vote_params = { story_id: story_id(object),
                      block: type,
                      followed_id: followed_id(object) }
      render 'shared/vote', { vote_params: vote_params,
                              size: size,
                              count: count(object, type),
                              icon: icon(type),
                              path: path(object),
                              http: http(object),
                              toggle: toggle(object, type) }
    else
      render 'shared/guest_vote', count: count(object, type),
                                  icon: icon(type)
    end
  end

  def follow?(object)
    if object.class == Story
      return !current_user.following?(object.user)
    elsif object.class == User
      return !current_user.following?(object)
    end
  end

  def user(object)
    if object.class == Story
      object.user
    else
      object
    end
  end

  def icon(type)
    type == true ? "fa fa-times" : "fa fa-heart"
  end

  def toggle(object, type)
    if (type == false && current_user.favoriting?(user(object))) ||
        (type == true && current_user.blocking?(user(object)))
      return "active"
    else
      return ""
    end
  end

  def path(object)
    if follow?(object)
      return relationships_path
    else
      relationship = current_user.active_relationship(User.find(followed_id(object)))
      relationship_path(relationship)
    end
  end

  def http(object)
    follow?(object) ? :post : :delete
  end

  def count(object, type)
    type == true ? object.blocks_count : object.favorites_count
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

  def active_if(path)
    if current_page?(path) || (path == stories_path && current_page?(root_url))
      ' active'
    elsif path == 'dropdown' && (params[:action] == 'blocked_users') ||
          path == 'dropdown' && (params[:action] == 'all_users')
      ' active'
    else
     ''
    end
  end

  def blank_image
    'https://pixabay.com/en/blank-profile-picture-mystery-man-973460/'
  end
end
