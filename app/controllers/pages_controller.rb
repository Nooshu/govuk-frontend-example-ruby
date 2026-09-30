# frozen_string_literal: true

class PagesController < ApplicationController
  def fees
    layout_assign(heading: "Licence fees", breadcrumbs: Licence::Chrome.crumbs("Licence fees"))
    @table = Licence::GovukOptions.fees_table
  end

  def help
    layout_assign(heading: "Help", show_feedback: true, breadcrumbs: Licence::Chrome.crumbs("Help"))
    @accordion = Licence::GovukOptions.help_accordion
  end

  def guidance
    layout_assign(heading: "Guidance", breadcrumbs: Licence::Chrome.crumbs("Guidance"))
    @tabs = Licence::GovukOptions.guidance_tabs
  end

  def updates
    requested = params[:page].to_s
    return redirect_to "/updates" unless ["", "1", "2"].include?(requested)

    page = requested == "2" ? 2 : 1
    pagination = {
      "items" => [
        { "number" => 1, "href" => "/updates", "current" => page == 1 },
        { "number" => 2, "href" => "/updates?page=2", "current" => page == 2 }
      ]
    }
    pagination["previous"] = { "href" => "/updates" } if page > 1
    pagination["next"] = { "href" => "/updates?page=2" } if page < 2
    @body = if page == 2
              "There are no further fee changes planned in this example."
            else
              "Example fees for the 2026 to 2027 season are on the fees page."
            end
    layout_assign(heading: "Service updates", breadcrumbs: Licence::Chrome.crumbs("Service updates"))
    @pagination = pagination
  end

  def accessibility
    layout_assign(
      heading: "Accessibility statement",
      show_feedback: true,
      breadcrumbs: Licence::Chrome.crumbs("Accessibility statement")
    )
  end

  def about
    layout_assign(
      heading: "About this example",
      show_feedback: true,
      breadcrumbs: Licence::Chrome.crumbs("About this example")
    )
  end

  def examples
    return not_found_page unless Rails.configuration.demos_enabled

    layout_assign(heading: "Example pages", breadcrumbs: Licence::Chrome.crumbs("Example pages"))
  end

  def exit_this_page
    return not_found_page unless Rails.configuration.demos_enabled

    layout_assign(
      heading: "Exit this page",
      back_link: { "text" => "Back", "href" => "/examples" },
      exit_this_page: { "redirectUrl" => "https://www.bbc.co.uk/weather" }
    )
    @warning = {
      "text" => "Use this component only on services where someone may be in danger.",
      "iconFallbackText" => "Warning"
    }
    @inset = {
      "text" =>
        "This page is an example of the component. It is not part of the rod licence " \
        "application. Choosing the button leaves this example and opens the BBC weather forecast."
    }
  end

  def unavailable
    return not_found_page unless Rails.configuration.demos_enabled

    layout_assign(
      heading: "Sorry, the service is unavailable",
      back_link: { "text" => "Back", "href" => "/examples" }
    )
  end

  def problem
    return not_found_page unless Rails.configuration.demos_enabled

    layout_assign(heading: "Sorry, there is a problem with the service")
  end

  def not_found
    not_found_page
  end

  private

  def not_found_page
    layout_assign(heading: "Page not found")
    render "pages/not_found", status: :not_found
  end
end
