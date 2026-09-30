# frozen_string_literal: true

module Licence
  module Options
    module_function

    COUNTRIES = [
      Option.new(value: "England", text: "England"),
      Option.new(value: "Wales", text: "Wales"),
      Option.new(value: "Scotland", text: "Scotland")
    ].freeze

    LICENCE_LENGTHS = [
      Option.new(value: "1-day", text: "1 day"),
      Option.new(value: "8-days", text: "8 days"),
      Option.new(value: "12-months", text: "12 months")
    ].freeze

    LICENCE_FEES = [
      FeeOption.new(text: "1 day", fee: "£7.10"),
      FeeOption.new(text: "8 days", fee: "£14.20"),
      FeeOption.new(text: "12 months", fee: "£36.80")
    ].freeze

    def countries
      COUNTRIES
    end

    def licence_lengths
      LICENCE_LENGTHS
    end

    def licence_fees
      LICENCE_FEES
    end

    def label_for(options, value)
      found = options.find { |option| option.value == value }
      found ? found.text : value
    end
  end
end
