require 'config.rb'

def recurse(dir)
  return if dir.empty?
  
  #pattern = /\<\!\-\-pulverize(.)?*\<\!\-\-\/pulverize\-\-\>/
  
  Dir.foreach(dir) do |file|
    dirpath = dir + '/' + file
    if File.directory?(dirpath) then
      next if file == '.' or file == '..'
      recurse(dirpath)
    else
      ext = File.extname(file)
      if $config['extensions'].include?(ext)
        puts dirpath
        File.open(dirpath, 'r') {|f| lines = f.readlines ; puts lines}
        #lines = lines.inject([]){|l, line| 1<<line.gsub(s,r)}
        #File.open(file, 'w') {|f| f.write(lines) }
      end
    end
  end
end

recurse('test')