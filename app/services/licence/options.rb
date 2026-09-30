# frozen_string_literal: true

module Licence
  module Options
    module_function

    REGIONS = [
      Option.new(value: "north-west", text: "North West"),
      Option.new(value: "north-east", text: "North East"),
      Option.new(value: "midlands", text: "Midlands"),
      Option.new(value: "south-west", text: "South West"),
      Option.new(value: "south-east", text: "South East"),
      Option.new(value: "wales", text: "Wales")
    ].freeze

    LICENCE_LENGTHS = [
      LicenceOption.new(value: "1-day", text: "1 day", fee: "£7.10"),
      LicenceOption.new(value: "8-day", text: "8 days", fee: "£14.20"),
      LicenceOption.new(value: "12-month", text: "12 months", fee: "£36.80")
    ].freeze

    CONTACT_OPTIONS = [
      Option.new(value: "email", text: "Email"),
      Option.new(value: "telephone", text: "Telephone")
    ].freeze

    def regions
      REGIONS
    end

    def licence_lengths
      LICENCE_LENGTHS
    end

    def contact_options
      CONTACT_OPTIONS
    end

    def licence_length_options
      LICENCE_LENGTHS.map { |length| Option.new(value: length.value, text: length.text) }
    end

    def start_months(now = nil)
      utc = (now || Time.now.utc).utc
      start = Time.utc(utc.year, utc.month, 1)
      (0...12).map do |index|
        year = start.year + ((start.month - 1 + index) / 12)
        month = ((start.month - 1 + index) % 12) + 1
        Option.new(
          value: format("%04d-%02d", year, month),
          text: Time.utc(year, month, 1).strftime("%B %Y")
        )
      end
    end

    def label_for(options, value)
      found = options.find { |option| option.value == value }
      found ? found.text : value
    end
  end
end
