class CreateContentFormats < ActiveRecord::Migration[6.0]
  def change
    create_table :content_formats do |t|
      t.string :name
      t.string :sufixes, array: true, default: []
      t.boolean :file, default: false
      t.timestamps
    end

    add_reference :contents, :content_format, index: true
  end
end
