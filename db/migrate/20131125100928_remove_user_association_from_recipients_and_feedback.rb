class RemoveUserAssociationFromRecipientsAndFeedback < ActiveRecord::Migration
  def change
    remove_column :recipients, :user_id
    remove_column :feedbacks,  :user_id
  end
end
