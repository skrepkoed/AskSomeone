class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.integer :rating, default: 0
      t.references :ratingable, polymorphic: true, index:{unique: true}

      t.timestamps
    end
  end
end
