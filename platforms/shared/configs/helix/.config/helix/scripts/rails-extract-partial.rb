#!/usr/bin/env ruby
# frozen_string_literal: true

# Extract the piped selection into a new partial, printing a render call to
# replace it (used via Helix `:pipe`, so stdin is the selection and stdout
# replaces it in the live buffer -- no disk rewrite, no reload). Select whole
# lines. Dedents the extracted lines to their own common indentation and adds
# the house strict-locals header. Names the partial after the source file:
# app/views/x/edit.html.erb -> _edit_partial.html.erb (numbered on
# collision). No prompt for a custom name; rename after if needed.
caller_path = ARGV[0].to_s
selected = STDIN.read.lines

# On any no-op, echo the selection back unchanged so :pipe leaves it as-is.
def bail(selected) = (print(selected.join); exit)

bail(selected) unless caller_path.start_with?("app/views/") && caller_path.end_with?(".erb")
bail(selected) if selected.empty?

indents = selected.reject { |l| l.strip.empty? }.map { |l| l[/\A */].length }
min_indent = indents.min || 0
dedented = selected.map { |l| l.sub(/\A {0,#{min_indent}}/, "") }

dir = File.dirname(caller_path)
base = File.basename(caller_path).sub(/\.html\.erb\z/, "").sub(/\.erb\z/, "")
target = nil
n = 1
loop do
  candidate = n == 1 ? "#{dir}/_#{base}_partial.html.erb" : "#{dir}/_#{base}_partial#{n}.html.erb"
  unless File.exist?(candidate)
    target = candidate
    break
  end
  n += 1
end

partial_name = File.basename(target, ".html.erb").sub(/\A_/, "")

File.write(target, "<%# locals: () -%>\n#{dedented.join}")

original_indent = selected.first[/\A */]
print "#{original_indent}<%= render \"#{partial_name}\" %>\n"
