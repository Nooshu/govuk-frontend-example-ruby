# frozen_string_literal: true

class RobotsController < ApplicationController
  def show
    set_baseline("document")
    render plain: "User-agent: *\nDisallow: /\n", content_type: "text/plain; charset=utf-8"
  end
end
