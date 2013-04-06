$(function () { 
  $('#subscribe').addClass('animated fadeInDown');
  $('#thanks').addClass('animated fadeInDown');
  $('#subscribe form').submit(function() {
    $('#subscribe').removeClass('fadeInDown').addClass('fadeOutDown');
  })
});