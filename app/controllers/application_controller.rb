# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :layout_assign

  before_action :set_default_baseline

  private

  def set_default_baseline
    request.env["govuk.baseline_kind"] = "document"
  end

  def set_baseline(kind)
    request.env["govuk.baseline_kind"] = kind
  end

  def layout_assign(**opts)
    @layout = Licence::Chrome.layout_context(request, **opts)
    set_baseline(opts[:personal] ? "sensitive-document" : "document")
    @layout
  end

  def errors_from_session(path)
    Licence::SessionState.pop_errors_for(session, path).map do |item|
      Licence::FieldError.new(field: item["field"], href: item["href"], text: item["text"])
    end
  end

  def current_application
    Licence::SessionState.get_application(session)
  end

  def save_current_application(application)
    Licence::SessionState.save_application(session, application)
  end
end
