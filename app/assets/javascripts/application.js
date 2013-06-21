//= require twitter/bootstrap
//= require jquery_ujs
//= require jquery.ui.sortable
//= require bootstrapx-clickover
//= require jqBootstrapValidation
//= require jquery.autosize
//= require fine-uploader/jquery.fineuploader
//= require releases
//= require imports
//= require release

$(function(){
  // $('a').clickover({ html : true, global_close: false });
  $(".release-tracks").sortable({ handle: ".release-track-handle" });
  $('textarea').autosize();
  $('.star').raty({ path: '/assets/icons/' });
});