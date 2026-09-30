# frozen_string_literal: true

# Cookie store — no ActiveRecord / no database (matches free-tier demos).
Rails.application.config.session_store :cookie_store,
                                       key: "_rod_session",
                                       same_site: :lax,
                                       httponly: true,
                                       expire_after: 4.hours
