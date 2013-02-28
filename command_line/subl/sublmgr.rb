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
    project_file = getFilePath(project_name || path_info[-1])
    path["path"] = '/' << path_info.delete_if {|e| e == "" }.join('/')
    Dir.mkdir(SUBLHOME) unless File.exists? SUBLHOME
    if File.exists? project_file
      throw SublException.new("#{project_name} exists already!,you can change the other name")
    else
      File.open(project_file,"w") do |file|
        file << project.to_json
      end
    end
  end

  def self.delete(project_name)
    project_file = getFilePath(project_name)
    workspace_file = getFilePath(project_name,".sublime-workspace")
    if File.exists? project_file
      File.delete(project_file)
      File.delete(workspace_file) if File.exists? workspace_file
    else
      throw SublException.new("named '#{project_name}' project not exists!")
    end
  end

  def self.list(*)
    Dir.chdir(SUBLHOME)
    Dir.glob("*.sublime-project").each do |project|
      puts project.split(".")[0...-1].join(".")
    end
  end

  def self.open(project_name)
    project_file = getFilePath(project_name)
    unless File.exists? project_file
      throw SublException.new("named #{project_name} project not exists!")
    end
    cmd = "@start /b #{SUBLEXC} #{project_file}"
    system(cmd)
  end

  private
  def getFilePath(file_name,ext = ".sublime-project")
    return SublProject::SUBLHOME + file_name + ext
  end
  module_function :getFilePath
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

begin
  options.each do |action , argv|
    SublProject.send action.to_sym,*argv
  end
rescue SublProject => e
  puts e.message
end