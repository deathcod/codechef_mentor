class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :user_id1, index: true 
      t.integer :user_id2, index: true
      t.string :status

      t.timestamps
    end
  end
end
