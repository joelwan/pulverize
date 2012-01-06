require 'config.rb'
require 'manifest.rb'

def pulverize(dir)
  return if dir.empty?
  
  pattern = /(\<\!\-\-pvl.*?type[ ]*=[ ]*[\'\"]([^\"\']*)[\'\"].*?id[ ]*=[ ]*[\'\"]([^\"\']*)[\'\"].*?\<\!\-\-\/pvl\-\-\>)/im
  
  Dir.foreach(dir) do |file|
    dirpath = dir + '/' + file
    if File.directory?(dirpath) then
      next if file == '.' or file == '..'
      pulverize(dirpath)
    else
      ext = File.extname(file)
      if $config['extensions'].include?(ext)
        lines = ""
        File.open(dirpath, 'r') { |f| 
          lines = f.read 
          matches = lines.scan(pattern)
          matches.each do |match|
            type = match[1]
            id = match[2]
            set = $config[type][id]
            unless set.nil?
              tmp = concat(dir, set, type, id)
              pulverized = min(tmp)              
              lines = lines.gsub(match[0], buildRef(pulverized, type, id))
            end
          end
        }
        File.open(dirpath, 'w') do |output|
          output.puts lines
        end
        saveManifest()
      end
    end
  end
end

def concat(dir, files, type, id)
  tmp = dir+'/'+$config[type+'Path']+'/'+id+'.'+type
  File.open(tmp, 'w') do |output|
    files.each do |file|
      content = File.readlines(dir+'/'+file)
      output.puts content
    end
  end
  return tmp
end

def min(file)
  newfile = file.gsub(/\.([a-zA-Z])*$/, ".min-v"+$nextVersion+"\\0")
  #minify using yuicompressor
  pulverized = %x[java -jar tools/yuicompressor-2.4.5.jar #{file} -o #{newfile}]
  return newfile
end



def buildRef(path, type, id)
  open = "<!--pvl type='"+type+"' id='"+id+"' -->"
  close = "<!--/pvl-->"
  if type == 'js'
    return open+'<script src="'+path.gsub($root, '')+'" type="text/javascript"></script>'+close
  elsif type == 'css'
    return open+'<link rel="stylesheet" href="'+path.gsub($root, '')+'" type="text/css" />'+close
  end
end

def saveManifest
  #increment version and save
  nextVersion = (Integer($nextVersion.gsub('.', '')) + 1).to_s().insert(2, '.').insert(1, '.')
  
  File.open('manifest.rb', 'w') do |manifest|
    manifest.puts '$nextVersion = "'+nextVersion+'"'
  end
end

if ARGV.empty?
  puts 'Missing argument. Usage: pulverize.rb [directory]'
else
  $root = ARGV[0]
  pulverize($root)
end