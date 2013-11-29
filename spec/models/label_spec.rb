require 'spec_helper'
require_relative './concerns/archivable'

describe Label do
  subject(:label) { build :label }
  
  it { should be_valid }
  
  it_behaves_like Archivable,
    associations: {
      releases: -> label { FactoryGirl.create :release, label: label }
    }
end
