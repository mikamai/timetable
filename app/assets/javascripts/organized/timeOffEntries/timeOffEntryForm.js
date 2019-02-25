/* global $, _ */

$(() => {
  const showForm = val => {
    const hide = type => $(`#new_time_off_${type}`).addClass('d-none');
    const show = type => $(`#new_time_off_${type}`).removeClass('d-none');
    const set = (type, typology) =>
      $(`#time_off_${type}_typology`).val(typology);

    const typology = val.toLowerCase();

    switch (typology) {
      case 'paid':
        hide('period');
        show('entry');
        set('entry', 'paid');
        break;
      case 'vacation':
        hide('entry');
        show('period');
        set('period', 'vacation');
        break;
      case 'sick':
        hide('entry');
        show('period');
        set('period', 'sick');
        break;
      default:
        hide('period');
        hide('entry');
        break;
    }

    if (typology === 'sick') {
      $('#sick-only').removeClass('d-none');
    } else {
      $('#sick-only').addClass('d-none');
    }
  };

  $('select#time_off_typology').change(e => showForm(e.target.value));
  if ($('select#time_off_typology').length)
    showForm($('select#time_off_typology').val());

  $('input#time_off_entry_time_amount').on('focusout', e => {
    const $el = $(e.target);
    const val = $el.val();
    const match = val.match(/^(\d+)(:(\d+))?$/);
    if (match) {
      const hours = parseInt(match[1], 10);
      const minutes = parseInt(match[3] || '0', 10);
      $el.val(`${hours}:${_.pad(minutes, 2, '0')}`);
    }
  });
});
