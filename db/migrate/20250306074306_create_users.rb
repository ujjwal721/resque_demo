class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :name
      t.string :email
      t.boolean :is_gold_member
      t.integer :discount_percentage

      t.timestamps
    end
    add_index :users, :user_id, unique: true
  end
end
