$(function() {
    function initialize() {
        var map = new google.maps.Map(document.getElementById('map'), {
            center: new google.maps.LatLng(0.347484, 32.588136),
            zoom: 9
        });
        var markers = [{
            position: new google.maps.LatLng(0.316837, 32.586142),
            map: map,
            title: 'Ministry of Finace',
            html:"<h5>Intiatives Under Ministry of Finace</h5><hr>"+
               "<p>Budget Monitoring Portal </p>"+
                "<p>Website: <a href='http://www.budget.go.ug'>www.budget.go.ug</a></p><hr>"+
                  "<p>Development Assistance Management System</p>"+
                  "<p>Aid Liason Office </p>"+
                "<p>Website: <a href='http://www.finance.go.ug/amp/portal '>www.finance.go.ug/amp/portal</a></p><hr>"+
                "<p>Address: Plot 2/12 Apollo Kaggwa Road/ P.O.Box 8147 Kampala Shimoni Rd 1, Kampala, Uganda</p>"+
                "<p>Tel:   +256 41 4235051</p>",
            color: "red"
        }, {
            position: new google.maps.LatLng(0.281370, 32.610714),
            map: map,
            title: 'Development Reaseach And Training',
            color: 'green',
            html:"<h5>Development Reaseach And Training</h5>"+
             "<hr><p>Website: <a href='http://www.drt-ug.org/'>drt-ug.org</a></p>"+
             "<p>Address: Lukka Mayanja Stretch(Off Ggaba RD., Opp Wavzend) Kampala, Uganda</p>"+
             "<p>Tel: +256-41-4269495 / +256-39-3263629</p>",
        }, {
            position: new google.maps.LatLng(0.320250, 32.589137),
            map: map,
            title: 'Ask Your Government Uganda',
            color: 'red',
            html:"<h5>Ask Your Government Uganda</h5><hr>"+
            "<p>Cipesa uganda/ministry of information, Office of the Prime Minister</p>"+
             "<hr><p>Website: <a href='http://www.askyou.ug/'> www.askyou.ug</a></p>"+
             "<p>Address: Postel Building, Yusuf Lule Road/P.O Box 341, Kampala Clement Hill Rd, Kampala, Uganda</p>"+
             "<p>Tel: +256 41 4232575</p>",
        }, {
            position: new google.maps.LatLng(0.316356, 32.584640),
            map: map,
            title: 'UBOS',
            color: 'red',
               html:"<h5>Initiatives under UBOS</h5>"+
               "<h5>Integrated Management Information System</h5>"+
             "<p>Website: <a href='http://ugandadata.org/imis/'>ugandadata.org</a></p><hr>"+
             "<h5>UgandaInfo</h5>"+
             "<p><a href='http://www.ugandadata.org/ugandainfo/libraries/aspx/Home.aspx'>www.ugandadata.org</a></p></hr>"+
              "<h5>Uganda Bureau of Statistics National Data Archive</h5>"+
             "<p>Website: <a href='http://www.ubos.org/unda/index.php/catalog/central/about '>www.ubos.org/unda/index.php/catalog/central/about</a></p></hr>"+
             "<p>Address: Statistics House, Plot 9 Colville Street/Box 7186,Kampala Colville St, Kampala, Uganda</p>"+
             "<p>Tel: +256 41 4706000</p>",
        }, {
            position: new google.maps.LatLng(0.330603, 32.578015),
            map: map,
            title: 'CountrySTAT',
            color: "red",
            html:"<h5>CountrySTAT </h5><hr>"+
            "<p>Under Ministry of Agriculture Animal Industry and Fisheries  and UBOS </p><hr>"+
             "<p>Website: <a href='http://countrystat.org/home.aspx?c=UGA'>countrystat</a></p>"+
            "<p>Address: P.O. Box 102  Lugard Avenue ENTEBBE Ministry of Agriculture, Animal Industry and Fisheries </p>"+
            "<p>Tel: +256 (0) 414 320 006 </p>",

        }, {
            position: new google.maps.LatLng(0.298751, 32.648880),
            map: map,
            title: ' Uganda Water supply database ',
            color: "red",
            html:"<h5>Uganda Water supply database</h5><hr>"+
            "<p>Under Ministry of Water and Environment</p>"+
            "<hr><p>Address: Statistics House, Plot 9 Colville Street/Box 7186,Kampala Colville St, Kampala, Uganda</p>"+
             "<p>Website: <a href='http://ipsanad.com'>ipsanad.com</a></p>"+
            "<p>Address: Plot 21/28 Port Bell Road, Luzira/P.O. Box 20026 Kampala,  Uganda </p>"+
            "<p>Tel: +256 41 4505942</p>",
        }];
        var infowindow = new google.maps.InfoWindow({
            content: "loading...",
              maxWidth: 500
        });

        markers.forEach(function(marker) {
            var icon = "http://maps.google.com/mapfiles/ms/icons/" + marker.color + ".png";
            marker.icon = new google.maps.MarkerImage(icon);
            var point = new google.maps.Marker(marker);
            google.maps.event.addListener(point, "click", function() {
                infowindow.setContent(this.html);
                infowindow.open(map, this);
            });
        });
        //center markers
        autoCenter(map,markers);
    }
    function autoCenter() {
        //  Create a new viewpoint bound
        var bounds = new google.maps.LatLngBounds();
        //  Go through each...
        $.each(markers, function (index, marker) {
        bounds.extend(marker.position);
        });
        //  Fit these bounds to the map
        map.fitBounds(bounds);
    }
    google.maps.event.addDomListener(window, "load", initialize);
});