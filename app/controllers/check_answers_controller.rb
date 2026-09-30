# frozen_string_literal: true

class CheckAnswersController < ApplicationController
  def show
    application = current_application
    return redirect_to "/confirmation" if application.submitted

    incomplete = Licence::Steps.first_incomplete(application)
    return redirect_to incomplete.path if incomplete

    layout_assign(
      heading: "Check your answers",
      back_link: { "text" => "Back", "href" => "/email" },
      main_classes: "govuk-main-wrapper--l",
      personal: true
    )
    @summary_list = { "rows" => Licence::Answers.summary_rows(application) }
    @submit_button = { "text" => "Accept and continue" }
  end

  def create
    application = current_application
    return redirect_to "/confirmation" if application.submitted

    incomplete = Licence::Steps.first_incomplete(application)
    return redirect_to incomplete.path if incomplete

    application.submitted = true
    application.reference = Licence::Steps.reference_for(session.id.to_s.presence || "session")
    save_current_application(application)
    redirect_to "/confirmation"
  end
end
