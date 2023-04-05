class AddTimeToClockOuts < ActiveRecord::Migration[7.0]
  def change
    add_column :clock_outs, :time, :datetime
  end
end
