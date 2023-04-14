class ClockIn < ApplicationRecord
  belongs_to :user
  has_one :clock_out

  validates :user, presence: true

  scope :clocked_in, -> { left_outer_joins(:clock_out).where(clock_outs: { id: nil }) }
  scope :clocked_out, -> { joins(:clock_out) }
  scope :clocked_in_previous_week, -> { where(clock_ins: { time: 1.week.ago.beginning_of_week..1.week.ago.end_of_week }) }
  scope :order_by_sleep_duration, -> { clocked_out.order(Arel.sql('clock_outs.time - clock_ins.time DESC')) }
  scope :friends_sleep_record, ->(user) {
    joins('LEFT JOIN friendships ON friendships.friend_id = clock_ins.user_id')
      .where('friendships.user_id = ?', user.id)
  }
  scope :friends_previous_week_sleep_records, ->(user) {
    friends_sleep_record(user)
      .order_by_sleep_duration
      .clocked_in_previous_week
  }

  def clock_out!
    create_clock_out!(time: Time.zone.now)
  end
end
