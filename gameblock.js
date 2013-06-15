$(document).ready(function() {

  var selectedFirstChar = false;
  var selectedSecondChar = false;

  $("td").hover(function() {
    $(this).addClass("green");
    console.log(jQuery.data($(this)[0], "data"));
  },function() {
    $(this).removeClass("green");
  });

  $("td").click(function() {
    if (!selectedFirstChar) {
      selectedFirstChar = true;
      $(this).unbind("hover");
    } else {
      if (!selectedSecondChar) {
        selectedSecondChar = true;
        $(this).unbind("hover");
	console.log("Evaluate the word, Rick!");
      }
    }
  });

});
