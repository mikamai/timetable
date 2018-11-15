/* global $, _ */

$(() => {
  $('select#time_off_entry_typology').change(e => {
    const val = e.target.value;
    const isPaidLeave = val => val.toLowerCase() === 'paid leave';
    const isHolidayOrSickLeave = val =>
      ['holiday', 'sick leave'].includes(val.toLowerCase());
    const hide = type => $(`#${type}-fields`).addClass('d-none');
    const show = type => $(`#${type}-fields`).removeClass('d-none');

    switch (true) {
      case isPaidLeave(val):
        hide('holiday');
        show('leave');
        break;
      case isHolidayOrSickLeave(val):
        hide('leave');
        show('holiday');
        break;
      default:
        hide('holiday');
        hide('leave');
        break;
    }
  });
});
