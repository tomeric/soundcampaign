class CreateReleaseEvents < ActiveRecord::Migration
  def change
    create_table :release_events do |t|
      t.belongs_to :release, index: true
      t.belongs_to :recipient, index: true
      t.string :type
      t.belongs_to :parent, index: true

      t.timestamps
    end
  end
end
