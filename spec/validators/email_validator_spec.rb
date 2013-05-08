require 'spec_helper'

describe EmailValidator do
  class EmailValidatable
    include ActiveModel::Validations
    attr_accessor :email
    validates :email, email: true
  end
  
  subject { EmailValidatable.new }
  
  context 'with a valid e-mail' do
    before { subject.email = 'info@soundcampaign.com' }
    it { should be_valid }
  end
  
  context 'with an invalid e-mail' do
    before { subject.email = 'invalid email' }
    it { should_not be_valid }
  end
end