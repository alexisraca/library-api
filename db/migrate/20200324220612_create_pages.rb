class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.integer :page_number, null: false
      t.references :book
      t.timestamps
    end

    add_index :pages, [:page_number, :book_id], unique: true
  end
end
