# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $("#data_series").dataTable()

$("button#data-series").on "click", ->

  # prepare data
  name = $("input#name").val()
  description = $("textarea#description").val()
  sector = ""
  notes = $("textarea#notes").val()
  unit_of_measure = ""

  $("select#unit_of_measure option:selected").each ->
    unit_of_measure = $(this).val().trim()

  $("select#sector option:selected").each ->
    sector = $(this).val().trim()

  if (name.trim() isnt "") and (description.trim() isnt "") and (unit_of_measure isnt "")
    url = window.location.protocol + "//" + window.location.host + "/data-series"
    $.post url,
      name: name
      description: description
      unit_of_measure: unit_of_measure
      sector: sector
      notes: notes

    $("#dataSeriesModal").foundation "reveal", "close"

  # alert('The Dataseries has just been created!' + name + " " + description);
  else

    # TODO -> fix validation
    alert "Try again! You forgot to type in either name or description; both a required!"
  return
