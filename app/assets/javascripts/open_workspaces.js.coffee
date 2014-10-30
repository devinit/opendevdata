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



$("form#sendEmail").submit (event) ->
  formData =
    content: $("textarea").val()
    workspace_id: $("input#workspace").val()
    user_id: $("input#user").val()

  $.post("messages/", formData).done (data) ->
    alert "message sent!"
    return

  event.preventDefault()
  return

blog_tag_id = $('.workspace_posts').data('blog-tag-id')
url = "http://blog.opendevdata.ug/api/get_tag_posts/?tag_slug=#{blog_tag_id}"

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
      str = "<h5 class='short-header'><a href='" + url + "' target='_blank'>" + _post.title + "</a></h5>" + "<div class='short-description'><span class='release'>Posted on </span>" + _post.date + "<br/>"+_post.content.substring(0,250)+"</div><hr>"
      fullStr += str
      i += 1

    if length == 0
      fullStr = "<div class='alert-box info'>No blog Posts found!</div>"
    $(".workspace_posts").html fullStr
    return

