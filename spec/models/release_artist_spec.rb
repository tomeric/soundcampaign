require 'spec_helper'

describe ReleaseArtist do
  subject(:release_artist) { build :release_artist }
  
  it { should be_valid }
end
