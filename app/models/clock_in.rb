class ClockIn < ApplicationRecord
  belongs_to :user

  has_one :clock_out

  validates :user, presence: true

  scope :clocked_in, -> { left_outer_joins(:clock_out).where(clock_outs: { id: nil }) }
  scope :clocked_out, -> { joins(:clock_out) }
  scope :clocked_in_past_week, -> { where('clock_ins.created_at > ?', 1.week.ago).order(:created_at) }

  def clock_out!
    create_clock_out!
  end
end
