// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// Don't include regular jQuery as we are loading it in the view from MaxCDN. Just include jquery_ujs library after.
//= require jquery_ujs

// JS Stuff for the login form (Public#index)
function clearText(field) {
  if (field.defaultValue == field.value) field.value = '';
  else if (field.value === '') field.value = field.defaultValue;
}
$(document).ready(function() {
  $('#forgot').click(function (){
    $('form#new_session').hide();
    $('#recover').show();
  });
  $('#cancel').click(function() {
    $('#recover').hide();
    $('form#new_session').show();
  });
    $('.sortable').tablesorter();
});
