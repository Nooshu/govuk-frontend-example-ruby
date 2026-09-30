# frozen_string_literal: true

module Licence
  class Application
    ATTRS = %i[
      first_name last_name day month year email contact_by telephone regions
      licence_length start_month address_line_1 address_line_2 town postcode
      evidence_filename additional_details password_created submitted reference completed
    ].freeze

    attr_accessor(*ATTRS)

    def initialize(**attrs)
      @first_name = ""
      @last_name = ""
      @day = ""
      @month = ""
      @year = ""
      @email = ""
      @contact_by = ""
      @telephone = ""
      @regions = []
      @licence_length = ""
      @start_month = ""
      @address_line_1 = ""
      @address_line_2 = ""
      @town = ""
      @postcode = ""
      @evidence_filename = ""
      @additional_details = ""
      @password_created = false
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
        "first_name" => first_name,
        "last_name" => last_name,
        "day" => day,
        "month" => month,
        "year" => year,
        "email" => email,
        "contact_by" => contact_by,
        "telephone" => telephone,
        "regions" => regions.dup,
        "licence_length" => licence_length,
        "start_month" => start_month,
        "address_line_1" => address_line_1,
        "address_line_2" => address_line_2,
        "town" => town,
        "postcode" => postcode,
        "evidence_filename" => evidence_filename,
        "additional_details" => additional_details,
        "password_created" => password_created,
        "submitted" => submitted,
        "reference" => reference,
        "completed" => completed.dup
      }
    end

    def self.from_h(data)
      return new if data.blank?

      regions = data["regions"] || data[:regions] || []
      completed = data["completed"] || data[:completed] || []
      new(
        first_name: (data["first_name"] || data[:first_name]).to_s,
        last_name: (data["last_name"] || data[:last_name]).to_s,
        day: (data["day"] || data[:day]).to_s,
        month: (data["month"] || data[:month]).to_s,
        year: (data["year"] || data[:year]).to_s,
        email: (data["email"] || data[:email]).to_s,
        contact_by: (data["contact_by"] || data[:contact_by]).to_s,
        telephone: (data["telephone"] || data[:telephone]).to_s,
        regions: Array(regions).map(&:to_s),
        licence_length: (data["licence_length"] || data[:licence_length]).to_s,
        start_month: (data["start_month"] || data[:start_month]).to_s,
        address_line_1: (data["address_line_1"] || data[:address_line_1]).to_s,
        address_line_2: (data["address_line_2"] || data[:address_line_2]).to_s,
        town: (data["town"] || data[:town]).to_s,
        postcode: (data["postcode"] || data[:postcode]).to_s,
        evidence_filename: (data["evidence_filename"] || data[:evidence_filename]).to_s,
        additional_details: (data["additional_details"] || data[:additional_details]).to_s,
        password_created: !!(data["password_created"] || data[:password_created]),
        submitted: !!(data["submitted"] || data[:submitted]),
        reference: (data["reference"] || data[:reference]).to_s,
        completed: Array(completed).map(&:to_s)
      )
    end
  end
end
