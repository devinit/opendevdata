$('.chart-callout').hide()

$("a#show-chart-callout").on 'click', (event) ->
    # $(this).html('<a href="" id="hide-callout">Hide Extra fields</a>')
    $('.btw').fadeOut()
    $('.wrap-link').fadeOut()
    $('.chart-callout').show()
    event.preventDefault()


$("a#hide-callout").on 'click', (event) ->
    #TODO figure out how to fix this!!!!
    console.log "This was called"
    $(this).html('<a href="" id="show-chart-callout">Show Extra fields</a>')
    $('.chart-callout').hide()
    event.preventDefault()

$ ->
  $("#datasets-datatables").dataTable()
