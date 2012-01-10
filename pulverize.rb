require 'config.rb'
require 'manifest.rb'

def pulverize(dir, undo)
  return if dir.empty?
  
  pattern = /(\<\!\-\-pvl.*?type[ ]*=[ ]*[\'\"]([^\"\']*)[\'\"].*?id[ ]*=[ ]*[\'\"]([^\"\']*)[\'\"].*?\<\!\-\-\/pvl\-\-\>)/im
  
  Dir.foreach(dir) do |file|
    dirpath = dir + '/' + file
    if File.directory?(dirpath) then
      next if file == '.' or file == '..'
      pulverize(dirpath, undo)
    else
      ext = File.extname(file)
      if $config['pulverize']['extensions'].include?(ext)
        lines = ""
        matches = []
        File.open(dirpath, 'r') do |f| 
          lines = f.read 
          matches = lines.scan(pattern)
          matches.each do |match|
            type = match[1]
            id = match[2]
            set = $config['pulverize'][type][id]
            unless set.nil?
              tmp = concat(dir, set, type, id)
              cleanRef(tmp)
              if undo > 0
                delete = %x[rm -f #{tmp}]
                lines = lines.gsub(match[0], inflate(set, type, id))
              else
                pulverized = min(tmp)
                lines = lines.gsub(match[0], deflate(pulverized, type, id))
              end
            end
          end
        end
        if matches.count > 0 do
          File.open(dirpath, 'w') do |output|
            output.puts lines
          end
        end
        saveManifest()
      end
    end
  end
end

def concat(dir, files, type, id)
  tmp = dir+'/'+$config['pulverize'][type+'Path']+'/'+id+'.'+type
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
  pulverized = %x[java -jar tools/yuicompressor-2.4.5.jar #{$config['pulverize']['yui_options']} #{file} -o #{newfile}]
  delete = %x[rm -f #{file}]
  return newfile
end

def cleanRef(tmp)
  oldfiles = tmp.gsub(/\.([a-zA-Z])*$/, ".min-v*\\0")
  delete = %x[rm -f #{oldfiles}]
end

def deflate(path, type, id)
  open = "<!--pvl type='"+type+"' id='"+id+"' -->"
  close = "<!--/pvl-->"
  if type == 'js'
    return open+'<script src="'+path.gsub($root, '')+'" type="text/javascript"></script>'+close
  elsif type == 'css'
    return open+'<link rel="stylesheet" href="'+path.gsub($root, '')+'" type="text/css" />'+close
  end
end

def inflate(files, type, id)
  open = "<!--pvl type='"+type+"' id='"+id+"' -->"
  close = "<!--/pvl-->"
  string = open
  if type == 'js'
    files.each do |file|
      string += '<script src="'+file+'" type="text/javascript"></script>'
    end
  elsif type == 'css'
    files.each do |file|
      string += '<link rel="stylesheet" href="'+file+'" type="text/css" />'
    end
  end
  string += close
  return string
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
  pulverize($root, 0)
end