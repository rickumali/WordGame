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
      fx = jQuery.data($(".first")[0], "data").x;
      fy = jQuery.data($(".first")[0], "data").y;
      cx = jQuery.data($(this)[0], "data").x;
      cy = jQuery.data($(this)[0], "data").y;
      if (!selectedSecondChar && validshape(fx, fy, cx, cy)) {
        selectedSecondChar = true;
        $("td").unbind("hover");
        $(this).addClass("second");
	console.log("Evaluate the word, Rick!");
      }
    }
  });

  function validshape(fx, fy, cx, cy) {
    return (fx == cx) || (fy == cy) || (Math.abs(fx - cx) == Math.abs(fy - cy));
  }

  function drawbetween(fx, fy, cx, cy) {
    if (fx == cx) {
      console.log("UP or DOWN");
      if (fy > cy) {
        fillvert(cy, fy, fx);
      } else if (fy < cy) {
        fillvert(fy, cy, fx);
      }
    } else if (fy == cy) {
      console.log("LEFT OR RIGHT");
      if (fx > cx) {
        fillhoriz(cx, fx, fy);
      } else if (fx < cx) {
        fillhoriz(fx, cx, fy);
      }
    } else if (Math.abs(fx - cx) == Math.abs(fy - cy)) {
      console.log("DIAGNOL");
      if (fx > cx) {
        filldiag(cx, fx, cy, (cy - fy));
      } else if (fx < cx) {
        filldiag(fx, cx, fy, (fy - cy));
      }
    } else {
      $("td.green:not(.first)").removeClass("green");
    }
  }

  function fillvert(start, finish, x) {
    for (i = start; i < finish; i++) {
      b="td#"+index(x,i);
      $(b).addClass("green");
    }
  }

  function fillhoriz(start, finish, y) {
    for (i = start; i < finish; i++) {
      b="td#"+index(i,y);
      $(b).addClass("green");
    }
  }

  function filldiag(start, finish, y, y_diff) {
    if (y_diff < 0) {
      y_dir = 1;
    } else {
      y_dir = -1;
    }
    for (i = start; i < finish; i++, y += y_dir) {
      b="td#"+index(i,y);
      $(b).addClass("green");
    }
  }

  function index(fx, fy) {
    // TODO: This doesn't work! Too bad! I have to figure 
    // out how to get the LetterBlock object from in here.
    // return (fx + fy * lb.width());
    return (fx + fy * 10);
  }

});
