class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :feedback, index: true
      t.belongs_to :track,    index: true
      t.integer    :value
      t.timestamps
    end
  end
end
