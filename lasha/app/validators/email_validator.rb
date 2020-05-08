class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.match?(value)

    record.errors[attribute] << (options[:message] || I18n.t(:incorrect_email))
  end
end
