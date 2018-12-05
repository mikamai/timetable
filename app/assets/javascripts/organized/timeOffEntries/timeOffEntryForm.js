/* global $, _ */

$(() => {
  $('select#time_off_typology').change(e => {
    const val = e.target.value;

    const isPaidLeave = val => val.toLowerCase() === 'paid leave';
    const isVacation = val => val.toLowerCase() === 'vacation';
    const isSickLeave = val => val.toLowerCase() === 'sick leave';

    const hide = type => $(`#new_time_off_${type}`).addClass('d-none');
    const show = type => $(`#new_time_off_${type}`).removeClass('d-none');
    const set = (type, typology) =>
      $(`#time_off_${type}_typology`).val(typology);

    switch (true) {
      case isPaidLeave(val):
        hide('period');
        show('entry');
        set('entry', 'paid');
        break;
      case isVacation(val):
        hide('entry');
        show('period');
        set('period', 'vacation');
        break;
      case isSickLeave(val):
        hide('entry');
        show('period');
        set('period', 'sick');
        break;
      default:
        hide('period');
        hide('entry');
        break;
    }
  });

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
