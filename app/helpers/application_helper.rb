module ApplicationHelper

  def vote_button(object, type, size="sm")
    user = get_user(object)
    relationship = get_relationship(user)
    vote_params = { user_id: user.id, block: type }
    vote_params[:story_id] = object.id if object.class == Story

    render 'shared/vote', { vote_params: vote_params,
                            count: count(object, type),
                            icon: icon(type),
                            path: path(relationship, type),
                            http: http(relationship, type),
                            toggle: toggle(relationship, type)
                            }

  end

  def icon(type)
    if type == true
      return "fa fa-times fa-fw"
    else
      return "fa fa-heart fa-fw"
    end
  end

  def toggle(relationship, type)
    if relationship && relationship.block == type
      return  "active"
    else
      return ""
    end
  end

  def path(relationship, type)
    if relationship && type == relationship.block
      relationship_path(relationship)
    else
      relationships_path
    end
  end

  def http(relationship, type)
    if relationship && type == relationship.block
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
    if @relationships
      return @relationships.find { |relationship| relationship.followed_id == user.id }
    end
    return @relationship
  end


  def blank_image
    'https://pixabay.com/en/blank-profile-picture-mystery-man-973460/'
  end
end
