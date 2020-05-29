module LashaApplicationHelper
  include Pagy::Frontend

  def index_actions_link_helper(action, item, data, permission_to_edit=true)
    case action
    when :show
      link_to action,
              object_path_generator(action, item, data),
              class: "btn btn-info btn-xs btn-block #{'disabled' if !permission_to_edit}"
    when :edit
      link_to action,
              object_path_generator(action, item, data),
              class: "btn btn-warning btn-xs btn-block #{'disabled' if !permission_to_edit}"
    when :destroy
      link_to action,
              object_path_generator(action, item, data),
              method: :delete,
              data: { confirm: "Are you sure you want to delete #{data[:model]}?" },
              class: "btn btn-danger btn-xs btn-block #{'disabled' if !permission_to_edit}"
    end
  end

  # = pagy_helper(data[:pagy])
  def pagy_helper(pagy)
    return nil if pagy.pages == 1

    render partial: "lasha/shared/bootstrap_nav", locals: { pagy: pagy }
  end

  def smart_form_field(f, data, column_name)
    f.object = data[:object] if data[:object] && f.object.blank?
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
        options_for_select(column_data[:collection], selected: data[:object].public_send("#{column_name}_before_type_cast")),
        { include_blank: column_data[:include_blank].nil? ? true : column_data[:include_blank] }
      ]
    when :collection_select
      html_options[:class] = "custom-select"
      field_options += column_data[:options]
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
