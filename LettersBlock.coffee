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

  addword_diag: (word, first_x, first_y, direction, rev = false) ->
    if rev
      word = @reverse(word)
    x = 0
    y = 0
    # Break apart the direction into north/south, and east/west
    vert = direction[0]
    horiz = direction[1]
    if vert == "N"
      y_dir = -1
    else if vert == "S"
      y_dir = 1
    if horiz == "E"
      x_dir = 1
    else if horiz == "W"
      x_dir = -1
    for l in word
      @letters[first_x + x + ((first_y + y) * @width )] = l
      x += x_dir
      y += y_dir

  addword: (word, first_x, first_y, direction, rev) ->
    @words.push word
    @words_found[word] = false
    switch direction
      when "N"  then @addword_vert(word, first_x, first_y, direction, rev)
      when "NE" then @addword_diag(word, first_x, first_y, direction, rev)
      when "E"  then @addword_horiz(word, first_x, first_y, direction, rev)
      when "SE" then @addword_diag(word, first_x, first_y, direction, rev)
      when "S"  then @addword_vert(word, first_x, first_y, direction, rev)
      when "SW" then @addword_diag(word, first_x, first_y, direction, rev)
      when "W"  then @addword_horiz(word, first_x, first_y, direction, rev)
      when "NW" then @addword_diag(word, first_x, first_y, direction, rev)
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

# This puts the lb object on the 'window', making it available 
# for other scripts to use.
window.lb = lb

