class Import::RowProcessor
  attr_reader :rows, :column_settings, :row_settings
  
  def initialize(rows, column_settings: {}, row_settings: {})
    @rows            = rows
    @column_settings = column_settings
    @row_settings    = row_settings
  end
  
  def each_row(&block)
    rows.each do |row|
      process_row row, &block
    end
  end
  
  private
  
  def process_row(row, &block)
    return if header? row
    yield attributes_from row.columns
  end
  
  def header?(row)
    settings = row_settings[row.position]
    settings && settings['header']
  end
  
  def attributes_from(columns)
    Hash[
      columns.map.with_index do |value, position|
        settings = column_settings[position]
        mapping  = settings && settings['mapping']
        
        if mapping
          [mapping, value]
        end
      end.compact
    ]
  end
end
