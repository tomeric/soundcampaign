class AddPreviousSiblingToReleaseEvents < ActiveRecord::Migration
  def change
    add_reference :release_events, :first_sibling,                     index: true
    add_column    :release_events, :upcoming_siblings_count, :integer, default: 0
  end
end
