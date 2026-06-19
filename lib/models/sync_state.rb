require 'active_record'

module Model
  # Stores the timestamp up to which each Cropio model was last synced.
  # Replaces the previous Redis-based checkpoint store. Not a Cropio resource,
  # so it is never part of the download list (which comes from Cropio::Resources).
  class SyncState < ActiveRecord::Base
    # Returns the last synced time for a model, or nil if never synced.
    # NB: column is `resource_name` — `model_name` is reserved by ActiveRecord.
    def self.last_synced_at(resource_name)
      find_by(resource_name: resource_name)&.synced_until
    end

    # Atomically records the last synced time for a model.
    def self.mark_synced(resource_name, synced_until)
      upsert({ resource_name: resource_name, synced_until: synced_until },
             unique_by: :resource_name)
    end
  end
end
