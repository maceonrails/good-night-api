class CreateClockOuts < ActiveRecord::Migration[7.0]
  def change
    create_table :clock_outs do |t|
      t.references :clock_in, null: false, foreign_key: true

      t.timestamps
    end
  end
end
