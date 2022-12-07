# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Model::Application, type: :lib do
  describe '#call' do
    before do
      # rubocop:disable Lint/ConstantDefinitionInBlock
      class Foo < Model::Application
        def call
          self
        end
      end
      # rubocop:enable Lint/ConstantDefinitionInBlock
    end

    context 'when accessing attribute :response' do
      it 'returns instance of Model::Response' do
        instance = Foo.call

        expect(instance.response).to be_is_a(Model::Response)
      end
    end
  end

  describe '#new' do
    context 'when the class is instanced' do
      it 'raises private method' do
        expect { described_class.new }.to raise_error(NoMethodError)
      end
    end
  end
end
