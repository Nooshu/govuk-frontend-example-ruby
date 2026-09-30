source "https://rubygems.org"

ruby ">= 3.3.0"

gem "puma", ">= 5.0"
gem "rack-brotli"
gem "rails", "~> 8.0.2"
gem "view_component", "~> 4.0"
# Rails 8.0 still passes quirks_mode to JSON; json 3.x removed that keyword.
gem "json", "~> 3.0"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "rspec-rails", "~> 8.0"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "simplecov", require: false
end

group :development do
  gem "web-console"
end
