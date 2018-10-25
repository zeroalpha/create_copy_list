require 'awesome_print'
require 'tty-spinner'

unless ARGV.size == 2
  puts "Usage: ruby file_diff.rb <target_dir> <source_dir>"
  exit 1
end

target_dir = ARGV[0].gsub('\\','/')
target_dir = (target_dir[-1] == '/') ? target_dir : target_dir + '/'
source_dir = ARGV[1].gsub('\\','/')
source_dir = (source_dir[-1] == '/') ? source_dir : source_dir + '/'

spinner = TTY::Spinner.new("[:spinner] Reading Target Files (#{target_dir}) ... ", format: :classic, success_mark: '+')
spinner.auto_spin
t = Time.now
existing_files = Hash.new([])
Dir.glob(target_dir + '**/*').map{|f| [File.basename(f), f]}.each do |name,path|
  existing_files[name] << path
end
spinner.success("Done! Found #{existing_files.size} Files in #{Time.now - t}s")


spinner = TTY::Spinner.new("[:spinner] Reading Source Files (#{source_dir}) ... ", format: :classic, success_mark: '+')
spinner.auto_spin
t = Time.now
new_files = Hash.new([])
Dir.glob(source_dir + '**/*').map{|f| [File.basename(f), f]}.each do |name, path|
  new_files[name] << path
end
spinner.success("Done! Found #{new_files.size} Files in #{Time.now - t}s")

to_copy = new_files.keys.map do |k|
  existing_files.keys.include?(k) ? nil : k
end
to_copy.delete(nil)

ap to_copy