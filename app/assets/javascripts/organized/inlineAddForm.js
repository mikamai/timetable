/* global $ */

$(() => {
  $('form.inline-add-form')
    .on('ajax:success', (e) => {
      const [data] = e.detail;
      const $form = $(e.target);
      const $table = $($form.data('results-table'));
      const $tableItem = $(data.tableItem);
      $('tbody', $table).append($tableItem);
      $form.clearFormErrors();
      $form[0].reset();
    })
    .on('ajax:error', (e) => {
      const [data] = e.detail;
      const $form = $(e.target);
      const model = $form.data('model');
      if (data.errors) {
        $form.renderFormErrors(model, data.errors);
      } else {
        $form.replaceWith('<div class="alert alert-danger">Server error</div>');
      }
    });
});
