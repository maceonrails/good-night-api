class ClockIn < ApplicationRecord
  belongs_to :user

  has_one :clock_out

  validates :user, presence: true

  scope :clocked_in, -> { left_outer_joins(:clock_out).where(clock_outs: { id: nil }) }
  scope :clocked_out, -> { joins(:clock_out) }
  scope :clocked_in_past_week, -> { where('clock_ins.time > ?', 1.week.ago).order(:created_at) }
  scope :order_by_sleep_duration, -> { clocked_out.order(Arel.sql('clock_outs.time - clock_ins.time DESC')) }
  scope :past_week_sleep_records, -> { clocked_in_past_week.order_by_sleep_duration }

  def clock_out!
    create_clock_out!(time: Time.zone.now)
  end
end
