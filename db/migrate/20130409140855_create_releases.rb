class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.belongs_to :label,       null: false, index: true
      t.belongs_to :owner,       null: false, index: true
      t.string     :title,       null: false
      t.string     :catid
      t.string     :style
      t.date       :date
      t.text       :description
    end
    
    add_attachment :releases, :cover
    
    add_column :releases, :created_at, :datetime
    add_column :releases, :updated_at, :datetime
  end
end
