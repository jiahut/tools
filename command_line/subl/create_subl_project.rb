require 'json'

exit(1) if ARGV.length == 0
project = Hash.new
folders = project["folders"] = Array.new
path = Hash.new
folders << path
project_path = ARGV[0]
project_path
path_info =  project_path.split(/\\|:/)
fileName = ARGV[1] || path_info[-1]
fileName += ".sublime-project"
path["path"] = '/' << path_info.delete_if {|e| e == "" }.join('/')

File.open(fileName,"w") do |file|
	file << project.to_json
end unless File.exists? fileName
