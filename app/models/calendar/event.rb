class Calendar::Event < ApplicationRecord
  has_paper_trail

  belongs_to :user

  validates :name, :start_time, presence: true
  validate :validate_start_time

  has_rich_text :description

  private

    def validate_start_time
      errors.add(:start_time, "can't be in the past") if start_time < Time.zone.now
    end
end
