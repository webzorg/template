class User < Lasha::User
  has_many :notifications, dependent: :destroy

  def web_notifications
    # # Notification.create(
    # #   notify_type: "",
    # #   actor: user,
    # #   user: target_user,
    # #   target: target_object
    # # )
    # notifications.where(notify_type: %i[]).order(created_at: :desc)
    notifications.order(created_at: :desc)
  end
end