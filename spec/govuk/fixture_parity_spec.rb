# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GOV.UK Frontend fixture parity" do
  components_dir = Rails.configuration.govuk_components_dir

  Govuk::Fixtures.fixture_components(components_dir).each do |component|
    fixture_set = Govuk::Fixtures.load(components_dir, component)

    fixture_set.fixtures.each do |fixture|
      it "#{component} / #{fixture.name} matches fixture html byte-for-byte" do
        rendered = Govuk.render(component, fixture.options)
        expect(rendered).to eq(fixture.html), lambda {
          expected_lines = fixture.html.lines
          actual_lines = rendered.lines
          index = expected_lines.zip(actual_lines).index { |a, b| a != b } || [expected_lines.length, actual_lines.length].min
          [
            "First differing line at index #{index}:",
            "  expected: #{expected_lines[index].inspect}",
            "  actual:   #{actual_lines[index].inspect}"
          ].join("\n")
        }
      end
    end
  end
end
