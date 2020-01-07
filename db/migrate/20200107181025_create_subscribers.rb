class CreateSubscribers < ActiveRecord::Migration[6.0]
  def change
    create_table :subscribers do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      t.timestamps
    end
    add_index(:subscribers, %i[user_id question_id], unique: true)
  end
end
