count = undefined
count = ->
  chars = undefined
  left = undefined
  val = undefined
  words = undefined
  val = $.trim($("textarea").val())
  words = val.replace(/\s+/g, " ").split(" ").length
  chars = val.length
  left = 250 - chars
  words = 0  unless chars
  elementClass = ""
  elementClass = "" if left > 10
  elementClass = "danger" if left < 0
  $("#counter").html "<br>" + words + " words and " + chars + " characters (" + left + " left)"
  $("#counter").addClass elementClass
  return

count()
$("textarea").on "input", count


