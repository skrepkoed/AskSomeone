class AddUniqueIndexToVotes < ActiveRecord::Migration[6.0]
  def change
    add_index :votes, [:rating_id, :user_id], unique:true
  end
end
