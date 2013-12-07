module ApplicationHelper

  # json helper
  def json_for target, options = {}
    options[:scope] ||= self
    options[:url_options] ||= url_options
    target.active_model_serializer.new(target, options).to_json
  end

  def full_name_of user
    "#{user.first_name.capitalize} #{user.last_name.capitalize}"
  end

  def avatar_url user, size=25
    gravatar_id = Digest::MD5::hexdigest(user.email.strip.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def define_alert_type type
    { success: 'success', notice: 'success', alert: 'danger' }[type] || type.to_s
  end

  def title title
    content_for :title, " | " + title if title
  end

  def description descp
    content_for :description, descp
  end

  def keywords kw
    content_for :keywords, kw
  end

  def is_owner_of obj, opts={}
    if opts[:user]
      obj.user == opts[:user]
    elsif current_user
        obj.user == current_user
    else
      false
    end
  end

end
