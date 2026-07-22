#!/usr/bin/env ruby
# frozen_string_literal: true

# Extract the selected lines into a new partial, replacing them with a
# render call. Line-based (whole selected lines, not sub-line columns) --
# matches how you'd actually select a markup block to pull out. Dedents the
# extracted lines to their own common indentation and adds the house
# strict-locals header. Name defaults to _partial.html.erb (numbered on
# collision) since there's no way to prompt for one -- rename it after.
caller_path = ARGV[0]
start_line = ARGV[1].to_i
end_line = ARGV[2].to_i

unless caller_path.start_with?("app/views/") && caller_path.end_with?(".erb")
  puts caller_path
  exit
end

lines = File.readlines(caller_path)
selected = lines[(start_line - 1)...end_line]

if selected.nil? || selected.empty?
  puts caller_path
  exit
end

indents = selected.reject { |l| l.strip.empty? }.map { |l| l[/\A */].length }
min_indent = indents.min || 0
dedented = selected.map { |l| l.sub(/\A {0,#{min_indent}}/, "") }

dir = File.dirname(caller_path)
target = nil
n = 1
loop do
  candidate = n == 1 ? "#{dir}/_partial.html.erb" : "#{dir}/_partial#{n}.html.erb"
  unless File.exist?(candidate)
    target = candidate
    break
  end
  n += 1
end

partial_name = File.basename(target, ".html.erb").sub(/\A_/, "")

File.write(target, "<%# locals: () -%>\n#{dedented.join}")

original_indent = selected.first[/\A */]
render_line = "#{original_indent}<%= render \"#{partial_name}\" %>\n"

new_content = lines[0...(start_line - 1)] + [render_line] + lines[end_line..]
File.write(caller_path, new_content.join)

puts caller_path
