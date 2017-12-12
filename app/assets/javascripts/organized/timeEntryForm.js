/* global $ */

$(() => {
  $('select#time_entry_project_id[data-fetch-api]').change((e) => {
    const $el = $(e.target);
    const url = $el.data('fetch-api').replace(/:project/, $el.val());
    const $form = $el.parents('form');
    const $tagSelect = $('select#time_entry_task_id', $form);

    $tagSelect.empty().append('<option>Loading ...</option>').attr('disabled', 'true');
    $.ajax({
      url,
      dataType: 'json',
    }).done((data) => {
      $tagSelect
        .empty()
        .append(data.tasks.map(t => `<option value='${t.id}'>${t.name}</option>`))
        .removeAttr('disabled');
    });
  });
});
