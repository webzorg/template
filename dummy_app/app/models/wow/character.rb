class Wow::Character < ApplicationRecord
  enum priority: { main: "1", alt: "0" }

  belongs_to :user
  belongs_to :wow_race, class_name: "Wow::Race"
  belongs_to :wow_class, class_name: "Wow::Class"
  belongs_to :wow_role, class_name: "Wow::Role"

  validates :name, :level, :wow_race_id, :wow_class_id, :wow_role_id, presence: true

  validate :can_only_have_one_main

  ITEM_NAMES = %i[
    head neck shoulder back chest wrist hands waist legs feet
    finger_1 finger_2trinket_1 trinket_2 main_hand off_hand ranged_relic
  ]

  def items
    ITEM_NAMES.map { |item| [item, read_attribute(item)] }.to_h
  end

  private

    def can_only_have_one_main
      return if priority == "alt" || (user.characters.where(priority: "main") - [self]).blank?

      errors.add(:base, "You already have a main character")
    end
end
