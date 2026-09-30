# frozen_string_literal: true

module Licence
  module Steps
    module_function

    def all
      STEPS
    end

    def optional?(step_id)
      OPTIONAL_STEPS.include?(step_id)
    end

    def by_id(step_id)
      STEPS.find { |s| s.id == step_id }
    end

    def by_path(path)
      STEPS.find { |s| s.path == path }
    end

    def next_after(step_id)
      index = STEPS.index { |s| s.id == step_id }
      return nil if index.nil? || index + 1 >= STEPS.length

      STEPS[index + 1]
    end

    def previous_before(step_id)
      index = STEPS.index { |s| s.id == step_id }
      return nil if index.nil? || index <= 0

      STEPS[index - 1]
    end

    def mark_completed(completed, step_id)
      return completed.dup if completed.include?(step_id)

      completed + [step_id]
    end

    def unmark_completed(completed, step_id)
      completed.reject { |item| item == step_id }
    end

    def required_complete?(application)
      STEPS.all? { |step| optional?(step.id) || application.completed?(step.id) }
    end

    def first_incomplete(application)
      STEPS.find { |step| !optional?(step.id) && !application.completed?(step.id) }
    end

    def reference_for(session_key)
      prefix = session_key.to_s[0, 6].to_s
      "RL#{prefix.upcase}"
    end
  end
end
