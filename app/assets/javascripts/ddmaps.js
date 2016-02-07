// Our one global app object
var ddmaps = (function() {
	var app = {};
	app.version = 1.0;
	app.icons = {};
	app.layers = {};
	app.map = {};
	app.balloons = {};
	
	app.map_div = document.getElementById("map_div");


	app.getVersion = function() {
		console.log(this.version); 
	};

	// Set options on the map and display it after page load
	app.initializeMap = function() {
		var layer_config = {"grpboom":{"type":"KML","icon":"alphabet/blue_A"},"GrpNT":{"type":"StagingArea","icon":"square_mini/purple"},"grp2016":{"type":"StagingArea","icon":"square_mini/yellow"},"grpBL":{"type":"StagingArea","icon":"square_mini/yellow"},"grpWDOE":{"type":"KML","icon":""},"grpsa":{"type":"StagingArea","icon":"square_mini/blue"},"kml_test":{"type":"KML","icon":""},"astoria_marine_map":{"type":"Custom","icon":null},"pinpoint":{"type":"Custom","icon":null},"wrrls":{"type":"StagingArea","icon":"teardrop_mini/alphabet/green_W"},"iess":{"type":"StagingArea","icon":"custom/water"},"ccss":{"type":"StagingArea","icon":"square_mini/purple"},"AIS_Towersa":{"type":"StagingArea","icon":"square/misc/wifi"},"cics":{"type":"StagingArea","icon":"teardrop_mini/alphabet/yellow_M"},"bcos":{"type":"StagingArea","icon":"teardrop_mini/alphabet/brown_D"},"nrcs":{"type":"StagingArea","icon":"teardrop_mini/green"},"public_ships":{"type":"Custom","icon":null},"pois":{"type":"StagingArea","icon":"teardrop_mini/green"},"mfsas":{"type":"StagingArea","icon":"teardrop/purple"},"crc":{"type":"StagingArea","icon":"teardrop_mini/blue"}};
		
		google.maps.event.addDomListener(window, "load", function() {
			var map_state = {"zoom":7,
			"lon":-123.391,
			"lat":47.8933,
			"map_type":"roadmap"
			} //TODO: Load these in via Ajax

			var center = new google.maps.LatLng(map_state.lat, map_state.lon);
			var map_types = {
		      "hybrid":google.maps.MapTypeId.HYBRID,
		      "satellite":google.maps.MapTypeId.SATELLITE,
		      "roadmap":google.maps.MapTypeId.ROADMAP,
		      "terrain":google.maps.MapTypeId.TERRAIN
		    };
		    var mapOptions = {
      			center: center,
      			zoom: map_state.zoom,
      			mapTypeId: map_types[map_state.map_type.toLowerCase()]
    		};
    		app.map = new google.maps.Map(app.map_div, mapOptions);

    		google.maps.event.addDomListener(app.map, "dragend", app.cue_save_map);
      		google.maps.event.addDomListener(app.map, "maptypeid_changed", app.cue_save_map);
      		var save_delay = 0;

		});


	};

	// Does not work!
	app.saveMap = function() {
      new Ajax.Updater('message', 'http://localhost:3000/maps/6', {asynchronous:true, evalScripts:true, method:'put', onComplete:function(request){$('message').show()}, parameters:
          'map[zoom]=' + map.getZoom() +
          '&map[lat]=' + map.getCenter().lat() +
          '&map[lon]=' + map.getCenter().lng() +
          '&map[map_type]=' + map.getMapTypeId()
         + '&authenticity_token=' + encodeURIComponent('UM5PoKV0FSPqQpuhRn2wBL13pxoAzZq2hz6MiqNnlrDKmeNAThEmxlHrv4njzJeJDiP5oelgKxL814/zpBlAzQ==')})
    };

    // Save the map zoom, center, and map_type 2 seconds after the user has stopped moving it.
    app.cue_save_map = function() {
          console.log("caught signal to save map");
          if (typeof(save_map_timer) == 'number') clearTimeout(save_map_timer);
          save_map_timer = setTimeout(save_map, 2000);
      }

	app.icons = {
		image_directory: "http://dedicatedmaps.com/images/",
		getIconPath: function(name) {
			return this.image_directory + name + '.png';
		},
		getIcon: function(name) {
			return this.getIconPath(name);
		}
	}

	app.layers = {
		pinpoint: {
			on: function() {
				app.layers.pinpoint.listener = google.maps.event.addDomListener(app.map, "click", function(e) {
					$('#pinpoint_data').text(e.latLng.lat() + "," + e.latLng.lng());
					// Handle browser <IE8 here
				});	
			},
			off: function() {
				google.maps.event.removeListener(app.layers.pinpoint.listener);
			},
			copyToClipboard: function() {
  				window.prompt("Copy to clipboard: Ctrl+C, Enter", $('#pinpoint_data').val());
			}
		}
	}

	app.initializeMap();
	return app
})();