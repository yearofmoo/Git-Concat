#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'

file = './.gitconcat'
replacements = {}

def open_yaml_file(file)
  begin
    file = YAML.load_file(file)
  rescue; end
  file
end

def find_files(search)
  files = []
  begin
    results = `find #{search}`
    files = results.split("\n").map(&:strip)
  rescue; end
  files
end

doc = open_yaml_file(file)
if doc.nil?
  file += '.yml'
  doc = open_yaml_file(file)
  if doc.nil?
    puts "Git-Concat: Concat file has not been set yet..."
    exit
  end
end

config = doc['config']
if config
  stamp = config['stamp']
  if stamp == 'random'
    stamp = rand(10000).to_i
  else
    stamp = stamp.to_i
  end
end

stamp = Time.now.to_i.to_s if stamp.nil? || stamp == 0
replacements ||= {}
replacements['STAMP'] = stamp 

doc.each do |key,values|

  input = Array(values['input'])
  output = Array(values['output'])

  if output.length == 0 || input.length == 0
    puts "Git-Concat: :#{key} skipped"
    next
  end

  files = []
  input.each do |i|
    files |= find_files(i)
  end

  if files.length == 0
    puts "Git-Concat: :#{key} skipped"
    next
  end

  combined = `cat #{files.join(" ")}`
  output.each do |file|
    replacements.each do |key,value|
      file.gsub!("%{#{key}}", value)
    end
    File.open(file, 'w') {|f| f.write(combined) }
    puts "Git-Concat: #{file} - Written"
    `git add #{file}`
    puts "Git-Concat: #{file} - Added to repo"
  end

end
