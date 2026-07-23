#!/usr/bin/env ruby
# frozen_string_literal: true

# Expands a shorthand table spec into a markdown table grid.
#
#   3x4              -> 3 columns, 4 body rows
#   3                -> 3 columns, 2 body rows
#   Name,Age,City    -> named columns, 2 body rows
#   Name,Age,City x4 -> named columns, 4 body rows
#
# Reads the spec from ARGV or stdin. Prints the table to stdout.

DEFAULT_ROWS = 2

spec = (ARGV.first || $stdin.read).to_s.strip

headers, rows =
  case spec
  when /\A(\d+)\s*[xX*]\s*(\d+)\z/
    [Array.new($1.to_i) { |i| "Column #{i + 1}" }, $2.to_i]
  when /\A(\d+)\z/
    [Array.new($1.to_i) { |i| "Column #{i + 1}" }, DEFAULT_ROWS]
  when /\A(.+?)(?:\s*[xX*]\s*(\d+))?\z/
    names = $1.split(/\s*[,|]\s*/).reject(&:empty?)
    [names, ($2 || DEFAULT_ROWS).to_i]
  end

abort "md-table: cannot parse #{spec.inspect}" if headers.nil? || headers.empty?

rows = 1 if rows < 1

widths = headers.map { |h| [h.length, 3].max }
line = ->(cells) { "| #{cells.each_with_index.map { |c, i| c.ljust(widths[i]) }.join(" | ")} |" }

puts line.call(headers)
puts line.call(widths.map { |w| "-" * w })
rows.times { puts line.call(widths.map { "" }) }
