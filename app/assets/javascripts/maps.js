
function initialize() {
  var mapOptions = {
    center: new google.maps.LatLng(1.3733330,32.2902750),
    zoom: 6
  };
  var map = new google.maps.Map(document.getElementById("map-canvas"),
      mapOptions);
}
google.maps.event.addDomListener(window, 'load', initialize);
