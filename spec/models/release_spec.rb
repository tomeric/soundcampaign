require 'spec_helper'
require_relative './concerns/archivable'

describe Release do
  subject(:release) { build :release }
  
  it { should be_valid }
  
  it_behaves_like Archivable
end
