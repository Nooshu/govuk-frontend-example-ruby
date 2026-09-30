# frozen_string_literal: true

class ComponentsController < ApplicationController
  def index
    return demos_disabled unless Rails.configuration.demos_enabled

    layout_assign(
      heading: "Component catalogue",
      breadcrumbs: Licence::Chrome.crumbs("Component catalogue")
    )
    @components = Govuk::Catalogue.all(Rails.configuration.govuk_components_dir)
  end

  def show
    return demos_disabled unless Rails.configuration.demos_enabled

    name = params[:name]
    names = Govuk::Fixtures.fixture_components(Rails.configuration.govuk_components_dir)
    return not_found_page unless names.include?(name)

    fixture_set = Govuk::Fixtures.load(Rails.configuration.govuk_components_dir, name)
    fixture = select_fixture(fixture_set.fixtures, params[:fixture].to_s)
    return not_found_page unless fixture

    rendered = Govuk.render(name, fixture.options)
    matches = rendered == fixture.html
    info = Govuk::Catalogue.describe(name)

    layout_assign(
      heading: info.title,
      back_link: { "text" => "Back", "href" => "/components" }
    )
    @component_name = name
    @component_title = info.title
    @design_system_url = info.design_system_url
    @description = fixture.description
    @description_inset = { "text" => fixture.description }
    @fixture_name = fixture.name
    @rendered = rendered.html_safe # rubocop:disable Rails/OutputSafety -- trusted renderer
    @parity = parity_banner(matches)
    @current_tag = { "text" => "Current" }
    @fixtures = fixture_set.fixtures.map { |item| { name: item.name, current: item.name == fixture.name } }
  end

  def fixture
    return demos_disabled_plain unless Rails.configuration.demos_enabled

    name = params[:name]
    names = Govuk::Fixtures.fixture_components(Rails.configuration.govuk_components_dir)
    return render(plain: "Not found", status: :not_found) unless names.include?(name)

    fixture_set = Govuk::Fixtures.load(Rails.configuration.govuk_components_dir, name)
    fixture = select_fixture(fixture_set.fixtures, params[:fixture].to_s)
    return render(plain: "Not found", status: :not_found) unless fixture

    set_baseline("document")
    render html: fixture.html.html_safe, layout: false # rubocop:disable Rails/OutputSafety -- official fixture HTML
  end

  private

  def select_fixture(fixtures, requested)
    if requested.present?
      return fixtures.find { |fixture| fixture.name == requested }
    end

    fixtures.find { |fixture| !fixture.hidden } || fixtures.first
  end

  def parity_banner(matches)
    if matches
      {
        "type" => "success",
        "titleText" => "HTML matches the fixture",
        "text" => "The Ruby output is the same as the official fixture HTML."
      }
    else
      {
        "titleText" => "HTML does not match the fixture",
        "text" => "The Ruby output is different from the official fixture HTML."
      }
    end
  end

  def demos_disabled
    not_found_page
  end

  def demos_disabled_plain
    render plain: "Not found", status: :not_found
  end

  def not_found_page
    layout_assign(heading: "Page not found")
    render "pages/not_found", status: :not_found
  end
end
