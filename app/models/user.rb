# frozen_string_literal: true

class User < Lasha::User
  has_many :notifications, dependent: :destroy
  has_many :events, class_name: "Calendar::Event"

  ransack_alias :attributes, %i[first_name last_name company_name email].join("_or_")

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