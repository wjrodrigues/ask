# frozen_string_literal: true

require 'dotenv/load'

require_relative 'environment'
require_relative 'application'
require_relative 'cors'

Application.load!
