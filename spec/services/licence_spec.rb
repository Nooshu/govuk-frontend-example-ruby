# frozen_string_literal: true

require "rails_helper"

RSpec.describe Licence::Validate do
  describe ".validate_name" do
    it "requires both names and enforces length" do
      expect(described_class.validate_name("", "").map(&:text)).to include("Enter your first name")
      expect(described_class.validate_name("a" * 101, "Ok").map(&:text).first).to include("100 characters")
      expect(described_class.validate_name("Ada", "Lovelace")).to be_empty
    end
  end

  describe ".validate_date_of_birth" do
    let(:now) { Time.utc(2026, 9, 30) }

    it "rejects incomplete, invalid, future, and under-13 dates" do
      expect(described_class.validate_date_of_birth("", "1", "2000", now)).not_to be_empty
      expect(described_class.validate_date_of_birth("32", "1", "2000", now)).not_to be_empty
      expect(described_class.validate_date_of_birth("1", "1", "2030", now)).not_to be_empty
      expect(described_class.validate_date_of_birth("1", "1", "2020", now).map(&:text).first).to include("13 or over")
      expect(described_class.validate_date_of_birth("10", "12", "1815", now)).to be_empty
    end
  end

  describe ".validate_email" do
    it "accepts a simple email" do
      expect(described_class.validate_email("a@b.co")).to be_empty
      expect(described_class.validate_email("bad")).not_to be_empty
    end
  end

  describe ".validate_contact_preference" do
    it "requires telephone when contact by phone" do
      expect(described_class.validate_contact_preference("email", "")).to be_empty
      expect(described_class.validate_contact_preference("telephone", "")).not_to be_empty
      expect(described_class.validate_contact_preference("telephone", "01632 960 001")).to be_empty
      expect(described_class.validate_contact_preference("nope", "")).not_to be_empty
    end
  end

  describe "remaining validators" do
    it "covers regions, licence, month, address, password, evidence" do
      expect(described_class.validate_regions([])).not_to be_empty
      expect(described_class.validate_regions(%w[north-west])).to be_empty

      expect(described_class.validate_licence_length("")).not_to be_empty
      expect(described_class.validate_licence_length("1-day")).to be_empty

      months = Licence::Options.start_months(Time.utc(2026, 1, 15))
      expect(described_class.validate_start_month("", Time.utc(2026, 1, 15))).not_to be_empty
      expect(described_class.validate_start_month(months.first.value, Time.utc(2026, 1, 15))).to be_empty

      expect(described_class.validate_address("", "", "")).not_to be_empty
      expect(described_class.validate_address("1 Street", "Town", "SW1A 1AA")).to be_empty

      expect(described_class.validate_password("short", "short")).not_to be_empty
      expect(described_class.validate_password("long-enough-password", "long-enough-password")).to be_empty
      expect(described_class.validate_password("long-enough-password", "other")).not_to be_empty

      expect(described_class.validate_evidence("")).to be_empty
      expect(described_class.validate_evidence("file.pdf")).to be_empty
      expect(described_class.validate_evidence("file.exe")).not_to be_empty
      expect(described_class.safe_filename("../x.pdf")).to eq("x.pdf")
      expect(described_class.validate_additional_details("a" * 201)).not_to be_empty
      expect(described_class.validate_cookie_choice("yes")).to be_empty
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
    first = described_class.all.first
    expect(described_class.by_id(first.id)).to eq(first)
    nxt = described_class.next_after(first.id)
    expect(nxt).not_to be_nil
    expect(described_class.previous_before(nxt.id).id).to eq(first.id)
  end
end
