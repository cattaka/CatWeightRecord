# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

@relative_url_root = ENV["RAILS_RELATIVE_URL_ROOT"]
map @relative_url_root || "/" do
  run Rails.application
end
