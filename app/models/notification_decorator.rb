class NotificationDecorator < SimpleDelegator
  def redirect_path
    case notifiable
    when Comment
      notifiable.post
    when Connection
      notifiable.follower
    when Post, Invitation
      notifiable
    else
      notifiable.likeable.is_a?(Comment) ? notifiable.likeable.post : notifiable.likeable
    end
  end
end
