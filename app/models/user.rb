class User < ApplicationRecord
  has_many :clock_ins
  has_many :clock_outs, through: :clock_ins, source: :clock_out
  has_many :friendships
  has_many :friends, through: :friendships

  validates :name, presence: true

  def clock_in!
    return false if clock_ins.clocked_in.any?

    clock_ins.create!(time: Time.zone.now)
  end

  def clock_out!
    return false unless clock_ins.clocked_in.any?

    clock_ins.clocked_in.first.clock_out!
  end

  def clocked_in_past_week
    clock_ins.clocked_in_past_week
  end

  def follow!(friend)
    return false if friends.include?(friend)

    friendships.create!(friend: friend)
  end

  def unfollow!(friend)
    return false unless friends.include?(friend)

    friendships.find_by(friend: friend).destroy
  end

  def past_week_sleep_records
    clock_ins.past_week_sleep_records
  end
end
