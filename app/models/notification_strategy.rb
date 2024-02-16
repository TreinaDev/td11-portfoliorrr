class NotificationStrategy < SimpleDelegator
  STRATEGY = {
    Invitation => ->(notifiable) { notifiable },
    Post => ->(notifiable) { notifiable },
    Comment => ->(notifiable) { notifiable.post },
    Connection => ->(notifiable) { notifiable.follower },
    Like => ->(notifiable) { notifiable.likeable.is_a?(Comment) ? notifiable.likeable.post : notifiable.likeable }
  }.freeze

  def redirect_after_click
    STRATEGY[notifiable.class].call(notifiable)
  end
end
