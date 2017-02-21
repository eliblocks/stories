module ApplicationHelper

  def vote_button(object, type, size="sm")
    user = get_user(object)
    relationship = get_relationship(user)
    debugger
    vote_params = { user_id: user.id, block: type, story_id: story_id(object) }

    render 'shared/vote', { vote_params: vote_params,
                            count: count(object, type),
                            icon: icon(type),
                            path: path(relationship),
                            http: http(relationship),
                            toggle: toggle(relationship, type)
                            }

  end

  def icon(type)
    if type == true
      return "fa fa-times"
    else
      return "fa fa-heart"
    end
  end

  def toggle(relationship, type)
    if relationship && relationship.block == type
      return  "active"
    else
      return ""
    end
  end

  def path(relationship)
    if relationship
      relationship_path(relationship)
    else
      relationships_path
    end
  end

  def http(relationship)
    if relationship
      return :delete
    else
      return :post
    end
  end

  def count(object, type)
    if type == true
      object.blocks_count
    else
      object.favorites_count
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

  def get_user(object)
    object.class == Story ? object.user : object
  end

  def get_relationship(user)
    if following?(user)
      if show?
        @relationship
      elsif index?
        @relationships.find_by(followed_id: user.id)
      end
    end
  end

  def following?(user)
    if @relationship
      return true
    elsif @following && @following.include?(user)
      return true
    end
    false
  end

  def blank_image
    'https://pixabay.com/en/blank-profile-picture-mystery-man-973460/'
  end
end
