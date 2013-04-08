//= require twitter/bootstrap
//= require jquery_ujs
//= require bootstrapx-clickover
//= require jqBootstrapValidation
//= require jquery.autosize

$(function(){
  $('a').clickover({ html : true, global_close: false });
  
  $('textarea').autosize();
});