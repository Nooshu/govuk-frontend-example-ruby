# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Licence journey", type: :request do
  it "walks required steps with PRG and reaches confirmation gates" do
    get "/new-application"
    expect(response).to redirect_to("/")

    get "/"
    expect(response.body).to include("Ruby")

    get "/task-list"
    expect(response).to have_http_status(:ok)

    get "/name"
    expect(response).to have_http_status(:ok)

    post "/name", params: { "first-name" => "", "last-name" => "" }
    expect(response).to redirect_to("/name")

    follow_redirect!
    expect(response.body).to include("Error").or include("error").or include("Enter")

    post "/name", params: { "first-name" => "Ada", "last-name" => "Lovelace" }
    expect(response).to redirect_to("/date-of-birth")

    post "/date-of-birth", params: {
      "date-of-birth-day" => "10",
      "date-of-birth-month" => "12",
      "date-of-birth-year" => "1815"
    }
    expect(response).to redirect_to("/email")

    post "/email", params: { "email" => "ada@example.com" }
    expect(response).to redirect_to("/contact-preference")

    post "/contact-preference", params: { "contact-by" => "email" }
    expect(response).to redirect_to("/where-you-will-fish")

    post "/where-you-will-fish", params: { regions: %w[north-west] }
    expect(response).to redirect_to("/licence-length")

    post "/licence-length", params: { "licence-length" => "1-day" }
    expect(response).to be_redirect

    # Continue through remaining steps lightly
    get response.redirect_url if response.redirect?
    post "/start-month", params: { "start-month" => Licence::Options.start_months(Time.now.utc).first.value }
    expect(response).to be_redirect

    post "/address", params: {
      "address-line-1" => "1 Lake Road",
      "town" => "Keswick",
      "postcode" => "CA12 5BN"
    }
    expect(response).to be_redirect

    post "/evidence", params: {}
    expect(response).to be_redirect

    post "/additional-details", params: { "additional-details" => "" }
    expect(response).to be_redirect

    post "/create-a-password", params: {
      "password" => "secure-password",
      "password-confirm" => "secure-password"
    }
    expect(response).to redirect_to("/check-answers")

    get "/check-answers"
    expect(response).to have_http_status(:ok)

    post "/check-answers"
    expect(response).to redirect_to("/confirmation").or be_redirect

    get "/confirmation"
    expect(response).to have_http_status(:ok).or be_redirect

    %w[/fees /help /guidance /accessibility /about /updates /cookies /examples /cy].each do |path|
      get path
      expect(response).to have_http_status(:ok), "expected 200 for #{path}"
    end

    post "/cookie-choices", params: { analytics: "reject" }
    expect(response).to be_redirect.or have_http_status(:ok)

    get "/components"
    expect(response).to have_http_status(:ok)

    get "/components/button"
    expect(response.body).to include("HTML matches the fixture")

    get "/components/button/fixture"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("govuk-button")
  end
end
