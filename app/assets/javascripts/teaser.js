//= require twitter/bootstrap
//= require jquery_ujs
//= require bootstrapx-clickover
//= require jqBootstrapValidation
//= require jquery.autosize

$(function () { 
  $('#subscribe').addClass('animated fadeInDown');
  $('#thanks').addClass('animated fadeInDown');
  $('#subscribe form').submit(function() {
    $('#subscribe').removeClass('fadeInDown').addClass('fadeOutDown');
  })
});