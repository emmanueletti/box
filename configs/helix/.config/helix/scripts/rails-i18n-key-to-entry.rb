#!/usr/bin/env ruby
# frozen_string_literal: true

# Jump from a t("key") / t(".key") call to its definition in config/locales/en.yml.
# One-way, like render-to-partial: reads the calling line off disk.
require "psych"

caller_path = ARGV[0]
cursor_line = ARGV[1].to_i
lines = File.readlines(caller_path)
current_line = lines[cursor_line - 1] || ""

match = current_line.match(/\b(?:translate|t)\(\s*['"]([^'"]+)['"]/)
unless match
  puts caller_path
  exit
end

raw_key = match[1]

if raw_key.start_with?(".")
  scope =
    if caller_path.start_with?("app/views/")
      rel = caller_path.sub("app/views/", "").sub(/\.\w+\.\w+\z/, "")
      rel = rel.sub(%r{/_}, "/") # partials: lazy lookup drops the leading underscore
      rel.tr("/", ".")
    elsif caller_path.start_with?("app/controllers/") && caller_path.end_with?("_controller.rb")
      rel = caller_path.sub("app/controllers/", "").sub("_controller.rb", "")
      action = nil
      (cursor_line - 1).downto(0) do |i|
        if lines[i] =~ /^\s*def\s+(\w+)/
          action = Regexp.last_match(1)
          break
        end
      end
      action ? "#{rel.tr('/', '.')}.#{action}" : nil
    end

  unless scope
    puts caller_path
    exit
  end

  full_key = "#{scope}#{raw_key}"
else
  full_key = raw_key
end

yaml_path = "config/locales/en.yml"
root = Psych.parse_stream(File.read(yaml_path)).children.first.children.first

node = root
("en." + full_key).split(".").each do |part|
  pair = node.children.each_slice(2).find { |k, _| k.value == part }
  if pair
    node = pair[1]
  else
    node = nil
    break
  end
end

if node
  puts "#{yaml_path}:#{node.start_line + 1}"
else
  puts yaml_path
end
