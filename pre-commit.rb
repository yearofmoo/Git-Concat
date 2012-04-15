#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'digest/md5'

file = './.gitconcat'

def timestamp
  Time.now.to_i.to_s
end

def open_yaml_file(file)
  begin
    f = YAML.load_file(file)
  rescue; end
  f
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
if doc.nil? || doc == {}
  file += '.yml'
  doc = open_yaml_file(file)
  if doc.nil? || doc == {}
    puts "Git-Concat: Concat file has not been set yet..."
    exit
  end
end

replacements ||= {}
config = doc.delete('config')
if config
  stamp = config.delete('stamp')
  if stamp == 'random'
    stamp = rand(10000).to_i
  else
    stamp = stamp.to_i
  end

  config.each do |key,value|
    replacements[key]=value
  end
end

stamp = timestamp() if stamp.nil? || stamp == 0
replacements['stamp'] = stamp 

doc.each do |key,values|

  input = Array(values['input'])
  output = Array(values['output'])

  filters = values.has_key?('filters') ? Array(values['filters']) : []

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

    temp = '._gitconcat_temp_file'
    File.open(temp, 'w') {|f| f.write(combined) }
    replacements['digest'] = Digest::MD5.file(temp).to_s

    i = 1
    filters.each do |filter|
      next_temp = temp + '_' + i.to_s
      filter = filter.gsub("%{INPUT}", temp)
      filter = filter.gsub("%{OUTPUT}", next_temp)
      temp = next_temp
      i += 1
    end

    replacements.each do |key,value|
      file.gsub!("%{#{key}}", value)
    end

    `cp #{temp} #{file}`
    `rm #{temp}`

    puts "Git-Concat: #{file} - Written"

    `git add #{file}`

    puts "Git-Concat: #{file} - Added to repo"
  end

end
