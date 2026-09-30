# frozen_string_literal: true

module Licence
  AddressValues = Struct.new(:line1, :line2, :town, :postcode, keyword_init: true)
end
