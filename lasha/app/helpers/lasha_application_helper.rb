module LashaApplicationHelper
  include Pagy::Frontend

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

  def index_actions_link_helper(action, item, data)
    case action
    when :show
      link_to action,
              object_path_generator(action, item, data),
              class: "btn btn-info btn-xs btn-block"
    when :edit
      link_to action,
              object_path_generator(action, item, data),
              class: "btn btn-warning btn-xs btn-block"
    when :destroy
      link_to action,
              object_path_generator(action, item, data),
              method: :delete,
              data: { confirm: "Are you sure you want to delete #{data[:model]}?" },
              class: "btn btn-danger btn-xs btn-block"
    end
  end

  def smart_form_field(f, data, column_name)
    column_data = data[:attributes][column_name]
    column_type = column_data ? column_data[:type] : :text_field
    html_options = {
      # id: "fg_#{column_name}",
      disabled: column_data[:disabled] && action_name == "edit"
    }
    field_options = [column_type, column_name]

    if column_data[:override_value] && !%w[new create].include?(action_name)
      html_options[:value] = column_data[:override_value].call(f.object)
    end

    case column_type
    when :text_field, :text_area
      html_options[:class] = "form-control"
    when :check_box
      html_options[:class] = "custom-control-input"
    when :select
      html_options[:class] = "custom-select"
      field_options += [
        options_for_select(column_data[:collection], selected: data[:object].public_send(column_name)),
        { include_blank: true }
      ]
    when :datetime_select
      field_options += [
        { ampm: false, minute_step: 15 }
      ]
    end

    f.public_send(*field_options, html_options)
  end

  def form_group_wrapper_class(data, column_name)
    column_data = data[:attributes][column_name]
    column_type = column_data ? column_data[:type] : :text_field
    case column_type
    when :check_box
      "custom-control custom-checkbox"
    else
      "form-group"
    end
  end

  def is_check_box?(data, column_name)
    column_data = data[:attributes][column_name]
    column_type = column_data ? column_data[:type] : :text_field

    true if column_type == :check_box
  end

  def object_path_generator(action, item, data)
    url_for(
      controller: "#{data[:namespace]}/#{controller_name}",
      action: action,
      id: item.id
    )
  end
end
