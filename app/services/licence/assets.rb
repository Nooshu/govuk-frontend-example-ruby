# frozen_string_literal: true

require "digest"
require "pathname"

module Licence
  module Assets
    module_function

    HASHED_FONT = /-[a-f0-9]{8,}-/
    CONTENT_TYPES = {
      ".css" => "text/css; charset=utf-8",
      ".js" => "text/javascript; charset=utf-8",
      ".mjs" => "text/javascript; charset=utf-8",
      ".map" => "application/json; charset=utf-8",
      ".woff2" => "font/woff2",
      ".woff" => "font/woff",
      ".svg" => "image/svg+xml",
      ".png" => "image/png",
      ".ico" => "image/x-icon",
      ".json" => "application/json; charset=utf-8",
      ".gif" => "image/gif",
      ".jpg" => "image/jpeg",
      ".jpeg" => "image/jpeg"
    }.freeze
    ROOT_FILES = %w[govuk-frontend.min.js govuk-frontend.min.js.map manifest.json].freeze

    def fingerprint(body)
      Digest::SHA256.hexdigest(body)[0, 10]
    end

    def load_page_assets
      @load_page_assets ||= begin
        stylesheet = Rails.configuration.dist_dir.join("stylesheets/application.css")
        css = File.binread(stylesheet)
        govuk_root = Rails.configuration.govuk_frontend_root.join("dist/govuk")
        script_path = govuk_root.join("govuk-frontend.min.js")
        script = File.binread(script_path)
        css_href = "/assets/application.#{fingerprint(css)}.css"
        script_href = "/assets/govuk-frontend.#{fingerprint(script)}.min.js"
        app = "import { initAll } from '#{script_href}';\n\ninitAll();\n".b
        PageAssets.new(
          stylesheet_href: css_href,
          app_module_href: "/assets/app.#{fingerprint(app)}.mjs",
          script_href: script_href,
          css_body: css,
          script_body: script,
          app_body: app
        )
      end
    end

    def clear_cache!
      @page_assets = nil
    end

    def resolve(url_path)
      return nil unless url_path.start_with?("/assets/")

      page = load_page_assets
      if url_path == page.stylesheet_href
        return ResolvedAsset.new(
          path: Rails.configuration.dist_dir.join("stylesheets/application.css"),
          body: page.css_body,
          content_type: "text/css; charset=utf-8",
          kind: "fingerprinted-asset"
        )
      end
      if url_path == page.script_href
        return ResolvedAsset.new(
          path: Rails.configuration.govuk_frontend_root.join("dist/govuk/govuk-frontend.min.js"),
          body: page.script_body,
          content_type: "text/javascript; charset=utf-8",
          kind: "fingerprinted-asset"
        )
      end
      if url_path == page.app_module_href
        return ResolvedAsset.new(
          path: nil,
          body: page.app_body,
          content_type: "text/javascript; charset=utf-8",
          kind: "fingerprinted-asset"
        )
      end

      requested = url_path.delete_prefix("/assets/")
      return nil if requested.empty? || requested.include?("\x00") || Pathname(requested).each_filename.include?("..")

      govuk_root = Rails.configuration.govuk_frontend_root.join("dist/govuk")
      frontend_assets = govuk_root.join("assets")

      if ROOT_FILES.include?(requested)
        target = govuk_root.join(requested)
      else
        target = frontend_assets.join(requested).expand_path
        begin
          target.relative_path_from(frontend_assets.expand_path)
        rescue ArgumentError
          return nil
        end
      end

      return nil unless target.file?

      content_type = CONTENT_TYPES[target.extname.downcase]
      return nil if content_type.nil?

      kind = requested.start_with?("fonts/") && HASHED_FONT.match?(requested) ? "fingerprinted-asset" : "static-asset"
      ResolvedAsset.new(path: target, body: nil, content_type: content_type, kind: kind)
    end
  end
end
