# frozen_string_literal: true

class CookiesController < ApplicationController
  def show
    errors = errors_from_session("/cookies")
    notice = Licence::SessionState.pop_notice_for(session, "/cookies")
    layout_assign(
      heading: "Cookies",
      has_errors: errors.any?,
      personal: true,
      breadcrumbs: Licence::Chrome.crumbs("Cookies")
    )
    fields = Licence::GovukOptions.cookie_fields(Licence::SessionState.get_cookie_choice(session), errors)
    @radios = fields[:radios]
    @error_summary = Licence::GovukOptions.error_summary(errors)
    @notice = if notice.present?
                { "type" => "success", "titleText" => "Success", "text" => notice }
              end
    @save_button = { "text" => "Save cookie settings" }
  end

  def update
    analytics = params[:analytics].to_s
    errors = Licence::Validate.validate_cookie_choice(analytics)
    if errors.any?
      Licence::SessionState.set_errors(session, "/cookies", errors.map(&:as_dict))
      return redirect_to "/cookies"
    end

    choice = analytics == "yes" ? Licence::SessionState::CHOICE_ACCEPT : Licence::SessionState::CHOICE_REJECT
    Licence::SessionState.set_cookie_choice(session, choice)
    Licence::SessionState.set_cookie_banner(session, "")
    Licence::SessionState.clear_errors(session)
    Licence::SessionState.set_notice(session, "/cookies", "Your cookie settings were saved")
    redirect_to "/cookies"
  end

  def choices
    choice = params[:cookies].to_s
    if [Licence::SessionState::CHOICE_ACCEPT, Licence::SessionState::CHOICE_REJECT].include?(choice)
      Licence::SessionState.set_cookie_choice(session, choice)
      Licence::SessionState.set_cookie_banner(session, choice)
    elsif choice == "hide"
      Licence::SessionState.set_cookie_banner(session, "")
    end
    redirect_to Licence::Chrome.safe_return_path(params[:returnPath])
  end
end
