/* global $ */

$.fn.renderFormErrors = function renderFormErrors(modelName, errors) {
  const $form = $(this);
  $form.clearFormErrors();

  $.each(errors, (field, messages) => {
    const input = $('input, select, textarea', $form).filter((i, el) => {
      const dataName = $(el).data('error-name');
      if (dataName && dataName.length > 0) {
        return dataName === field;
      }
      const name = $(el).attr('name');
      if (!name) return false;
      if (modelName) {
        return name.match(new RegExp(`${modelName}\\[${field}\\]`));
      }
      return name.match(new RegExp(`^${field}`));
    });
    input.closest('.form-group').addClass('has-error');
    const errorsHtml = $.map(messages, m => m.charAt(0).toUpperCase() + m.slice(1)).join('<br />');
    input.parent().append(`<span class="help-block">${errorsHtml}</span>`);
  });
};
