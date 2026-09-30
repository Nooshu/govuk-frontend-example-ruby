# frozen_string_literal: true

module Govuk
  CatalogueEntry = Struct.new(:name, :title, :description, :design_system_url, keyword_init: true)

  module Catalogue
    module_function

    DESIGN_SYSTEM = "https://design-system.service.gov.uk/components"

    DETAILS = {
      "accordion" => ["Accordion", "Lets users show and hide sections of related content.", "#{DESIGN_SYSTEM}/accordion/"],
      "back-link" => ["Back link", "Link to the previous page in a journey.", "#{DESIGN_SYSTEM}/back-link/"],
      "breadcrumbs" => ["Breadcrumbs", "Helps users move between levels of a section.", "#{DESIGN_SYSTEM}/breadcrumbs/"],
      "button" => ["Button", "Starts or continues an action.", "#{DESIGN_SYSTEM}/button/"],
      "character-count" => ["Character count", "Shows how many characters are left in a textarea.", "#{DESIGN_SYSTEM}/character-count/"],
      "checkboxes" => ["Checkboxes", "Lets users select one or more options.", "#{DESIGN_SYSTEM}/checkboxes/"],
      "cookie-banner" => ["Cookie banner", "Asks users to accept or reject analytics cookies.", "#{DESIGN_SYSTEM}/cookie-banner/"],
      "date-input" => ["Date input", "Asks users for a date they already know.", "#{DESIGN_SYSTEM}/date-input/"],
      "details" => ["Details", "Hides content that only some users need.", "#{DESIGN_SYSTEM}/details/"],
      "error-message" => ["Error message", "Tells users how to fix a field that failed validation.", "#{DESIGN_SYSTEM}/error-message/"],
      "error-summary" => ["Error summary", "Summarises form errors at the top of the page.", "#{DESIGN_SYSTEM}/error-summary/"],
      "exit-this-page" => ["Exit this page", "Lets users leave a page quickly. For services where someone may be in danger.",
                           "#{DESIGN_SYSTEM}/exit-this-page/"],
      "feedback" => ["Feedback", "Asks users what they think of a page. Trial component in Frontend 6.5.", "#{DESIGN_SYSTEM}/feedback/"],
      "fieldset" => ["Fieldset", "Groups related form fields, such as an address.", "#{DESIGN_SYSTEM}/fieldset/"],
      "file-upload" => ["File upload", "Lets users select a file to upload.", "#{DESIGN_SYSTEM}/file-upload/"],
      "footer" => ["Footer", "Page footer with Open Government Licence and Crown copyright.", "#{DESIGN_SYSTEM}/footer/"],
      "generic-header" => ["Generic header", "Header for services that are not branded as GOV.UK.", "https://design-system.service.gov.uk/styles/page-template/"],
      "header" => ["Header", "The GOV.UK masthead.", "#{DESIGN_SYSTEM}/header/"],
      "hint" => ["Hint", "Extra help for a form field.", "https://design-system.service.gov.uk/get-started/labels-legends-headings/"],
      "input" => ["Text input", "Lets users enter a single line of text.", "#{DESIGN_SYSTEM}/text-input/"],
      "inset-text" => ["Inset text", "Highlights secondary content.", "#{DESIGN_SYSTEM}/inset-text/"],
      "label" => ["Label", "Labels a form field.", "https://design-system.service.gov.uk/get-started/labels-legends-headings/"],
      "language-navigation" => ["Language navigation", "Lets users switch language.", "https://design-system.service.gov.uk/patterns/multilingual-websites/"],
      "notification-banner" => ["Notification banner", "Highlights important information.", "#{DESIGN_SYSTEM}/notification-banner/"],
      "pagination" => ["Pagination", "Navigation between pages of content.", "#{DESIGN_SYSTEM}/pagination/"],
      "panel" => ["Panel", "Shows a confirmation or important message.", "#{DESIGN_SYSTEM}/panel/"],
      "password-input" => ["Password input", "Lets users enter a password.", "#{DESIGN_SYSTEM}/password-input/"],
      "phase-banner" => ["Phase banner", "Shows the service phase and feedback link.", "#{DESIGN_SYSTEM}/phase-banner/"],
      "radios" => ["Radios", "Lets users select one option from a list.", "#{DESIGN_SYSTEM}/radios/"],
      "select" => ["Select", "Lets users choose from a dropdown list.", "#{DESIGN_SYSTEM}/select/"],
      "service-navigation" => ["Service navigation", "Navigation for a service.", "#{DESIGN_SYSTEM}/service-navigation/"],
      "skip-link" => ["Skip link", "Lets keyboard users skip to main content.", "#{DESIGN_SYSTEM}/skip-link/"],
      "summary-list" => ["Summary list", "Summarises answers and lets users change them.", "#{DESIGN_SYSTEM}/summary-list/"],
      "table" => ["Table", "Presents data in rows and columns.", "#{DESIGN_SYSTEM}/table/"],
      "tabs" => ["Tabs", "Lets users switch between related sections.", "#{DESIGN_SYSTEM}/tabs/"],
      "tag" => ["Tag", "Highlights status.", "#{DESIGN_SYSTEM}/tag/"],
      "task-list" => ["Task list", "Shows tasks users need to complete.", "#{DESIGN_SYSTEM}/task-list/"],
      "textarea" => ["Textarea", "Lets users enter multiple lines of text.", "#{DESIGN_SYSTEM}/textarea/"],
      "warning-text" => ["Warning text", "Highlights a warning.", "#{DESIGN_SYSTEM}/warning-text/"]
    }.freeze

    def describe(name)
      title, description, url = DETAILS[name]
      unless title
        title = name.split("-").map(&:capitalize).join(" ")
        description = "GOV.UK Frontend component."
        url = "#{DESIGN_SYSTEM}/#{name}/"
      end
      CatalogueEntry.new(name: name, title: title, description: description, design_system_url: url)
    end

    def all(components_dir)
      Fixtures.fixture_components(components_dir).map { |name| describe(name) }
    end
  end
end
