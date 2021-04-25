class CreateAchievements < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements do |t|
      t.string :name
      t.string :description
      t.belongs_to :user, foreign_key: true
      t.string :user_role, default: 'questioner'
      t.belongs_to :question, foreign_key: true, unique: true
      t.timestamps
    end
  end
end
