module LashaApplicationHelper
  include Pagy::Frontend

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

  # = lasha_pagy_helper(data[:pagy])
  def lasha_pagy_helper(pagy)
    return nil if pagy.pages == 1

    render partial: "lasha/shared/bootstrap_nav", locals: { pagy: pagy }
  end

  def smart_label_text(column_name, column_data)
    I18n.t(column_data[:label].present? ? column_data[:label] : column_name)
  end

  def smart_form_field(f, data, column_name)
    column_data = data[:attributes][column_name]
    column_type = column_data ? column_data[:type] : :text_field
    html_options = {
      id: "fg_#{column_name}",
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
