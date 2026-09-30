# frozen_string_literal: true

class ConfirmationController < ApplicationController
  def show
    application = current_application
    return redirect_to "/task-list" unless application.submitted

    layout_assign(heading: "Application complete", show_feedback: true, personal: true)
    @panel = Licence::GovukOptions.confirmation_panel(application.reference)
  end
end
