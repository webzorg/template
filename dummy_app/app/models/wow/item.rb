# frozen_string_literal: true

class Wow::Item < ApplicationRecord
  scope :filter_by_name, -> (name) {
    where(
      "cast(id as varchar) LIKE (?) OR name ILIKE (?)",
      "%#{name.downcase}%",
      "%#{name.downcase}%"
    )
  }
end
