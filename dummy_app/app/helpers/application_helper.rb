module ApplicationHelper
  include Pagy::Frontend

  def calendar_event_helper(event, user)
    event_signup = event.event_signups.where(user: user).first
    classes = case event_signup.try(:status)
              when nil
                "badge-xs badge-warning"
              when "attending"
                "badge-xs badge-success"
              when "cannot_attend"
                "badge-xs badge-danger"
              end
    link_to event.name, url_for(event), class: "badge my-2".concat(classes)
  end

  # = render partial: "shared/bootstrap_nav", locals: { pagy: @pagy }
  def pagy_helper(pagy, smart_hide: true)
    render partial: "lasha/shared/bootstrap_nav", locals: { pagy: pagy, smart_hide: smart_hide }
  end

  def alertifyjs_flash
    flash_messages = []
    flash.each do |type, message|
      type = "success" if type == "notice"
      type = "warning" if type == "warning"
      type = "error"   if type == "alert"
      alertify = "alertify.#{type}('#{message}');"
      flash_messages << alertify.html_safe if message
    end

    "
      <script>
        document.addEventListener('turbolinks:load', function() {
          alertify.dismissAll();
          #{flash_messages.join}
        });
      </script>
    ".html_safe
  end

  # def bootstrap_class_for(flash_type)
  #   {
  #     success: "alert-success",
  #     error: "alert-danger",
  #     alert: "alert-warning",
  #     notice: "alert-info"
  #   }.stringify_keys[flash_type.to_s] || flash_type.to_s
  # end

  def new_record_form_helper(object, text_1, text_2)
    object.new_record? ? text_1 : text_2
  end

  def form_submit_helper(object)
    t((object.new_record? ? :post : :update), model_name: object.class)
  end

  def bell_notification_with_conditional_counter
    tag_params = { class: "notification-bell" }
    count = Notification.unread_count(current_user)
    tag_params[:data] = { count: count } if count.nonzero?

    icon("fas", "bell", **tag_params)
  end

  def notification_class_helper(notification)
    notification.read? ? "notification-read" : "notification-unread"
  end

  def form_visible?(form_name, user)
    case form_name
    when :send_verification_code
      "show" if user.sms_verification_code.blank?
    when :resend_verification_code
      "show" if user.sms_verification_code.present?
    when :verify_code
      "show" if user.sms_verification_code.present?
    end
  end
end
