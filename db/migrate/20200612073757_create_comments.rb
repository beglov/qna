class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.references :user
      t.text :body

      t.timestamps
    end
  end
end
