class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.attachment :spreadsheet
      t.belongs_to :context, polymorphic: true
      t.timestamps
    end
  end
end
