# frozen_string_literal: true

class TaskListController < ApplicationController
  def show
    application = current_application
    layout_assign(
      heading: "Your application",
      back_link: { "text" => "Back", "href" => "/" },
      personal: true
    )
    @sections = Licence::Answers.task_sections(application).map do |section|
      {
        heading: section.heading,
        id_prefix: section.id_prefix,
        task_list: { "idPrefix" => section.id_prefix, "items" => section.items }
      }
    end
  end
end
