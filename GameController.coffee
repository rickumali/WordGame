jQuery ->

  isDragging = false
  selectedFirstChar = false
  selectedSecondChar = false

  enterHandler = (ev) -> 
    if selectedSecondChar
      return
    $(this).addClass("highlighted")
    if selectedFirstChar
      fx = jQuery.data($(".first")[0], "data").x
      fy = jQuery.data($(".first")[0], "data").y
      cx = jQuery.data($(this)[0], "data").x
      cy = jQuery.data($(this)[0], "data").y
      drawbetween(fx, fy, cx, cy)

  leaveHandler = (ev) ->
    $(this).removeClass("highlighted")

  $("td").hover(enterHandler, leaveHandler)

  clickHandler = (ev) ->
    if !selectedFirstChar
      selectedFirstChar = true
      $(this).unbind("hover")
      $(this).addClass("first")
    else
      fx = jQuery.data($(".first")[0], "data").x
      fy = jQuery.data($(".first")[0], "data").y
      cx = jQuery.data($(this)[0], "data").x
      cy = jQuery.data($(this)[0], "data").y
      return if (fx == cx) && (fy == cy)
      if !selectedSecondChar && validshape(fx, fy, cx, cy)
        selectedSecondChar = true
        $("td").unbind("hover")
        $(this).addClass("second")
        w = lb.isWord(makeword(getletters(fx, fy, cx, cy)))
        console.log("Check: " + makeword(getletters(fx, fy, cx, cy)))
        if w != ""
          console.log("You found " + w) 
          lb.markWordFound(w)
          $("td.highlighted").addClass("found")
          $("td##{w}").addClass("found")
          if lb.allWordsFound()
            console.log("All words found! Hurray!")
        $("td.highlighted").removeClass("highlighted")
        $("td").removeClass("first")
        $("td").removeClass("second")
        selectedFirstChar = false
        selectedSecondChar = false
        $("td").hover(enterHandler, leaveHandler)
  $("td").click(clickHandler)

  mousemoveHandler = (ev) ->
    isDragging = true;
    $(window).unbind("mousemove");

  mouseDownHandler = (ev) ->
    console.log('Mouse is down')
    # NOTE: Repeated code used in clickHandler
    if !selectedFirstChar
      selectedFirstChar = true
      $(this).unbind("hover")
      $(this).addClass("first")
    $(window).mousemove(mousemoveHandler)

  mouseUpHandler = (ev) ->
    console.log('Mouse is up')
    wasDragging = isDragging
    isDragging = false
    $(window).unbind("mousemove");
    if (wasDragging)
      console.log('You were dragging')
      # NOTE: Repeated code used in clickHandler
      fx = jQuery.data($(".first")[0], "data").x
      fy = jQuery.data($(".first")[0], "data").y
      cx = jQuery.data($(this)[0], "data").x
      cy = jQuery.data($(this)[0], "data").y
      return if (fx == cx) && (fy == cy)
      if !selectedSecondChar && validshape(fx, fy, cx, cy)
        selectedSecondChar = true
        $("td").unbind("hover")
        $(this).addClass("second")
        w = lb.isWord(makeword(getletters(fx, fy, cx, cy)))
        console.log("Check: " + makeword(getletters(fx, fy, cx, cy)))
        if w != ""
          console.log("You found " + w)
          lb.markWordFound(w)
          $("td.highlighted").addClass("found")
          $("td##{w}").addClass("found")
          if lb.allWordsFound()
            console.log("All words found! Hurray!")
        $("td.highlighted").removeClass("highlighted")
        $("td").removeClass("first")
        $("td").removeClass("second")
        selectedFirstChar = false
        selectedSecondChar = false
        $("td").hover(enterHandler, leaveHandler)
    else
      console.log('You weren\'t dragging')
  
  $("td").mousedown(mouseDownHandler)
  $("td").mouseup(mouseUpHandler)

  getletters = (fx, fy, cx, cy) -> 
    if fx == cx
      if fy > cy
        return vertletters(cy, fy, fx)
      else if fy < cy
        return vertletters(fy, cy, fx)
    else if fy == cy
      if (fx > cx)
        fillhoriz(cx, fx, fy)
      else if fx < cx
        fillhoriz(fx, cx, fy)
    else if Math.abs(fx - cx) == Math.abs(fy - cy)
      if fx > cx
        filldiag(cx, fx, cy, cy - fy)
      else if fx < cx
        filldiag(fx, cx, fy, fy - cy)
    else
      $("td.highlighted:not(.first)").removeClass("highlighted")

  validshape = (fx, fy, cx, cy) -> 
    return (fx == cx) || (fy == cy) || (Math.abs(fx - cx) == Math.abs(fy - cy))

  drawbetween = (fx, fy, cx, cy) -> 
    if fx == cx
      if fy > cy
        fillvert(cy, fy, fx)
      else if fy < cy
        fillvert(fy, cy, fx)
    else if fy == cy
      if (fx > cx)
        fillhoriz(cx, fx, fy)
      else if fx < cx
        fillhoriz(fx, cx, fy)
    else if Math.abs(fx - cx) == Math.abs(fy - cy)
      if fx > cx
        filldiag(cx, fx, cy, cy - fy)
      else if fx < cx
        filldiag(fx, cx, fy, fy - cy)
    else
      $("td.highlighted:not(.first)").removeClass("highlighted")

  fillvert = (start, finish, x) -> 
    for i in [start...finish]
      b="td#"+index(x,i)
      $(b).addClass("highlighted")

  fillhoriz = (start, finish, y) -> 
    for i in [start...finish]
      b="td#"+index(i,y)
      $(b).addClass("highlighted")

  filldiag = (start, finish, y, y_diff) ->
    if y_diff < 0
      y_dir = 1
    else
      y_dir = -1
    for i in [start...finish]
      b="td#"+index(i,y)
      $(b).addClass("highlighted")
      y += y_dir

  vertletters = (start, finish, x) -> 
    lets = []
    for i in [start..finish]
      b="td#"+index(x,i)
      lets.push jQuery.data($(b)[0], "data").letter
    return lets

  index = (fx, fy) -> 
    return (fx + fy * lb.width)

  makeword = (lets) -> 
    word = ""
    for l in lets
      word += l
    return word
