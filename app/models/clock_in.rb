class ClockIn < ApplicationRecord
  belongs_to :user

  has_one :clock_out

  validates :user, presence: true

  scope :clocked_in, -> { left_outer_joins(:clock_out).where(clock_outs: { id: nil }) }
  scope :clocked_out, -> { joins(:clock_out) }

  def clock_out!
    create_clock_out!
  end
end
