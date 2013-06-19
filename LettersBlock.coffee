#
# LettersBlock
# 
class LettersBlock
  constructor: (@width, @height) ->
    @letters = []
 
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

  # Gets the letter at row y, and column x
  # We should assume the caller won't use a value greater
  # than the @width or @height
  letter: (x, y) ->
    @letters[x + (y * @width)]

lb = new LettersBlock(10,10)
lb.genrandomletters()
  
jQuery ->
  $('#game_block').append('<table></table>')

  for y in [0...lb.height]
    $('table').append('<tr>')

    for x in [0...lb.width]
      tot = x + y
      $('tbody tr:last-child').append('<td>')
      $td = $('tbody tr:last-child td:last-child')
      $td.append(lb.letter(x, y))
      $td.attr('id', tot)
      jQuery.data($td[0], "data", { x: x, y: y, letter: lb.letter(x,y) })
