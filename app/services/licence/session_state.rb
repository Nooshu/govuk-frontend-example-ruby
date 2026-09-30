# frozen_string_literal: true

module Licence
  module SessionState
    SESSION_APPLICATION = "application"
    SESSION_COOKIE_CHOICE = "cookie_choice"
    SESSION_COOKIE_BANNER = "cookie_banner"
    SESSION_NOTICE = "notice"
    SESSION_ERRORS = "errors"
    CHOICE_ACCEPT = "accept"
    CHOICE_REJECT = "reject"

    module_function

    def get_application(session)
      Application.from_h(session[SESSION_APPLICATION])
    end

    def save_application(session, application)
      session[SESSION_APPLICATION] = application.to_h
    end

    def clear_application(session)
      session[SESSION_APPLICATION] = Application.new.to_h
    end

    def get_cookie_choice(session)
      session[SESSION_COOKIE_CHOICE].to_s
    end

    def set_cookie_choice(session, choice)
      session[SESSION_COOKIE_CHOICE] = choice
    end

    def get_cookie_banner(session)
      session[SESSION_COOKIE_BANNER].to_s
    end

    def set_cookie_banner(session, value)
      session[SESSION_COOKIE_BANNER] = value
    end

    def get_notice(session)
      notice = session[SESSION_NOTICE]
      notice.is_a?(Hash) ? notice : nil
    end

    def set_notice(session, path, text)
      session[SESSION_NOTICE] = { "path" => path, "text" => text }
    end

    def clear_notice(session)
      session.delete(SESSION_NOTICE)
    end

    def pop_notice_for(session, path)
      notice = get_notice(session)
      return "" if notice.nil? || notice["path"] != path

      clear_notice(session)
      notice["text"].to_s
    end

    def set_errors(session, path, items)
      session[SESSION_ERRORS] = { "path" => path, "items" => items }
    end

    def clear_errors(session)
      session.delete(SESSION_ERRORS)
    end

    def pop_errors_for(session, path)
      raw = session[SESSION_ERRORS]
      return [] unless raw.is_a?(Hash) && raw["path"] == path

      clear_errors(session)
      Array(raw["items"]).filter_map do |item|
        next unless item.is_a?(Hash)

        {
          "field" => item["field"].to_s,
          "href" => item["href"].to_s,
          "text" => item["text"].to_s
        }
      end
    end
  end
end
