class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :species
      t.string :gender
      t.string :weapon
      t.string :vehicle
      t.integer :location_id
      t.integer :affiliation_id

      t.timestamps
    end
  end
end
