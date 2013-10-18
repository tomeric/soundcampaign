class EmailLog < ActiveRecord::Base
  
  ### ASSOCIATIONS:
  
  has_many :mandrill_events
  
  belongs_to :recipient,
    polymorphic: true
  
  belongs_to :campaign
  
  ### CALLBACKS:
  
  before_save :connect_to_campaign
  
  ### CLASS METHODS:
  
  def self.delivered_email(message)
    find_or_initialize_by(message_id: message.message_id).tap do |mail|
      mail.subject = message.subject
      mail.to      = Array.wrap(message.to)
      mail.from    = Array.wrap(message.from).first
      mail.body    = message.body.to_s
    end.save
  end
  
  def self.number_of_opens_per_day
    query = connection.unprepared_statement do
      where('opened_at IS NOT NULL')
      .select("FLOOR((EXTRACT(EPOCH FROM localtimestamp) - EXTRACT(EPOCH FROM opened_at)) / #{1.day.to_i}) AS reverse_index, COUNT(*) AS count")
      .group("reverse_index")
      .order("reverse_index DESC")
      .to_sql
    end
    
    rows   = connection.select_all(query)
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
      counts.map do |age, opens|
        [age.days.ago.to_date, opens]
      end
    ]
  end
  
  ### INSTANCE METHODS:
  
  def connect_to_campaign
    if match = message_id.match(/campaign:([0-9]+)\+/) 
      self.campaign = Campaign.find_by id: match[1].to_i
    end
  end
  
end
