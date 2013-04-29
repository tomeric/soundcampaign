require 'spec_helper'

describe Import::Row do
  subject(:row) { build :import_row }
  
  it { should be_valid }
end
