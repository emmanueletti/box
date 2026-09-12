#!/usr/bin/env ruby
# frozen_string_literal: true

# Jump from a `render "x"` / `render partial: "x"` call on the cursor line
# to the partial file it references. One-way: partials have many callers,
# there's no sane reverse direction.
caller_path = ARGV[0]
cursor_line = ARGV[1].to_i

line = File.readlines(caller_path)[cursor_line - 1] || ""
match = line.match(/render\s*\(?\s*(?:partial:\s*)?['"]([^'"]+)['"]/)

unless match
  puts caller_path
  exit
end

ref = match[1]

if ref.include?("/")
  dir = "app/views/#{File.dirname(ref)}"
  name = File.basename(ref)
else
  name = ref
  dir = caller_path.start_with?("app/views/") ? File.dirname(caller_path) : "app/views"
end

target = Dir.glob("#{dir}/_#{name}.*").first

unless target
  ext = "html.erb"
  if caller_path.start_with?("app/views/")
    ext = File.basename(caller_path).sub(/\A[^.]+\./, "")
  end
  target = "#{dir}/_#{name}.#{ext}"
end

puts target
