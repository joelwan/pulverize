require 'config.rb'
require 'manifest.rb'
require 'pulverize.rb'

def unpulverize(dir)
  pulverize(dir, 1)
end

if ARGV.empty?
  puts 'Missing argument. Usage: unpulverize.rb [directory]'
else
  $root = ARGV[0]
  unpulverize($root)
end