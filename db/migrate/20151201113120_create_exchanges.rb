class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :giftee
      t.integer :gifter
      t.integer :event_id

      t.timestamps null: false
    end
  end
end
