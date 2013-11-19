class ChangeFeedbackSubscriberAssociationToRecipient < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :subscriber_id, :recipient_id
    
    # Remove past mistakes (should not exist):
    Feedback.where('recipient_id IS NOT NULL AND user_id IS NULL')
            .delete_all
  end
end
