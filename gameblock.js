$(document).ready(function() {

  var selectedFirstChar = false;
  var selectedSecondChar = false;

  $("td").hover(function() {
    if (selectedSecondChar) {
      return;
    }
    $(this).addClass("green");
    if (selectedFirstChar) {
      fx = jQuery.data($(".first")[0], "data").x;
      fy = jQuery.data($(".first")[0], "data").y;
      cx = jQuery.data($(this)[0], "data").x;
      cy = jQuery.data($(this)[0], "data").y;
      drawbetween(fx, fy, cx, cy);
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

  function drawbetween(fx, fy, cx, cy) {
    if (fx == cx) {
      console.log("UP or DOWN");
      // TODO: I'll come up with some better or more clever
      if (fy > cy) {
        for (i = cy; i < fy; i++) {
          b="td#"+index(fx,i);
          $(b).addClass("green");
        }
      } else if (fy < cy) {
      }
    } else if (fy == cy) {
      console.log("LEFT OR RIGHT");
    } else if (Math.abs(fx - cx) == Math.abs(fy - cy)) {
      console.log("DIAGNOL");
    } else {
      $("td.green:not(.first)").removeClass("green");
    }
  }

  function index(fx, fy) {
    // TODO: This doesn't work! Too bad! I have to figure 
    // out how to get the LetterBlock object from in here.
    // return (fx + fy * lb.width());
    return (fx + fy * 10);
  }

});
