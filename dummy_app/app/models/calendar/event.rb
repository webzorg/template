class Calendar::Event < ApplicationRecord
  belongs_to :user
  has_many :event_signups, class_name: "Wow::EventSignup", foreign_key: :calendar_event_id
  has_many :users, through: :event_signups

  validates :name, :start_time, presence: true
  validate :validate_start_time

  has_rich_text :description

  private

    def validate_start_time
      errors.add(:start_time, "can't be in the past") if start_time < Time.zone.now
    end
end
