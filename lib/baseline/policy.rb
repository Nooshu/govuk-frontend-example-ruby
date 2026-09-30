# frozen_string_literal: true

require "json"

module Baseline
  module Policy
    module_function

    VALID_KINDS = %w[
      document
      sensitive-document
      fingerprinted-asset
      static-asset
      download
      sensitive-download
    ].freeze

    def load
      @policy ||= JSON.parse(Rails.root.join("baseline/policy.json").read)
    end

    def reload!
      @policy = nil
      load
    end

    def js_enabled_snippet
      load.fetch("jsEnabledSnippet")
    end

    def js_enabled_script_hash
      load.fetch("jsEnabledScriptHash")
    end

    def build_response_headers(kind:, secure_transport:, content_type: nil, etag: nil, sets_cookie: false, filename: nil)
      raise ArgumentError, "unknown cache kind: #{kind.inspect}" unless VALID_KINDS.include?(kind)

      policy = load
      headers = policy.fetch("headers").fetch("all").dup

      if %w[document sensitive-document].include?(kind)
        headers.merge!(policy.fetch("headers").fetch("document"))
      end

      cache = policy.fetch("cacheControl").fetch(kind)
      cache = "private, no-cache" if sets_cookie && kind == "document"
      headers["Cache-Control"] = cache

      if content_type
        headers["Content-Type"] = content_type
      elsif policy.fetch("contentTypes").key?(kind)
        headers["Content-Type"] = policy.fetch("contentTypes").fetch(kind)
      end

      if %w[document sensitive-document].include?(kind)
        headers["Content-Security-Policy"] = build_csp(policy, secure_transport: secure_transport)
        headers["Permissions-Policy"] = policy.fetch("permissionsPolicy").map { |f| "#{f}=()" }.join(",")
        headers["X-Robots-Tag"] = "noindex, nofollow"
      end

      headers["ETag"] = etag if etag

      if secure_transport
        hsts = policy.fetch("hsts")
        headers["Strict-Transport-Security"] = "max-age=#{hsts.fetch('maxAge')}; includeSubDomains"
      end

      if %w[download sensitive-download].include?(kind)
        raise ArgumentError, "filename is required for download kinds" if filename.blank?
        raise ArgumentError, "filename must be a single path segment" if filename.match?(%r{[/\\\r\n]})

        headers["Content-Disposition"] = %(attachment; filename="#{filename}")
      end

      headers
    end

    def build_csp(policy, secure_transport:)
      directives = policy.fetch("csp").fetch("directives").transform_values(&:dup)
      script_src = directives["script-src"] ||= ["'self'"]
      script_hash = js_enabled_script_hash
      quoted = script_hash.start_with?("'") ? script_hash : "'#{script_hash}'"
      script_src << quoted unless script_src.include?(quoted)

      parts = []
      directives.each do |name, values|
        if name == "upgrade-insecure-requests"
          parts << "upgrade-insecure-requests" if secure_transport
          next
        end
        parts << (values.empty? ? name : "#{name} #{values.join(' ')}")
      end
      parts.join("; ")
    end
  end
end
