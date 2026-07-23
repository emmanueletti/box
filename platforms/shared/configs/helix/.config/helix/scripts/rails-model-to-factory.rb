#!/usr/bin/env ruby
# frozen_string_literal: true

# Toggle between app/models/**/name.rb and its FactoryBot factory. Guesses
# test/factories/**/pluralized_name.rb first (namespace directories mirrored,
# matching the common case); if that file doesn't exist, falls back to
# searching all factory files for a matching `factory :name do` declaration,
# since factory file layout isn't enforced by any tool (unlike test files)
# and doesn't always mirror the model tree -- and not every model has one
# (plain ActiveModel/PORO classes usually don't).
require "active_support/inflector"

caller_path = ARGV[0]

if caller_path.start_with?("app/models/") && caller_path.end_with?(".rb")
  rel = caller_path.sub("app/models/", "").sub(/\.rb\z/, "")
  dir = File.dirname(rel)
  name = File.basename(rel)
  dir = "" if dir == "."

  guess = "test/factories/#{dir.empty? ? "" : "#{dir}/"}#{name.pluralize}.rb"

  if File.exist?(guess)
    puts guess
    exit
  end

  found = Dir.glob("test/factories/**/*.rb").find do |f|
    File.readlines(f).any? { |l| l =~ /^\s*factory\s+:#{Regexp.escape(name)}\b/ }
  end
  puts found || caller_path

elsif caller_path.start_with?("test/factories/") && caller_path.end_with?(".rb")
  rel = caller_path.sub("test/factories/", "").sub(/\.rb\z/, "")
  dir = File.dirname(rel)
  name = File.basename(rel)
  dir = "" if dir == "."

  guess = "app/models/#{dir.empty? ? "" : "#{dir}/"}#{name.singularize}.rb"

  if File.exist?(guess)
    puts guess
    exit
  end

  match = File.read(caller_path).match(/^\s*factory\s+:(\w+)/)
  if match
    found = Dir.glob("app/models/**/#{match[1]}.rb").first
    puts found || caller_path
  else
    puts caller_path
  end
else
  puts caller_path
end
