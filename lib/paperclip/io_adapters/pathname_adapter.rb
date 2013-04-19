module Paperclip
  class PathnameAdapter < FileAdapter
    def initialize(target)
      @target = target
      cache_current_values
    end
    
    private
    
    def cache_current_values
      File.open @target, 'r' do |file|
        @target = file
        super
      end
    end
  end
end

Paperclip.io_adapters.register Paperclip::PathnameAdapter do |target|
  Pathname === target
end