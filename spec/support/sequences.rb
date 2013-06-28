require 'ffaker'
require 'factory_girl_rails'

FactoryGirl.define do
  sequence :name do |n|
    @names ||= []
    
    # "O'Reilly" will be escaped in ERB and causes specs to break:
    name = Faker::Name.name.gsub("'", '-')
    name += " the #{n.ordinalize}" if @names.include? name
    
    (@names << name).last
  end
  
  sequence :email do |n|
    @emails ||= []
    
    email = [Faker::Internet.user_name, Faker::Internet.domain_name].join '@'
    email.gsub!('@', ".#{n}@") if @emails.include? email
    
    (@emails << email).last
  end
  
  sequence :brand do |n|
    @brands ||= []
    
    brand =  Faker::Company.name
    brand += " no. #{n}" if @brands.include? brand
    
    (@brands << brand).last
  end
  
  sequence :title do |n|
    @titles ||= []
    
    title = Faker::Lorem.sentence.gsub!(/\.$/ , '')
    title.append(" part #{n}") if @titles.include? title
    
    (@titles << title).last
  end
  
  sequence :story do |n|
    Faker::Lorem.paragraphs(3).join("\n\n")
  end
end
