# frozen_string_literal: true

if ENV['coverage']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'

    minimum_coverage 100
  end
end
