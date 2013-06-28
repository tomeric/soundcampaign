class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.belongs_to :release,    index: true
      t.belongs_to :user,       index: true
      t.belongs_to :subscriber, index: true
      t.text       :body
      t.timestamps
    end
  end
end
