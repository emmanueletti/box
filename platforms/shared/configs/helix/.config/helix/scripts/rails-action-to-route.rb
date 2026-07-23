#!/usr/bin/env ruby
# frozen_string_literal: true

# Show the route (verb + path) for the controller action enclosing the
# cursor. Unlike the other scripts this doesn't navigate anywhere -- routes.rb
# is a DSL, not data, so there's no reliable way to find "the line that
# declared this route" without actually evaluating it. Meant to be bound to
# `:echo`, not `:open`.
require "open3"

caller_path = ARGV[0]
cursor_line = ARGV[1].to_i

unless caller_path.start_with?("app/controllers/") && caller_path.end_with?("_controller.rb")
  puts "Not a controller file"
  exit
end

lines = File.readlines(caller_path)
action = nil
(cursor_line - 1).downto(0) do |i|
  if lines[i] =~ /^\s*def\s+(\w+)/
    action = Regexp.last_match(1)
    break
  end
end

unless action
  puts "No enclosing action found at #{caller_path}:#{cursor_line}"
  exit
end

controller_path = caller_path.sub("app/controllers/", "").sub("_controller.rb", "")

out, _status = Open3.capture2("bin/rails", "routes", "-c", controller_path)
row = out.lines.find { |l| l.include?("#{controller_path}##{action}") }

if row && (m = row.match(/(GET|POST|PATCH|PUT|DELETE)\s+(\S+)/))
  puts "#{m[1]} #{m[2]}"
else
  puts "No route found for #{controller_path}##{action}"
end
