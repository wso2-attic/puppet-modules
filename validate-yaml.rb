begin
  require 'yaml'

  Dir.glob('**/*.yaml') do |yaml_file|  
    YAML.load_file("#{yaml_file}")
  end

rescue => e
  puts "Error during processing: #{$!}"
end
