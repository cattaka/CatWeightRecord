# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

ActionController::Base.config.relative_url_root = ENV["RAILS_RELATIVE_URL_ROOT"]
map ActionController::Base.config.relative_url_root || "/" do
  run Rails.application
end
