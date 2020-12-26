# frozen_string_literal: true

class Wow::EventSignup < ApplicationRecord
  enum status: { attending: "1", cannot_attend: "0" }

  belongs_to :calendar_event, class_name: "Calendar::Event"
  belongs_to :user
  belongs_to :wow_character, optional: true

  validates :status, inclusion: { in: statuses.keys, message: :invalid }
  validates :user, uniqueness: { scope: :calendar_event, message: "Already Signed up for this event." }
end
