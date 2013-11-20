class TrackEvent < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  belongs_to :track
  
  belongs_to :recipient
  
  ### CLASS METHODS:
  
  def self.number_of(type, per: 1.day)
    unit  = per.to_i
    event = case type
            when :plays
              'play-track'
            end
    
    number_of_occurences event, unit
  end
  
  
  private
  
  def self.number_of_occurences(event, unit)
    rows = connection.select_all(stats_query(event, unit))
    
    counts = Hash[
      *rows.map do |row|
        [row['reverse_index'].to_i, row['count'].to_i]
      end.flatten
    ]
    
    # Fill in empty days:
    if counts.present?
      first_date = counts.keys.max
      last_date  = counts.keys.min
      
      (first_date .. last_date).each do |days_ago|
        counts[days_ago] ||= 0
      end
    end
    
    Hash[
      counts.map do |age, occurences|
        [age.days.ago.to_date, occurences]
      end
    ]
  end
  
  def self.stats_query(action, unit)
    query = connection.unprepared_statement do
      where("action = ?", action)
      .select("FLOOR((EXTRACT(EPOCH FROM localtimestamp) - EXTRACT(EPOCH FROM track_events.created_at)) / #{unit}) AS reverse_index, COUNT(*) AS count")
      .group("reverse_index")
      .order("reverse_index DESC")
      .to_sql
    end
  end
  
end
