class CreateVoteHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :vote_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.string :vote_type, null: false

      t.timestamps
    end

    add_index :vote_histories, [:user_id, :restaurant_id], unique: true

  end
end
