/* global $ */

const showError = ($el) => {
  $el.addClass('invisible');
  $('#unknown-error-during-report-entries-watch').removeClass('invisible');
};

const showExportResult = ($el, data) => {
  $el.addClass('invisible');
  $('#download-report-entries-export').removeClass('invisible');
  $('#download-report-entries-export .download-link').attr('href', data.file_url);
  triggerDownload();
};

const triggerDownload = url => (
  setTimeout(() => (
    $('body').append(`<iframe style="display: none" width="1" height="1" frameborder="0" src="${url}"></iframe>`)
  ), 1000)
);

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

$(() => {
  const $el = $('#download-report-entries-export');
  if (!$el.length) { return; }
  triggerDownload($('#download-report-entries-export a').attr('href'));
});
