class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users do |t|
      t.integer :user_id
      t.integer :event_id
      t.boolean :admin
      t.boolean :participation

      t.timestamps null: false
    end
  end
end
