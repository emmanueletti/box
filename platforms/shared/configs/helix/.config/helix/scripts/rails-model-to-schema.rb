#!/usr/bin/env ruby
# frozen_string_literal: true

# Jump from a model file to its create_table block in db/schema.rb.
# Uses an explicit `self.table_name = "..."` override if present, otherwise
# guesses via standard Rails pluralization of the model's own basename
# (namespace directories are ignored, matching Rails' default un-prefixed
# table naming for a plain module namespace).
require "active_support/inflector"

caller_path = ARGV[0]

unless caller_path.start_with?("app/models/") && caller_path.end_with?(".rb")
  puts caller_path
  exit
end

content = File.read(caller_path)
table_name =
  if (m = content.match(/self\.table_name\s*=\s*["']([^"']+)["']/))
    m[1]
  else
    File.basename(caller_path, ".rb").pluralize
  end

schema_path = "db/schema.rb"
lines = File.readlines(schema_path) rescue []
line_no = lines.find_index { |l| l =~ /create_table\s+["']#{Regexp.escape(table_name)}["']/ }

if line_no
  puts "#{schema_path}:#{line_no + 1}"
else
  puts caller_path
end
