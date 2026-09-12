#!/usr/bin/env ruby
# frozen_string_literal: true

# Run the single test enclosing the cursor line. Rails' `file:line` test
# runner silently picks the nearest test (and reports a clean "0 runs...
# 0 failures" pass) if the line isn't actually inside a test block -- this
# refuses to invoke bin/rails test at all unless the cursor genuinely sits
# inside a `test "..." do ... end`.
require "fileutils"

caller_path = ARGV[0]
cursor_line = ARGV[1].to_i

unless caller_path.start_with?("test/") && caller_path.end_with?("_test.rb")
  puts caller_path
  exit
end

lines = File.readlines(caller_path) rescue (puts(caller_path); exit)

test_start = nil
test_indent = nil
found_line = nil

lines.each_with_index do |text, idx|
  line_no = idx + 1
  if (m = text.match(/^(\s*)test\s+["']/))
    test_start = line_no
    test_indent = m[1].length
  elsif test_start && text.match(/^\s{#{test_indent}}end\s*$/)
    if (test_start..line_no).cover?(cursor_line)
      found_line = test_start
      break
    end
    test_start = nil
    test_indent = nil
  end
end

FileUtils.mkdir_p("tmp")

if found_line
  File.open("tmp/helix_test.log", "w") do |log|
    log.puts "$ bin/rails test #{caller_path}:#{found_line}"
    log.puts
    log.flush
    system("bin/rails", "test", "#{caller_path}:#{found_line}", out: log, err: log)
  end
else
  File.write("tmp/helix_test.log", "No test found at #{caller_path}:#{cursor_line}\n")
end

puts "tmp/helix_test.log"
