class ClockOut < ApplicationRecord
  belongs_to :clock_in

  validates :clock_in, presence: true
end
