require 'spec_helper'

describe ContactList do
  subject(:list) { build :contact_list }
  
  it { should be_valid }
end
