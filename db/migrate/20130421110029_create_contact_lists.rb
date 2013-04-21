class CreateContactLists < ActiveRecord::Migration
  def change
    create_table :contact_lists do |t|
      t.belongs_to :organization, index: true
      t.string :name

      t.timestamps
    end
  end
end
