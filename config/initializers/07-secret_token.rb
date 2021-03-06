Rails.logger.debug "Starting 07-secret_token.rb at #{Time.now.to_s}"

secret_token = ENV['SECRET_TOKEN']

if secret_token.blank? && ActiveRecord::Base.connection.table_exists?('concerto_configs')
  # Try go get secret key from concerto config or auto-generate it
  secret_token = ConcertoConfig[:secret_token]

  if secret_token.blank?
    require 'securerandom'
    secret_token = SecureRandom.hex(64)
    ConcertoConfig.set('secret_token', secret_token)
    Rails.logger.debug 'Auto-generated secret token'
  end
end

# Secret key for verifying the integrity of signed cookies.
Concerto::Application.config.secret_token = secret_token
ENV["SECRET_KEY_BASE"] = secret_token

Rails.logger.debug "Completed 07-secret_token.rb at #{Time.now.to_s}"
