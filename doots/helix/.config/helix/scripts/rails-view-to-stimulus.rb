#!/usr/bin/env ruby
# frozen_string_literal: true

# Jump from a `data-controller="..."` attribute (on the cursor line) to its
# Stimulus controller file. Stimulus's `--` separates namespace directories,
# e.g. `ui--sensitive-input` -> app/javascript/controllers/ui/sensitive_input_controller.js.
# Best-effort: if the attribute doesn't match its file's actual path, this
# just won't find it -- no fallback search.
caller_path = ARGV[0]
cursor_line = ARGV[1].to_i

lines = File.readlines(caller_path)
line = lines[cursor_line - 1] || ""

match = line.match(/data-controller=["']([^"']+)["']/)
unless match
  puts caller_path
  exit
end

identifier = match[1].split.first
path = identifier.split("--").join("/").tr("-", "_")
target = "app/javascript/controllers/#{path}_controller.js"

puts File.exist?(target) ? target : caller_path
