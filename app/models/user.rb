class User < ApplicationRecord
  has_many :clock_ins
  has_many :clock_outs, through: :clock_ins, source: :clock_out

  validates :name, presence: true

  def clock_in!
    return false if clock_ins.clocked_in.any?

    clock_ins.create!
  end

  def clock_out!
    return false unless clock_ins.clocked_in.any?

    clock_ins.clocked_in.first.clock_out!
  end

  def clocked_in_past_week
    clock_ins.clocked_in_past_week
  end
end
