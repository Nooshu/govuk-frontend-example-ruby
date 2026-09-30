# frozen_string_literal: true

class StartController < ApplicationController
  def show
    lang = params[:lang].presence || "en"
    welsh = lang == "cy"

    pick = ->(en, cy) { welsh ? cy : en }
    heading = pick.call("Apply for a rod fishing licence", "Gwneud cais am drwydded bysgota")
    layout_assign(heading: heading, lang: lang, show_feedback: true)

    @lede = pick.call(
      "Use this service to apply for a licence to fish with a rod.",
      "Defnyddiwch y gwasanaeth hwn i wneud cais am drwydded i bysgota gyda gwialen."
    )
    @timing = pick.call("Applying takes about 10 minutes.", "Mae’n cymryd tua 10 munud.")
    @start_button = {
      "text" => pick.call("Start now", "Dechrau nawr"),
      "href" => "/task-list",
      "isStartButton" => true
    }
    @notification = {
      "titleText" => pick.call("Important", "Pwysig"),
      "text" => pick.call(
        "The 2026 to 2027 rod licence is now available.",
        "Mae trwydded gwialen 2026 i 2027 ar gael nawr."
      )
    }
    @warning = {
      "text" => pick.call(
        "You must have a valid rod licence before you fish.",
        "Rhaid i chi gael trwydded gwialen ddilys cyn i chi bysgota."
      ),
      "iconFallbackText" => pick.call("Warning", "Rhybudd")
    }
    @inset = {
      "text" => pick.call(
        "You need to be 13 or over. This example does not take payment.",
        "Mae gweddill yr enghraifft hon yn Saesneg."
      )
    }
    details_html = pick.call(
      '<ul class="govuk-list govuk-list--bullet"><li>Your name</li><li>Your date of birth</li><li>Your address</li></ul>',
      '<ul class="govuk-list govuk-list--bullet"><li>Eich enw</li><li>Eich dyddiad geni</li><li>Eich cyfeiriad</li></ul>'
    )
    @details = {
      "summaryText" => pick.call("What you will need", "Beth fydd ei angen arnoch"),
      "html" => Govuk::Safe.new(details_html)
    }
  end

  def new_application
    Licence::SessionState.clear_application(session)
    Licence::SessionState.clear_errors(session)
    redirect_to "/"
  end
end
