class CreateImportRows < ActiveRecord::Migration
  def change
    create_table :import_rows do |t|
      t.belongs_to :import, index: true
      t.integer :position,  null: false, default: 0
      t.boolean :header,    null: false, default: false
      t.string  :columns,   null: false, default: '{}', array: true
      t.timestamps
    end
    
    add_index :import_rows, [:import_id, :position], unique: true
  end
end
