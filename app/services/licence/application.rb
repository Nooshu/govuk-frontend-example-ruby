# frozen_string_literal: true

module Licence
  class Application
    ATTRS = %i[
      licence_length full_name day month year country email submitted reference completed
    ].freeze

    attr_accessor(*ATTRS)

    def initialize(**attrs)
      @licence_length = ""
      @full_name = ""
      @day = ""
      @month = ""
      @year = ""
      @country = ""
      @email = ""
      @submitted = false
      @reference = ""
      @completed = []
      attrs.each { |k, v| public_send("#{k}=", v) if ATTRS.include?(k) }
    end

    def completed?(step_id)
      completed.include?(step_id)
    end
    alias is_completed completed?

    def to_h
      {
        "licence_length" => licence_length,
        "full_name" => full_name,
        "day" => day,
        "month" => month,
        "year" => year,
        "country" => country,
        "email" => email,
        "submitted" => submitted,
        "reference" => reference,
        "completed" => completed.dup
      }
    end

    def self.from_h(data)
      return new if data.blank?

      completed = data["completed"] || data[:completed] || []
      new(
        licence_length: (data["licence_length"] || data[:licence_length]).to_s,
        full_name: (data["full_name"] || data[:full_name]).to_s,
        day: (data["day"] || data[:day]).to_s,
        month: (data["month"] || data[:month]).to_s,
        year: (data["year"] || data[:year]).to_s,
        country: (data["country"] || data[:country]).to_s,
        email: (data["email"] || data[:email]).to_s,
        submitted: !!(data["submitted"] || data[:submitted]),
        reference: (data["reference"] || data[:reference]).to_s,
        completed: Array(completed).map(&:to_s)
      )
    end
  end
end
