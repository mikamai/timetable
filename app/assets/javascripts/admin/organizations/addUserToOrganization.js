/* global $ */

$(() => {
  $('form#new_organization_member')
    .on('ajax:success', (e) => {
      const [data] = e.detail;
      const $form = $(e.target);
      const table = $($form.data('results-table'));
      const $tableItem = $(data.tableItem);
      $('tbody', table).append($tableItem);
    })
    .on('ajax:error', (e) => {
      const [data] = e.detail;
      const $form = $(e.target);
      $form.renderFormErrors('organization_member', data.errors);
    });
});
