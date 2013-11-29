module Archivable
  extend ActiveSupport::Concern
  
  included do
    scope :unarchived, -> { where(deleted_at: nil) }
    scope :archived,   -> { unscoped.where('deleted_at IS NOT NULL') }
    default_scope      -> { unarchived }
  end
  
  def archive(time = Time.now)
    transaction do
      update_column :deleted_at, time
      
      on_associated_record(scope: :unarchived) do |record|
        record.archive(time) if record.respond_to? :archive
      end
    end
  end
  
  def unarchive(time = nil)
    time ||= deleted_at
    
    transaction do
      update_column :deleted_at, nil
      
      on_associated_record(scope: :archived) do |record|
        record.unarchive(time) if record.respond_to?(:unarchive) &&
                                  record.deleted_at == time
      end
    end
  end
  
  private
  
  def on_associated_record(options = {}, &block)
    associations = self.class.reflect_on_all_associations
    associations.each do |association|
      if association.macro == :has_many
        collection = send(association.plural_name)
        
        if scope = options[:scope]
          next unless collection.respond_to?(scope)
          collection = collection.send(scope)
        end
        
        collection.find_each do |record|
          yield record
        end
      end
    end
  end
end
