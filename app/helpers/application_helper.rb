module ApplicationHelper

  def switch(object, type)
    user = get_user(object)
    relationship = get_relationship(user)
    vars = {label: button_label(type),
            icon: icon(type),
            count: count(object, type),
            toggle: toggle(relationship, type),
            params: { "vote_type" => type, "#{object.class.to_s.downcase}_id" => object.id } }

    if showing?(object) || (params[:controller] == 'users' && params[:action] == 'index')
      render 'shared/show_vote', vars
    else
      render 'shared/index_vote', vars
    end
  end

  def button_label(type)
    type == true ? "Hide" : "Like"
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

  def object_param(object)
    if object.class == Story
      return { story_id: object.id }
    elsif object.class == Story
      return { user_id: object.id }
    end
  end

  def showing?(object)
    params[:action] == "show" &&
    params[:controller] == object.class.to_s.downcase.pluralize
  end

  def blank_image
    'https://pixabay.com/en/blank-profile-picture-mystery-man-973460/'
  end
end
