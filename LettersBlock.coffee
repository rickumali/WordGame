#
# LettersBlock
# 
class LettersBlock
  constructor: (@width, @height) ->
    @letters = []
    @words = []
    @words_found = {}
 
  # This will generate width * height letters into an array
  genrandomletters: ->
    count = @width * @height
    @letters = for x in [0..count] 
      x

  logletters: ->
    console.log @letters

  width: ->
    @width

  height: ->
    @height

  reverse: (s) -> 
    b = ""
    for i in [s.length-1..0]
      b += s[i]
    return b

  addword_vert: (word, first_x, first_y, direction, rev = false) ->
    y = first_y
    if rev
      word = @reverse(word)
    for l in word
      @letters[first_x + (y * @width)] = l
      if direction == "N"
        y--
      else if direction == "S"
        y++

  addword_horiz: (word, first_x, first_y, direction, rev = false) ->
    x = 0
    if rev
      word = @reverse(word)
    for l in word
      @letters[first_x + x + (first_y * @width)] = l
      if direction == "E"
        x--
      else if direction == "W"
        x++

  addword: (word, first_x, first_y, direction, rev) ->
    @words.push word
    @words_found[word] = false
    switch direction
      when "N"  then @addword_vert(word, first_x, first_y, direction, rev)
      when "NE" then console.log("NE not implemented")
      when "E"  then @addword_horiz(word, first_x, first_y, direction, rev)
      when "SE" then console.log("SE not implemented")
      when "S"  then @addword_vert(word, first_x, first_y, direction, rev)
      when "SW" then console.log("SW not implemented")
      when "W"  then @addword_horiz(word, first_x, first_y, direction, rev)
      when "NW" then console.log("NW not implemented")
      else           console.log("Wrong!")

  # Gets the letter at row y, and column x
  # We should assume the caller won't use a value greater
  # than the @width or @height
  letter: (x, y) ->
    @letters[x + (y * @width)]

  isWord: (wrd) -> 
    for word in @words
      if word == wrd || @reverse(word) == wrd
        return word
    return ""

  markWordFound: (wrd) -> 
    @words_found[wrd] = true

  allWordsFound: -> 
    for word in @words
      if !@words_found[word]
        return false
    return true

lb = new LettersBlock(10,10)
lb.genrandomletters()
lb.addword("summer", 2, 8, "N", false)
lb.addword("fall", 3, 0, "S", true)
lb.addword("winter", 5, 3, "S", true)
lb.addword("spring", 0, 9, "W", false)
lb.addword("ate", 9, 9, "E", true)

# This puts the lb object on the 'window', making it available 
# for other scripts to use.
window.lb = lb

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
