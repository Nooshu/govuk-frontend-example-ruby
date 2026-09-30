# frozen_string_literal: true

require "pathname"

module Govuk
  Fixture = Struct.new(:name, :options, :hidden, :description, :html, keyword_init: true)
  FixtureSet = Struct.new(:component, :fixtures, keyword_init: true)

  module Fixtures
    module_function

    def fixture_components(components_dir)
      root = Pathname.new(components_dir)
      names = []
      root.children.sort_by(&:basename).each do |entry|
        next unless entry.directory?
        next unless entry.join("fixtures.json").file?

        names << entry.basename.to_s
      end
      names
    rescue Errno::ENOENT => e
      raise "govuk: reading #{root}: #{e}"
    end

    def load(components_dir, component)
      path = Pathname.new(components_dir).join(component, "fixtures.json")
      raw = path.read(encoding: "UTF-8")
      data = Params.parse_json(raw)
      raise "govuk: parsing #{path}: expected a JSON object" unless data.is_a?(Params)

      component_name = data.get("component")
      component_name = if Nunjucks.undefined?(component_name) || component_name.nil?
                         component
                       else
                         component_name.to_s
                       end

      fixtures = []
      Nunjucks.items(data.get("fixtures")).each do |item|
        next unless item.is_a?(Params)

        options = item.get("options")
        options = Params.new unless options.is_a?(Params)

        hidden = item.get("hidden")
        hidden = false unless [true, false].include?(hidden)

        name = item.get("name")
        description = item.get("description")
        html = item.get("html")
        fixtures << Fixture.new(
          name: Nunjucks.undefined?(name) || name.nil? ? "" : name.to_s,
          options: options,
          hidden: hidden,
          description: Nunjucks.undefined?(description) || description.nil? ? "" : description.to_s,
          html: Nunjucks.undefined?(html) || html.nil? ? "" : html.to_s
        )
      end

      FixtureSet.new(component: component_name, fixtures: fixtures)
    rescue Errno::ENOENT => e
      raise "govuk: reading #{path}: #{e}"
    end
  end
end
