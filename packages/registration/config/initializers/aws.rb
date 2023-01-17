# frozen_string_literal: true

credentials = Aws::Credentials.new(
  ENV.fetch('AWS_ACCESS_KEY_ID', nil),
  ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
)

Aws.config.update(region: ENV.fetch('AWS_DEFAULT_REGION', 'us-east-1'), credentials:)
