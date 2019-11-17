class CreateTrophies < ActiveRecord::Migration[6.0]
  def change
    create_table :trophies do |t|
      t.string :name, null: false
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
