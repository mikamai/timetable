/* global $ */

$.fn.clearFormErrors = function clearFormErrors() {
  $('.form-group', this).removeClass('has-error');
  $('span.help-block', this).remove();
};
