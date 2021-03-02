# frozen_string_literal: true

class PhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match?(/^(514|551|555|557|558|559|568|570|571|574|577|591|592|593|595|596|597|598|599)+\d{6}$/)
      record.errors[attribute] << (options[:message] || I18n.t(:phone_number_can_only_contain_9_digits))
    end
  end
end
