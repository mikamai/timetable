# frozen_string_literal: true

module ApplicationHelper
  def inline_add_form_for model, results_table, &block
    model_name = Array.wrap(model).last.class.model_name.param_key.inspect
    bootstrap_form_for model,
                       remote: true,
                       data:   { type: 'json', results_table: results_table, model: model_name },
                       layout: :inline,
                       html:   { class: 'inline-add-form justify-content-end' },
                       &block
  end
end
