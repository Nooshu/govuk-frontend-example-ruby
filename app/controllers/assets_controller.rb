# frozen_string_literal: true

require "digest"

class AssetsController < ApplicationController
  skip_forgery_protection

  def show
    resolved = Licence::Assets.resolve(request.path)
    unless resolved
      set_baseline("document")
      return render plain: "Not found", status: :not_found, content_type: "text/plain; charset=utf-8"
    end

    body = resolved.body
    body = File.binread(resolved.path) if body.nil? && resolved.path
    unless body
      set_baseline("document")
      return render plain: "Not found", status: :not_found, content_type: "text/plain; charset=utf-8"
    end

    set_baseline(resolved.kind)
    response.headers["ETag"] = %("#{Digest::SHA256.hexdigest(body)}")
    send_data body, type: resolved.content_type, disposition: "inline"
  end
end
