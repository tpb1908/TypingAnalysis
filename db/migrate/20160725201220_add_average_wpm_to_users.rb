class AddAverageWpmToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :average_wpm, :integer
  end
end
