# frozen_string_literal: true

require 'dotenv/load'

require_relative 'environment'
require_relative 'application'

Application.load!
