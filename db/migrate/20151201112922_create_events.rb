class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :date
      t.string :name
      t.datetime :deadline
      t.string :location
      t.decimal :max_price
      t.decimal :min_price

      t.timestamps null: false
    end
  end
end
