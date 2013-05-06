//= require twitter/bootstrap
//= require jquery_ujs
//= require jquery-ui
//= require bootstrapx-clickover
//= require jqBootstrapValidation
//= require jquery.autosize
//= require fine-uploader/jquery.fineuploader
//= require releases
//= require imports

$(function(){
  // $('a').clickover({ html : true, global_close: false });
  $(".release-tracks").sortable({ handle: ".release-track-handle" });
  $('textarea').autosize();
});