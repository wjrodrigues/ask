# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Middleware::Auth, type: :middleware do
  describe '#check' do
    context '--' do
      it '-' do
        binding.pry
        Middleware::Auth.check!(double(halt: nil), '')
      end
    end
  end
end
