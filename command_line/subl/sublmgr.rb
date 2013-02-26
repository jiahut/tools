require 'json'

class SublException < Exception;end

module SublProject
  
  SUBLHOME = Dir.home() << '/.subl/'
  SUBLEXC = 'D:/apps/Sublime_Text_2.0.1/sublime_text.exe'

  def self.create(project_path,project_name = nil)
    project = Hash.new
    path = Hash.new
    folders = project["folders"] = Array.new
    folders << path
    path_info =  project_path.split(/\\|:|\//)
    file_name = project_name || path_info[-1]
    file_name += ".sublime-project"
    file_name = SUBLHOME + file_name
    path["path"] = '/' << path_info.delete_if {|e| e == "" }.join('/')
    Dir.mkdir(SUBLHOME) unless File.exists? SUBLHOME
    if File.exists? file_name
      throw SublException.new("#{file_name} exists already!,you must change project_name = #{project_name}")
    else
      File.open(file_name,"w") do |file|
        file << project.to_json
      end
    end
  end

  def self.delete(project_name)
    file_name = project_name
    file_name += ".sublime-project"
    file_name = SUBLHOME + file_name
    if File.exists? file_name
      File.delete(file_name)
    else
      throw SublException.new("named '#{project_name}' project not exists!")
    end
  end

  def self.list(*)
    Dir.chdir(SUBLHOME)
    Dir.glob("*").each do |project|
      puts project
    end
  end

  def self.open(project_name)
    file_name = project_name
    file_name += ".sublime-project"
    file_name = SUBLHOME + file_name
    unless File.exists? file_name
      throw SublException.new("#{project_name} project not exists!")
    end
    cmd = "@start /b #{SUBLEXC} #{file_name}"
    system(cmd)
  end
end

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: subl [options]" 
  opts.separator ""
  opts.separator "Specific options:"

  opts.on("--create project_path,project_name", Array, "create a sublime project") do |project_info|
    options[:create] = project_info
  end

  opts.on("--delete [project_name]", "delete a sublime project") do |project_info|
    options[:delete] = project_info
  end

  opts.on("--list", "list all sublime project") do |project_info|
    options[:list] = project_info
  end

  opts.on("--open [project_name]","open a sublime projec") do |project_info|
    options[:open] = project_info
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

options.each do |action , argv|
  SublProject.send action.to_sym,*argv
end