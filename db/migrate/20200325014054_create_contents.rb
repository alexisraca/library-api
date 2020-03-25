class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.text :body
      t.string :file
      t.references :page
      t.timestamps
    end
  end
end
