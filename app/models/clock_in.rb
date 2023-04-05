class ClockIn < ApplicationRecord
  belongs_to :user
  has_one :clock_out

  validates :user, presence: true
end
