# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Service::Response, type: :service do
  describe '#add_error' do
    context 'when the default is translate' do
      it 'adds translated error to list' do
        subject.add_error('errors.messages.blank')

        expect(subject.errors).to eq(["can't be blank"])
      end

      context 'and locale is pt-BR', locale: :'pt-BR' do
        it 'adds translated error to list' do
          subject.add_error('errors.messages.blank')

          expect(subject.errors).to eq(['não pode ficar em branco'])
        end
      end
    end

    context 'when not to translate' do
      it 'adds passed value to error list' do
        subject.add_error('invalid value', translate: false)

        expect(subject.errors).to eq(['invalid value'])
      end
    end
  end
end
