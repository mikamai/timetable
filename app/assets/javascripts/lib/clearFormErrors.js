/* global $ */

$.fn.clearFormErrors = () => {
  $('.form-group', this).removeClass('has-error');
  $('span.help-block', this).remove();
};
