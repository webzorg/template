class Calendar::Event < ApplicationRecord
  belongs_to :user

  validates :name, :description, :start_time, presence: true
  validate :validate_start_time

  private

    def validate_start_time
      errors.add(:start_time, "can't be in the past") if start_time < Time.zone.now
    end
end
