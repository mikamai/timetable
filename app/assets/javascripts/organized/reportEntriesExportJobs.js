/* global $ */

const showError = ($el) => {
  $el.addClass('invisible');
  $('#unknown-error-during-report-entries-watch').removeClass('invisible');
};

const showExportResult = ($el, _data) => {
  $el.addClass('invisible');
  $('#download-report-entries-export').removeClass('invisible');
};

const watchForCompletion = ($el) => {
  const url = $el.data('url');
  $.ajax({
    url,
    dataType: 'json',
  }).done((data) => {
    if (data.completed) {
      showExportResult($el, data);
      return;
    }
    setTimeout(() => watchForCompletion($el), 2000);
  }).fail(() => showError($el));
};

$(() => {
  const $el = $('#waiting-report-entries-export');
  if (!$el.length) { return; }
  watchForCompletion($el);
});
