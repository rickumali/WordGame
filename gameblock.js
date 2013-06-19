$(document).ready(function() {

  var selectedFirstChar = false;
  var selectedSecondChar = false;

  $("td").hover(function() {
    if (selectedSecondChar) {
      return;
    }
    $(this).addClass("green");
    if (selectedFirstChar) {
      console.log("1   X: " + jQuery.data($(".first")[0], "data").x);
      console.log("1   Y: " + jQuery.data($(".first")[0], "data").y);
      console.log("CUR X: " + jQuery.data($(this)[0], "data").x);
      console.log("CUR Y: " + jQuery.data($(this)[0], "data").y);
    }
  },function() {
    $(this).removeClass("green");
  });

  $("td").click(function() {
    if (!selectedFirstChar) {
      selectedFirstChar = true;
      $(this).unbind("hover");
      $(this).addClass("first");
    } else {
      if (!selectedSecondChar) {
        selectedSecondChar = true;
        $(this).unbind("hover");
        $(this).addClass("second");
	console.log("Evaluate the word, Rick!");
      }
    }
  });

});
