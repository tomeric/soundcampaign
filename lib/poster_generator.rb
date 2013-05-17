class PosterGenerator
  
  attr_reader :source, :width, :height, :blur_radius, :side_gradient_width, :average_color, :noise_level
  
  def initialize(file, width: 1600, height: 250, blur_radius: 70, side_gradient_width: 180, noise_level: 0.3)
    @source              = file
    @width               = width
    @height              = height
    @blur_radius         = blur_radius
    @noise_level         = noise_level
    @side_gradient_width = side_gradient_width
  end
  
  def create(result = nil)
    result ||= Tempfile.new([basename, '.jpg']).tap(&:binmode)
    
    destination = result.path
    origin      = source.path
    
    puts [destination, origin].inspect
    
    # Resize and crop:
    Paperclip.run 'convert', "#{origin} -resize '#{width}x<' -gravity center -crop #{width}x#{height}+0+0 #{destination}"
    
    unless average_color
      # Extract the average color:
      output = Paperclip.run 'convert',
        "#{destination} -scale 1x1\\! -format '%[fx:int(255*r+.5)],%[fx:int(255*g+.5)],%[fx:int(255*b+.5)]' info:-"
      
      @average_color = output.gsub(/[^0-9,]/, '')
    end
    
    if blur_radius && blur_radius > 0
      # Blur the poster:
      Paperclip.run 'convert', "#{destination} -blur 0x#{blur_radius} -quality 85% #{destination}"
    end
    
    if side_gradient_width && side_gradient_width > 0
      # Add gradients to the sides:
      gradient = Tempfile.new(["#{basename}_gradient", '.png']).tap(&:binmode)
      gradient_path = File.expand_path(gradient.path)
      
      Paperclip.run 'convert', "-size #{height}x#{side_gradient_width} gradient:none-\"rgb(#{average_color})\" -rotate 90 #{gradient_path}"
      Paperclip.run 'convert', "#{destination} #{gradient_path} -gravity NorthWest -composite #{destination}"
      
      Paperclip.run 'convert', "#{gradient_path} -rotate 180 #{gradient_path}"
      Paperclip.run 'convert', "#{destination} #{gradient_path} -gravity NorthEast -composite #{destination}"
    end
    
    # Add noise:
    Paperclip.run 'convert', "#{destination} -evaluate Laplacian-noise #{noise_level} #{destination}"
    
    result
  end
  
  private
  
  def current_format
    File.extname(source.path)
  end
  
  def basename
    File.basename(source.path, current_format)
  end
  
end
