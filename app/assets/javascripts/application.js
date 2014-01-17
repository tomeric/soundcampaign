//= require twitter/bootstrap
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require jquery.ui.sortable
//= require jquery.ui.datepicker
//= require bootstrapx-clickover
//= require jqBootstrapValidation
//= require jquery.autosize
//= require fine-uploader/jquery.fineuploader
//= require d3
//= require covers
//= require releases
//= require imports
//= require release
//= require metrics
//= require bootstrap-select.min

$(function(){
  // $('a').clickover({ html : true, global_close: false });
  $(".release-tracks").sortable({ handle: ".release-track-handle" });
  $('textarea').autosize();
  $('.selectpicker').selectpicker();
  $('.release-list-add').on('click', function(){
    $(".release-list").append('<div class="release-list-select"><div class="release-list-select-icon"></div><div class="release-list-select-date"><input type="text" value="Select date" class="datepicker_recurring_start" /></div><div class="release-list-select-time"><input type="text" value="12:30" /></div><div class="release-list-select-list"><select class="select selectpicker" title="Select contactlist"><option></option><option>Blue</option><option>Red</option><option>Green</option><option>Yellow</option><option>Brown</option></select></div><div class="release-list-select-del"></div></div>')
    $('.selectpicker').selectpicker();
  });
  $('body').on('focus',".datepicker_recurring_start", function(){
    $(this).datepicker();
  });
});