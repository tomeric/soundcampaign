require 'spec_helper'

describe TrackEvent do
  subject(:track_event) { build :track_event }
  
  it { should be_valid }
end
