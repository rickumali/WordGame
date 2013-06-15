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
    $('tbody tr:last-child').attr('id', y)

    for x in [0...lb.width]
      $('tbody tr:last-child').append('<td>')
      $('tbody tr:last-child td:last-child').append(lb.letter(x, y))
