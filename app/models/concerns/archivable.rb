module Archivable
  extend ActiveSupport::Concern
  
  included do
    scope :unarchived, -> { where(deleted_at: nil) }
    scope :archived,   -> { unscoped.where('deleted_at IS NOT NULL') }
    default_scope      -> { unarchived }
  end
  
  def archive
    update_column :deleted_at, Time.now
  end
end
