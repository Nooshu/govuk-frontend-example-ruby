# frozen_string_literal: true

module Licence
  FieldError = Struct.new(:field, :href, :text, keyword_init: true) do
    def as_dict
      { "field" => field, "href" => href, "text" => text }
    end
  end
end
