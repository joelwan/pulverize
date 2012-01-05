require 'config.rb'

def recurse(dir)
  return if dir.empty?
  
  pattern = /(\<\!\-\-pvl.*?type[ ]*=[ ]*[\'\"]([^\"]*)[\'\"].*?id[ ]*=[ ]*[\'\"]([^\"]*)[\'\"].*?\<\!\-\-\/pvl\-\-\>)/im
  
  Dir.foreach(dir) do |file|
    dirpath = dir + '/' + file
    if File.directory?(dirpath) then
      next if file == '.' or file == '..'
      recurse(dirpath)
    else
      ext = File.extname(file)
      if $config['extensions'].include?(ext)
        lines = []
        File.open(dirpath, 'r') { |f| 
          lines = f.read 
          matches = lines.scan(pattern)
          matches.each do |match|
            type = match[1]
            id = match[2]
            set = $config[type][id]
            unless set.nil?
              puts lines.gsub(match[0], "***")
            end
          end
        }
      end
    end
  end
end

recurse('test')