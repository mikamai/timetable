/* global $, _ */

$(() => {
  $('select#time_off_typology').change(e => {
    const val = e.target.value;
    const isPaidLeave = val => val.toLowerCase() === 'paid leave';
    const isVacationOrSickLeave = val =>
      ['vacation', 'sick leave'].includes(val.toLowerCase());
    const hide = type => $(`#new_time_off_${type}`).addClass('d-none');
    const show = type => $(`#new_time_off_${type}`).removeClass('d-none');

    switch (true) {
      case isPaidLeave(val):
        hide('period');
        show('entry');
        break;
      case isVacationOrSickLeave(val):
        hide('entry');
        show('period');
        break;
      default:
        hide('period');
        hide('entry');
        break;
    }
  });
});
