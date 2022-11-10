# frozen_string_literal: true

# Allow CORS (Cross-Origin Resource Sharing) requests
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post delete put patch options head]
  end
end
