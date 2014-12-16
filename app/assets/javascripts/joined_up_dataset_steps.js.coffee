# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $("#data_series").dataTable()


$("button#data-series").on "click", ->

  # prepare data
  name = $("input#name").val()
  description = $("input#description").val()
  if (name.trim() isnt "") and (description.trim() isnt "")
    url = window.location.protocol + "//" + window.location.host + "/data-series"
    $.post url,
      name: name
      description: description

    $("#dataSeriesModal").foundation "reveal", "close"

  # alert('The Dataseries has just been created!' + name + " " + description);
  else

    # TODO -> fix validation
    alert "Try again! You forgot to type in either name or description; both a required!"
  return
