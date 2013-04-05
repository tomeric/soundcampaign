class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.text   :description
      t.string :catid
      t.string :style
      t.string :contact_name
      t.string :contact_email
      t.string :contact_street
      t.string :contact_phone
      t.string :contact_zipcode_city
      t.string :contact_url
    end
    
    add_attachment :labels, :cover
    
    add_column :labels, :created_at, :datetime
    add_column :labels, :updated_at, :datetime
  end
end
