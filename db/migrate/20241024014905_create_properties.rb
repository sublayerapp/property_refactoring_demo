class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.string :name
      t.text :description
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
