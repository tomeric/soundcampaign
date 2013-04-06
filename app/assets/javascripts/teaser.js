$(function () { 
  $("#form1").addClass("animated fadeInDown");
  $(".teasersubmit").click(function() {
    $("#form1").removeClass("fadeInDown").addClass("fadeOutDown");
    setTimeout(function() {
      $("#form1").hide();
    }, 1000);
    
    $("#form2").show().addClass("animated fadeInDown");
  });
});