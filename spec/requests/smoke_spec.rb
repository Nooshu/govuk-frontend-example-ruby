# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Health and robots", type: :request do
  it "returns ok from /health" do
    get "/health"
    expect(response).to have_http_status(:ok)
    expect(response.body).to eq("ok")
    expect(response.headers["X-Robots-Tag"]).to eq("noindex, nofollow")
  end

  it "disallows all crawlers in robots.txt" do
    get "/robots.txt"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Disallow: /")
  end
end

RSpec.describe "Component preview parity banner", type: :request do
  before do
    skip "demos disabled" unless Rails.configuration.demos_enabled
    # Ensure CSS exists for layout asset fingerprinting
    stylesheet = Rails.configuration.dist_dir.join("stylesheets/application.css")
    skip "run npm run build:styles first" unless stylesheet.exist?
  end

  it "shows a success banner when Ruby HTML matches the fixture" do
    get "/components/button"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("HTML matches the fixture")
    expect(response.body).to include('meta name="robots" content="noindex, nofollow"')
  end

  it "serves raw fixture HTML" do
    get "/components/button/fixture"
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("text/html")
    expect(response.body).to include("govuk-button")
  end
end

RSpec.describe "Start page", type: :request do
  before do
    stylesheet = Rails.configuration.dist_dir.join("stylesheets/application.css")
    skip "run npm run build:styles first" unless stylesheet.exist?
  end

  it "mentions the Ruby library on the developer preview blurb" do
    get "/"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Ruby library")
    expect(response.body).not_to include("Go library")
  end
end
