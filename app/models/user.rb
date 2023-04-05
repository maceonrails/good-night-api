class User < ApplicationRecord
  has_many :clock_ins
  has_many :clock_outs, through: :clock_ins, source: :clock_out

  validates :name, presence: true
end
