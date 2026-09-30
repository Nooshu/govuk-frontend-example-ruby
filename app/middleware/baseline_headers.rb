# frozen_string_literal: true

class BaselineHeaders
  REMOVE = %w[
    Server
    X-Powered-By
    X-AspNet-Version
    X-AspNetMvc-Version
  ].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    request = ActionDispatch::Request.new(env)

    kind = env["govuk.baseline_kind"] || headers.delete("X-Baseline-Kind") || "document"
    return [status, headers, body] if kind == "skip"

    secure = request.ssl? || request.headers["X-Forwarded-Proto"] == "https"
    sets_cookie = headers.key?("Set-Cookie") || Array(headers["set-cookie"]).any?
    content_type = headers["Content-Type"]
    etag = headers["ETag"]

    begin
      built = Baseline::Policy.build_response_headers(
        kind: kind.to_s,
        secure_transport: secure,
        content_type: content_type,
        etag: etag,
        sets_cookie: sets_cookie
      )
    rescue ArgumentError
      return [status, headers, body]
    end

    REMOVE.each { |name| headers.delete(name) }
    built.each do |name, value|
      next if name == "Content-Type" && content_type.present?

      headers[name] = value
    end

    [status, headers, body]
  end
end
