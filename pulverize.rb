require 'config.rb'

def recurse(dir)
  return if dir.empty?
  
  pattern = /(\<\!\-\-pulverize.*?\<\!\-\-\/pulverize\-\-\>)/im
  
  Dir.foreach(dir) do |file|
    dirpath = dir + '/' + file
    if File.directory?(dirpath) then
      next if file == '.' or file == '..'
      recurse(dirpath)
    else
      ext = File.extname(file)
      if $config['extensions'].include?(ext)
        #puts dirpath
        lines = []
        File.open(dirpath, 'r') { |f| 
          lines = f.read 
          #puts lines
          
          matches = lines.gsub(pattern, "***")
          #puts matches

        }
      end
    end
  end
end

recurse('test')