class AddBestToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean, default: false, null: false
    add_index :answers, :best
  end
end
