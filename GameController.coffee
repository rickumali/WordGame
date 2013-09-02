# See: http://aaronrussell.co.uk/articles/using-coffeescript-with-jquery/
#
# to see where I first learned about "jQuery ->" and CoffeeScript.
#
# What this syntax does is place the code in the lines following "jQuery ->"
# in jQuery's ready() method. See:
#
# http://api.jquery.com/ready/
#
# Examine the resulting JavaScript file, and you'll hopefully "get it."
jQuery ->
  lb.genrandomletters()
  lb.addword("summer", 2, 8, "N", false)
  lb.addword("fall", 3, 0, "S", true)
  lb.addword("winter", 5, 3, "S", true)
  lb.addword("spring", 0, 9, "W", false)
  lb.addword("ate", 9, 9, "E", true)
  lb.addword("snow", 6, 3, "NE", false)
  lb.addword("leaf", 9, 7, "NW", false)
  lb.addword("fir", 0, 1, "SE", false)
  lb.addword("mop", 2, 5, "SW", false)
  
  $('#game_block').append('<table></table>')

  for y in [0...lb.height]
    $('table').append('<tr>')

    for x in [0...lb.width]
      tot = x + y * lb.width
      $('tbody tr:last-child').append('<td>')
      td = $('tbody tr:last-child td:last-child')
      td.append(lb.letter(x, y))
      td.attr('id', tot)
      jQuery.data(td[0], "data", { x: x, y: y, letter: lb.letter(x,y) })

  $('#word_list').append('<table></table>')
  for w in lb.words
    $('#word_list table').append("<tr><td id=\"#{w}\">#{w}")

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
        return horizletters(cx, fx, fy)
      else if fx < cx
        return horizletters(fx, cx, fy)
    else if Math.abs(fx - cx) == Math.abs(fy - cy)
      if fx > cx
        return diagletters(cx, fx, cy, cy - fy)
      else if fx < cx
        return diagletters(fx, cx, fy, fy - cy)

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
    for i in [start..finish]
      b="td#"+index(i,y)
      $(b).addClass("highlighted")
      y += y_dir

  vertletters = (start, finish, x) -> 
    lets = []
    for i in [start..finish]
      b="td#"+index(x,i)
      lets.push jQuery.data($(b)[0], "data").letter
    return lets

  horizletters = (start, finish, y) -> 
    lets = []
    for i in [start..finish]
      b="td#"+index(i, y)
      lets.push jQuery.data($(b)[0], "data").letter
    return lets

  diagletters = (start, finish, y, y_diff) ->
    lets = []
    if y_diff < 0
      y_dir = 1
    else
      y_dir = -1
    for i in [start..finish]
      b="td#"+index(i,y)
      lets.push jQuery.data($(b)[0], "data").letter
      y += y_dir
    return lets

  index = (fx, fy) -> 
    return (fx + fy * lb.width)

  makeword = (lets) -> 
    word = ""
    for l in lets
      word += l
    return word
