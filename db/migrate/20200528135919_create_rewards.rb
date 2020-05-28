class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
