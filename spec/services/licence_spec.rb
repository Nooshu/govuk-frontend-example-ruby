# frozen_string_literal: true

require "rails_helper"

RSpec.describe Licence::Validate do
  describe ".validate_name" do
    it "requires a full name and enforces length" do
      expect(described_class.validate_name("").map(&:text)).to include("Enter your full name")
      expect(described_class.validate_name("A").map(&:text)).to include("Enter your full name")
      expect(described_class.validate_name("a" * 101).map(&:text).first).to include("100 characters")
      expect(described_class.validate_name("Ada Lovelace")).to be_empty
    end
  end

  describe ".validate_date_of_birth" do
    let(:now) { Time.utc(2026, 9, 30) }

    it "rejects incomplete, invalid, future, and under-13 dates" do
      expect(described_class.validate_date_of_birth("", "1", "2000", now).map(&:text)).to include("Enter your date of birth")
      expect(described_class.validate_date_of_birth("32", "1", "2000", now).map(&:text)).to include("Enter a real date of birth")
      expect(described_class.validate_date_of_birth("1", "1", "2030", now).map(&:text)).to include("Date of birth must be in the past")
      expect(described_class.validate_date_of_birth("1", "1", "2020", now).map(&:text)).to include("You must be at least 13 to use this example")
      expect(described_class.validate_date_of_birth("10", "12", "1815", now)).to be_empty
    end
  end

  describe ".validate_email" do
    it "accepts a simple email" do
      expect(described_class.validate_email("a@b.co")).to be_empty
      expect(described_class.validate_email("bad")).not_to be_empty
    end
  end

  describe "remaining validators" do
    it "covers country, licence length, and cookie choice" do
      expect(described_class.validate_country("")).not_to be_empty
      expect(described_class.validate_country("England")).to be_empty

      expect(described_class.validate_licence_length("")).not_to be_empty
      expect(described_class.validate_licence_length("1-day")).to be_empty
      expect(described_class.validate_licence_length("8-days")).to be_empty
      expect(described_class.validate_licence_length("12-months")).to be_empty
      expect(described_class.as_licence_length("8-days")).to eq("8-days")
      expect(described_class.as_licence_length("nope")).to eq("")

      expect(described_class.validate_cookie_choice("yes")).to be_empty
      expect(described_class.validate_cookie_choice("maybe")).not_to be_empty
    end
  end
end

RSpec.describe Licence::SessionState do
  let(:session) { {} }

  it "stores application, errors, and cookie choice" do
    app = Licence::Application.new
    described_class.save_application(session, app)
    expect(described_class.get_application(session)).to be_a(Licence::Application)

    described_class.set_errors(session, "/name", [{ "field" => "x", "href" => "#x", "text" => "Enter a name" }])
    expect(described_class.pop_errors_for(session, "/name")).not_to be_empty
    expect(described_class.pop_errors_for(session, "/name")).to be_empty

    described_class.set_cookie_choice(session, "accept")
    expect(described_class.get_cookie_choice(session)).to eq("accept")

    described_class.set_notice(session, "/confirmation", "Saved")
    expect(described_class.pop_notice_for(session, "/confirmation")).to eq("Saved")
  end
end

RSpec.describe Licence::Steps do
  it "orders steps and navigates previous/next" do
    expect(described_class.all.map(&:id)).to eq(
      %w[licence-length name date-of-birth where-you-will-fish email]
    )
    first = described_class.all.first
    expect(described_class.by_id(first.id)).to eq(first)
    nxt = described_class.next_after(first.id)
    expect(nxt.id).to eq("name")
    expect(described_class.previous_before(nxt.id).id).to eq(first.id)
    expect(described_class.previous_before(first.id)).to be_nil
    expect(described_class.reference_for("abcdef12")).to match(/\AFR\d{8}\z/)
  end
end

RSpec.describe Licence::Answers do
  it "builds five check-your-answers rows with day month year DOB" do
    app = Licence::Application.new(
      licence_length: "8-days",
      full_name: "Ada Lovelace",
      day: "10",
      month: "12",
      year: "1815",
      country: "England",
      email: "ada@example.com"
    )
    rows = described_class.summary_rows(app)
    expect(rows.length).to eq(5)
    expect(rows[0]["value"]["text"]).to eq("8 days")
    expect(rows[2]["value"]["text"]).to eq("10 12 1815")
  end
end

RSpec.describe Licence::Save do
  it "marks steps complete when valid" do
    app = Licence::Application.new
    described_class.licence(app, "1-day", valid: true)
    expect(app.licence_length).to eq("1-day")
    expect(app.completed).to include("licence-length")

    described_class.name(app, " Ada Lovelace ", valid: true)
    expect(app.full_name).to eq("Ada Lovelace")

    described_class.country(app, "Wales", valid: false)
    expect(app.completed).not_to include("where-you-will-fish")
  end
end
