# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Middleware::Auth, type: :middleware do
  describe '#current_user' do
    context 'when the session is not defined' do
      it 'calls decode_token from Lib::Auth' do
        token = 'ask_123'
        env = double(env: { 'HTTP_AUTHORIZATION' => token })
        app = double(request: env, session: {})
        user = create(:user, email: 'billie_harvey@bauch-hills.info')

        expect(Lib::Auth)
          .to receive(:decode_token)
          .with(token)
          .and_return({ 'email' => user.email })

        result = Middleware::Auth.current_user(app)

        expect(result).to eq({ id: user.id, email: user.email })
      end
    end

    context 'when the session is defined' do
      it 'does not call decode_token from Lib::Auth' do
        user = create(:user, email: 'billie_harvey@bauch-hills.info')
        app = double(session: { 'current_user' => { id: user.id, email: user.email } })

        expect(Lib::Auth).not_to receive(:decode_token)

        result = Middleware::Auth.current_user(app)

        expect(result).to eq({ id: user.id, email: user.email })
      end
    end
  end

  describe '#check!' do
    context 'when the token is valid' do
      it 'returns nil' do
        env = double(env: { 'HTTP_AUTHORIZATION' => 'ask_123' })
        app = double(request: env, session: {})

        expect(Lib::Auth).to receive(:valid_token?).and_return(true)

        expect(Middleware::Auth.check!(app)).to be_nil
      end
    end

    context 'when the token is invalid' do
      it 'returns http UNAUTHORIZED status' do
        env = double(env: { 'HTTP_AUTHORIZATION' => 'ask_123' })
        app = double(request: env, session: {})

        expect(Lib::Auth).to receive(:valid_token?).and_return(false)
        expect(app).to receive(:halt).with(401)

        Middleware::Auth.check!(app)
      end
    end
  end
end
