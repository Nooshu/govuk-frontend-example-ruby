# frozen_string_literal: true

class HealthController < ApplicationController
  def show
    set_baseline("document")
    render plain: "ok", content_type: "text/plain; charset=utf-8"
  end
end
