# frozen_string_literal: true

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/health", to: "health#show"
  get "/robots.txt", to: "robots#show"
  get "/assets/*path", to: "assets#show", format: false

  root "start#show"
  get "/cy", to: "start#show", defaults: { lang: "cy" }
  get "/new-application", to: "start#new_application"

  journey_steps = %w[
    licence-length name date-of-birth where-you-will-fish email
  ]
  journey_steps.each do |step|
    get "/#{step}", to: "journey#show", defaults: { step: step }
    post "/#{step}", to: "journey#update", defaults: { step: step }
  end

  get "/check-answers", to: "check_answers#show"
  post "/check-answers", to: "check_answers#create"
  get "/confirmation", to: "confirmation#show"

  get "/fees", to: "pages#fees"
  get "/help", to: "pages#help"
  get "/guidance", to: "pages#guidance"
  get "/updates", to: "pages#updates"
  get "/accessibility", to: "pages#accessibility"
  get "/about", to: "pages#about"

  get "/cookies", to: "cookies#show"
  post "/cookies", to: "cookies#update"
  post "/cookie-choices", to: "cookies#choices"

  get "/examples", to: "pages#examples"
  get "/examples/exit-this-page", to: "pages#exit_this_page"
  get "/examples/service-unavailable", to: "pages#unavailable"
  get "/examples/problem-with-the-service", to: "pages#problem"

  if Rails.application.config.demos_enabled
    get "/components", to: "components#index"
    get "/components/:name", to: "components#show", constraints: { name: /[a-z0-9-]+/ }
    get "/components/:name/fixture", to: "components#fixture", constraints: { name: /[a-z0-9-]+/ }
  end

  match "*unmatched", to: "pages#not_found", via: :all
end
