url = "http://blog.opendevdata.ug/api/get_recent_posts"
$.ajax
  type: "GET"
  url: url
  async: false
  contentType: "application/json"
  dataType: "jsonp"
  success: (data) ->
    posts = data.posts
    fullStr = ""
    i = 0
    length = posts.length
    # only displaying 3 posts! Minimal stuff
    if posts.length >= 3
      length = 3

    while i < length
      _post = posts[i]
      url = _post.url
      str = "<h5 class='short-header'><a href='" + url + "' target='_blank'>" + _post.title + "</a></h5>" + "<div class='short-description'><span class='release'>Posted on </span>" + _post.date + "</div><hr>"
      fullStr += str
      i += 1
    $(".posts").html fullStr
    return


# Google map
###initialize = ->
  mapOptions =
    center: new google.maps.LatLng(1.3733330, 32.2902750)
    zoom: 6

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  return
google.maps.event.addDomListener window, "load", initialize
###