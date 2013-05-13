require 'timecop'

RSpec.configure do |config|
  config.before do
    # Make sure we're always in the present
    Timecop.return
  end
end
