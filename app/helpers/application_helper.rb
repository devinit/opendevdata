module ApplicationHelper

  def full_name_of user
    p user
    "#{user.first_name} #{user.last_name}"
  end

  def avatar_url user, size=25
    gravatar_id = Digest::MD5::hexdigest(user.email.strip.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def define_alert_type type
    { success: 'success', notice: 'success', alert: 'danger' }[type] || type.to_s
  end

  def title title
    content_for :title, title
  end

  def description descp
    content_for :description, descp
  end

  def keywords kw
    content_for :keywords, kw
  end

end
