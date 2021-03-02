# frozen_string_literal: true

module GravatarImageTag
  def self.value_cleaner(value)
    URI.encode_www_form_component(value.to_s)
  end
end
