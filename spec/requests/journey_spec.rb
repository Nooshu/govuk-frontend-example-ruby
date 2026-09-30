# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Licence journey", type: :request do
  it "walks the 7-step flow with PRG and reaches confirmation" do
    get "/new-application"
    expect(response).to redirect_to("/")

    get "/"
    expect(response.body).to include("Ruby")
    expect(response.body).to include('href="/licence-length"')
    expect(response.body).to include("Apply for a fishing rod licence")

    get "/licence-length"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("How long do you need the licence for?")

    post "/licence-length", params: { "licence-length" => "" }
    expect(response).to redirect_to("/licence-length")
    follow_redirect!
    expect(response.body).to include("Select how long you need the licence for")

    post "/licence-length", params: { "licence-length" => "12-months" }
    expect(response).to redirect_to("/name")

    post "/name", params: { "full-name" => "" }
    expect(response).to redirect_to("/name")
    follow_redirect!
    expect(response.body).to include("Enter your full name")

    post "/name", params: { "full-name" => "Ada Lovelace" }
    expect(response).to redirect_to("/date-of-birth")

    post "/date-of-birth", params: {
      "date-of-birth-day" => "10",
      "date-of-birth-month" => "12",
      "date-of-birth-year" => "1815"
    }
    expect(response).to redirect_to("/where-you-will-fish")

    post "/where-you-will-fish", params: { country: "England" }
    expect(response).to redirect_to("/email")

    post "/email", params: { email: "ada@example.com" }
    expect(response).to redirect_to("/check-answers")

    get "/check-answers"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Accept and continue")
    expect(response.body).to include("10 12 1815")
    expect(response.body).to include("12 months")

    post "/check-answers"
    expect(response).to redirect_to("/confirmation")

    get "/confirmation"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Your example reference number")
    expect(response.body).to include("Nobody will send you a fishing rod licence")
    expect(response.body).to include('href="/components"')

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
