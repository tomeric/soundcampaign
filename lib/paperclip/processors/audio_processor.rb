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
      
      case @format
      when 'mp3'
        program = 'lame'
        parameters = [@params, ':source', ':dest'].flatten.compact
      when 'wav'
        program = 'ffmpeg'
        parameters = [@params, '-y', '-i :source', '-f wav :dest'].flatten.compact
      end
      
      parameters = parameters.join(' ').strip.squeeze(' ')
      
      begin
        Paperclip.run(
          program,
          parameters,
          source: File.expand_path(source.path),
          dest:   File.expand_path(destination.path)
        )
      rescue PaperclipCommandLineError => e
        raise Paperclip::Error, "There was an error converting #{@basename} to #{@format} (ran: '#{program} #{parameters}') - #{e}"
      end
      
      destination
    end
    
  end
end