# frozen_string_literal: true

require "rails_helper"

RSpec.describe Govuk::Nunjucks do
  describe ".escape" do
    it "escapes Nunjucks special characters including backslash" do
      expect(described_class.escape("&\"'<>\\")).to eq("&amp;&quot;&#39;&lt;&gt;&#92;")
    end
  end

  describe ".truthy?" do
    it "treats empty arrays and params as truthy" do
      expect(described_class.truthy?([])).to be(true)
      expect(described_class.truthy?(Govuk::Params.new)).to be(true)
    end

    it "treats zero numbers as falsy" do
      expect(described_class.truthy?(Govuk::Number.new("0"))).to be(false)
    end

    it "treats empty strings and undefined as falsy" do
      expect(described_class.truthy?("")).to be(false)
      expect(described_class.truthy?(Govuk::UNDEFINED)).to be(false)
      expect(described_class.truthy?(nil)).to be(false)
    end
  end

  describe ".loose_eq and .strict_eq" do
    it "compares loosely across number and string" do
      expect(described_class.loose_eq(Govuk::Number.new("1"), "1")).to be(true)
      expect(described_class.strict_eq(Govuk::Number.new("1"), "1")).to be(false)
    end

    it "compares booleans loosely to numbers" do
      expect(described_class.loose_eq(true, Govuk::Number.new("1"))).to be(true)
      expect(described_class.loose_eq(false, Govuk::Number.new("0"))).to be(true)
    end
  end

  describe ".contains?" do
    it "searches strings, arrays, and params keys" do
      expect(described_class.contains?("a", "cat")).to be(true)
      expect(described_class.contains?("x", %w[a x])).to be(true)
      params = Govuk::Params.new_params("foo", "bar")
      expect(described_class.contains?("foo", params)).to be(true)
    end
  end

  describe ".indent" do
    it "indents lines optionally including the first" do
      expect(described_class.indent("a\nb", 2, false)).to eq("a\n  b")
      expect(described_class.indent("a\nb", 2, true)).to eq("  a\n  b")
      expect(described_class.indent("", 2, true)).to eq("")
    end
  end

  describe ".default and .default_truthy" do
    it "applies fallbacks" do
      expect(described_class.default(Govuk::UNDEFINED, "x")).to eq("x")
      expect(described_class.default("", "x")).to eq("")
      expect(described_class.default_truthy("", "x")).to eq("x")
    end
  end

  describe ".length" do
    it "counts arrays, params, and strings" do
      expect(described_class.length(%w[a b])).to eq(2)
      expect(described_class.length(Govuk::Params.new_params("a", 1))).to eq(1)
      expect(described_class.length("ab")).to eq(2)
      expect(described_class.length(true)).to eq(0)
    end
  end

  describe ".str_value" do
    it "stringifies lists and safe values" do
      expect(described_class.str_value(%w[a b])).to eq("a,b")
      expect(described_class.str_value(Govuk::Safe.new("<i>"))).to eq("<i>")
      expect(described_class.str_value(true)).to eq("true")
      expect(described_class.str_value(Govuk::Params.new)).to eq("[object Object]")
    end
  end
end

RSpec.describe Govuk::Params do
  it "preserves key order and number spelling" do
    parsed = described_class.parse_json('{"b":1,"a":2.5,"n":null,"t":true,"f":false,"s":"x","arr":[1]}')
    expect(parsed.keys).to eq(%w[b a n t f s arr])
    expect(parsed.get("b")).to be_a(Govuk::Number)
    expect(parsed.get("b").to_s).to eq("1")
    expect(parsed.get("a").to_s).to eq("2.5")
    expect(parsed.get("n")).to be_nil
    expect(parsed.get("missing")).to equal(Govuk::UNDEFINED)
  end

  it "decodes escaped strings" do
    parsed = described_class.parse_json('"hi\\n\\"there\\u0026"')
    expect(parsed).to eq("hi\n\"there&")
  end

  it "builds from pairs and mappings" do
    p = described_class.new_params("x", 1, "y", { "z" => 2 })
    expect(p.get("x")).to eq(1)
    expect(described_class.params_from_mapping("a" => [1, { "b" => 2 }]).get("a")).to be_a(Array)
  end

  it "rejects odd pairs" do
    expect { described_class.new_params("only") }.to raise_error(ArgumentError)
  end
end

RSpec.describe Govuk::Catalogue do
  it "describes known and unknown components" do
    known = described_class.describe("button")
    expect(known.title).to eq("Button")
    unknown = described_class.describe("brand-new-widget")
    expect(unknown.title).to include("Brand")
  end

  it "lists all installed fixture components" do
    list = described_class.all(Rails.application.config.govuk_components_dir)
    expect(list.map(&:name)).to include("button", "back-link")
  end
end

RSpec.describe Govuk::Attributes do
  it "renders optional boolean attributes and i18n" do
    attrs = Govuk::Params.new_params(
      "disabled", Govuk::Params.new_params("value", true, "optional", true),
      "hidden", Govuk::Params.new_params("value", false, "optional", true)
    )
    html = described_class.attributes(attrs)
    expect(html).to include(" disabled")
    expect(html).not_to include("hidden")

    messages = Govuk::Params.new_params("one", "One", "other", "Other")
    expect(described_class.i18n_attributes("count", nil, messages)).to include("data-i18n.count.one")
    expect(described_class.i18n_attributes("label", "Hi", nil)).to include('data-i18n.label="Hi"')
  end
end
