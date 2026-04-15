class Todo < ApplicationRecord
  belongs_to :user

  enum :priority, { low: 0, medium: 1, high: 2 }

  validates :title, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end
