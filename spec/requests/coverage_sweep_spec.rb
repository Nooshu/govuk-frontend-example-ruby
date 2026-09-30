# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Coverage sweep", type: :request do
  it "hits supporting pages, cookie flows, and demo examples" do
    get "/examples/exit-this-page"
    expect(response).to have_http_status(:ok)
    get "/examples/service-unavailable"
    expect(response).to have_http_status(:ok)
    get "/examples/problem-with-the-service"
    expect(response).to have_http_status(:ok)

    get "/cookies"
    expect(response).to have_http_status(:ok)

    post "/cookies", params: { analytics: "yes" }
    expect(response).to be_redirect.or have_http_status(:ok)

    post "/cookie-choices", params: { analytics: "accept" }
    expect(response).to be_redirect.or have_http_status(:ok)

    post "/cookie-choices", params: { analytics: "reject" }
    expect(response).to be_redirect.or have_http_status(:ok)

    get "/components/not-a-component"
    expect([404, 200, 302]).to include(response.status)

    get "/assets/images/favicon.ico"
    expect([200, 404]).to include(response.status)

    # Fingerprinted stylesheet if present
    css = Rails.root.join("dist/stylesheets/application.css")
    if css.file?
      get "/assets/application.css"
      expect([200, 404]).to include(response.status)
    end
  end

  it "renders every journey step GET after seeding session via posts" do
    get "/new-application"
    follow_redirect! if response.redirect?

    post "/name", params: { "first-name" => "Ada", "last-name" => "Lovelace" }
    get "/name"
    expect(response).to have_http_status(:ok)

    post "/date-of-birth", params: {
      "date-of-birth-day" => "10", "date-of-birth-month" => "12", "date-of-birth-year" => "1815"
    }
    get "/date-of-birth"
    expect(response).to have_http_status(:ok)

    post "/email", params: { email: "ada@example.com" }
    get "/email"
    expect(response).to have_http_status(:ok)

    post "/contact-preference", params: { "contact-by" => "telephone", "telephone" => "01632 960 001" }
    get "/contact-preference"
    expect(response).to have_http_status(:ok)

    post "/where-you-will-fish", params: { regions: %w[wales] }
    get "/where-you-will-fish"
    expect(response).to have_http_status(:ok)

    post "/licence-length", params: { "licence-length" => "12-month" }
    get "/licence-length"
    expect(response).to have_http_status(:ok)

    month = Licence::Options.start_months(Time.now.utc).first.value
    post "/start-month", params: { "start-month" => month }
    get "/start-month"
    expect(response).to have_http_status(:ok)

    post "/address", params: {
      "address-line-1" => "1 Lake Road", "address-line-2" => "Flat 2",
      "town" => "Keswick", "postcode" => "CA12 5BN"
    }
    get "/address"
    expect(response).to have_http_status(:ok)

    get "/evidence"
    expect(response).to have_http_status(:ok)

    post "/additional-details", params: { "additional-details" => "None" }
    get "/additional-details"
    expect(response).to have_http_status(:ok)

    get "/create-a-password"
    expect(response).to have_http_status(:ok)

    # return-to check answers
    get "/name?return=check-answers"
    expect(response).to have_http_status(:ok)
    post "/name", params: { "first-name" => "Ada", "last-name" => "Lovelace", returnTo: "check-answers" }
    expect(response).to redirect_to("/check-answers")
  end
end

RSpec.describe Govuk::Nunjucks do
  it "covers at/items/get helpers and format_number edge cases" do
    expect(described_class.items(nil)).to eq([])
    expect(described_class.at(%w[a b], 1)).to eq("b")
    expect(described_class.at(%w[a], 5)).to equal(Govuk::UNDEFINED)
    expect(described_class.get(Govuk::Params.new_params("a", Govuk::Params.new_params("b", "c")), "a", "b")).to eq("c")
    expect(described_class.get("nope", "a")).to equal(Govuk::UNDEFINED)
    expect(described_class.format_number(Govuk::Number.new("1.50")).to_s).not_to be_empty
    expect(described_class.out(Govuk::Safe.new("<b>"))).to eq("<b>")
    expect(described_class.heading("2", "1")).to eq("2")
    expect(described_class.heading(Govuk::UNDEFINED, "1")).to eq("1")
    expect(described_class.concat_if(" ", "x")).to eq(" x")
    expect(described_class.concat_if(" ", "")).to eq("")
  end
end

RSpec.describe Govuk::Params do
  it "covers Number helpers and has?" do
    n = Govuk::Number.new("42")
    expect(n.as_int).to eq(42)
    expect(n.as_float).to eq(42.0)
    expect(Govuk::Number.new("x").as_int).to be_nil
    p = described_class.new_params("k", "v")
    expect(p.has?("k")).to be(true)
    expect(p.length).to eq(1)
    expect(p.each_pair.to_a).to eq([%w[k v]])
  end

  it "raises on invalid JSON shapes" do
    expect { described_class.parse_json("{") }.to raise_error(JSON::ParserError)
    expect { described_class.parse_json("nul") }.to raise_error(JSON::ParserError)
  end
end

RSpec.describe Govuk do
  it "exposes must_render and components" do
    html = described_class.must_render("tag", Govuk::Params.new_params("text", "New"))
    expect(html).to include("govuk-tag")
    expect(described_class.components).to include("button")
    expect { described_class.render("nope", nil) }.to raise_error(ArgumentError)
  end
end
