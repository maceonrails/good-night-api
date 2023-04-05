class AddTimeToClockIns < ActiveRecord::Migration[7.0]
  def change
    add_column :clock_ins, :time, :datetime
  end
end
