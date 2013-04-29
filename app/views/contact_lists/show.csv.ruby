require 'csv'

column_names = %w(id email name)

CSV.generate do |csv|
  csv << column_names
  @contacts.find_each do |contact|
    csv << contact.attributes.values_at(*column_names)
  end
end