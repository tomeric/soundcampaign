require 'paperclip'

module Paperclip
  class Audio < Processor
    
    attr_accessor :file, :params, :format
    
    def initialize(file, options = {}, attachment = nil)
      super
      @file           = file
      @params         = options[:params]
      @current_format = File.extname  @file.path
      @basename       = File.basename @file.path, @current_format
      @format         = options[:format]
    end
    
    def make
      source      = @file
      destination = Tempfile.new([@basename, @format ? ".#{@format}" : ''])
      
      begin
        parameters = [@params, ':source', ':dest'].flatten.compact
        parameters = parameters.join(' ').strip.squeeze(' ')
        
        Paperclip.run 'lame', parameters,
                      source: File.expand_path(source.path),
                      dest:   File.expand_path(destination.path)
      
      rescue PaperclipCommandLineError => e
        raise PaperclipError, "There was an error converting #{@basename} to mp3 - #{e}"
      end
      
      destination
    end
    
  end
end