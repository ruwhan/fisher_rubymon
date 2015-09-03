class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :power
      t.string :element_type
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :monsters, :user_id
  end
end
