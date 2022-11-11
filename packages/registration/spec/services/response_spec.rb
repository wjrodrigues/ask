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

  describe '#ok?' do
    context 'when has errors' do
      it 'returns false' do
        subject.add_error('errors.messages.blank')

        expect(subject.ok?).to be_falsy
      end
    end

    context 'when not has errors' do
      it 'returns true' do
        expect(subject.ok?).to be_truthy
      end
    end
  end

  describe '#add_result' do
    context 'when informed' do
      it 'returns instance with result' do
        response = subject.add_result('ruby')

        expect(response.result).to eq('ruby')
      end
    end
  end
end
