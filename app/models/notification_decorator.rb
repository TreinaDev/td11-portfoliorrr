class NotificationDecorator < SimpleDelegator
  def redirect_after_click
    case notifiable
    when Comment
      notifiable.post
    when Connection
      notifiable.follower
    when Like
      notifiable.likeable.is_a?(Comment) ? notifiable.likeable.post : notifiable.likeable
    else
      notifiable
    end
  end
end
