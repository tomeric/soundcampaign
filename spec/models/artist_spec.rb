require 'spec_helper'
require_relative './concerns/archivable'

describe Artist do
  subject(:artist) { build :artist }
  
  it { should be_valid }
  
  it_behaves_like Archivable
end
