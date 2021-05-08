class CreateAuthorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.references :user, null: false, foreign_key: true
      t.string :uid

      t.timestamps
    end
    add_index :authorizations, [:provider,:uid]
  end
end
