class Tree < ApplicationRecord
  include AASM

  validates :title, presence: true
  validates :content, presence: true

  scope :with_delicious_fruit, -> { where(title: %w[Apple Fig Peach Plum]) }
  scope :with_snacky_fruit, -> { where(title: %w[Hazel Walnut]) }

  aasm whiny_transitions: true do
    state :delicious, :snack
  end
end
