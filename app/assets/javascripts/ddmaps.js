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
	}


	app.ajax_load = function(ajaxRequestObject) {
		$('#message').html('<span style="color:red;">loading...</span>');
        $('#message').show();
        console.log("app.ajax_load(" + ajaxRequestObject.url + ")");
		return $.ajax(ajaxRequestObject).fail(function(reqObject, textstatus, errorthrown) {
            $('message').html('<span style="color:red;">Connection Error!</span>');
       	}).done(function() {
            $('#message').text('Done');
            $('#message').fadeOut(1000);  
       	});
	}

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

    // A helper for loading in icons
	app.icons = {
		image_directory: "http://dedicatedmaps.com/images/",
		getIconPath: function(name) {
			return this.image_directory + name + '.png';
		},
		getIcon: function(name) {
			return this.getIconPath(name);
		}
	}

	// A spinning loading indicator for the DOM
	app.loader = function() {
	    var div = document.createElement(div);
	    div.id = "loading";
	    div.setAttribute("style","margin-top:10px; text-align: center;");
	    var spinner = document.createElement('img');
	    spinner.setAttribute("src","/images/ajax-loader.gif");
	    div.appendChild(spinner);
	    return(div);
	}

	// Our main layer prototype
	app.Layer = function (map, name, id, type) {
	  this.id = id;
	  this.name = name;
	  this.loaded = false;
	  this.list = {};
	  this.map = map;
	  this.type = type;
	  app.layers += this;
	  return this;
	}

	app.Layer.prototype.on = function() {
  		if (!this.loaded) {
	    	var name = this.name;
	    	app.ajax_load("/" + name + ".json", function(data){layer.name.load(data);});
  		}
  		this.show();
	};
	app.Layer.prototype.off = function() {
  		this.hide();
	};

	app.Layer.prototype.load = function (data) {
	  //var data = eval('(' + dataStr + ')');
	  for (var i = 0; i < data.length; i++) {
	    var current = data[i];
	    var marker = this.render(current);
	    //this.list[current[this.id]] = marker;
	  	this.list.push(marker);
	  }
	  this.loaded = true;
	  this.load_callback();
	  this.load_callback = function() {};
};
	// Called by the refresh button if the layer is checked.
	app.Layer.prototype.reload = function() {
  		if (this.loaded) {
		    this.clear_markers();
		    this.loaded = false;
		    this.on();
  		}
	};

	app.Layer.prototype.refresh = function() {};
	app.Layer.prototype.load_callback = function() {};

	app.Layer.prototype.render = function(current) {
		var latlng = new google.maps.LatLng(current.lat, current.lon);
		var marker = new google.maps.Marker({
		position: latlng,
		title: title,
		icon: current.icon
	  });
		marker.id = current[this.id];
  
		var name = this.name;
  
    }

    app.Layer.prototype.addBubble = function(marker) {
    	google.maps.event.addListener(marker, 'click', function(){
			// Marker has been clicked
			if (infoBubble && infoBubble.isOpen()) {
				infoBubble.close();
			}
	      	
	        // Initialize the infoBubble for each marker
	        infoBubble = new InfoBubble({
	           maxHeight: 250,
	            minHeight: 250,
	            maxWidth: 500,
	            minWidth: 500,
	            marker: marker,
	            map: layer.map,
	            position: latlng,
	            disableAutoPan: false
	          });

	        // Open the bubble
	        if (infoBubble && !infoBubble.isOpen()) {
	          infoBubble.open();
	        }

	        // Set up an Ajax request object
	        var ajax = {
				beforeSend: function() {
					infoBubble.addTab('Loading...', app.loader);
				},
				url: "/marker/" + name + "/" + marker.id + ".json",
				error: function() {
					infoBubble.updateTab('0', 'Error', function(errorthrown) {
						return "ERROR: Resp code..." + errorthrown;
					});
				},
				success: function(response, status, reqObject) {
		          	//infoBubble.updateTab('0', 'JSON', reqObject.responseText.replaceAll(",", ",<br />") );
		            var json = reqObject.responseJSON;

		            //if the bubble is for public_ships
		            if (name == 'public_ships') {
		              infoBubble.updateTab('0', 'Info', layer.shipInfo(json, 'public_ships'));
		            } else {
		            
		            //build the info tab
		            infoBubble.updateTab('0', 'Info', buildInfoTabContainer(json, marker)); 

		            //build equipment tab           
		            //if there is equipment in the json, tell us about it
		            if (json.staging_area_assets && json.staging_area_assets.length > 0) {
		              infoBubble.addTab('Equip', buildEquipmentContainer(json, marker, infoBubble));
			            }
		        	} 
		        }
		  	}

	  		// The actual call
	        ajax_load(ajax);


		    // Close the bubble if user clicks outside the bubble
		    google.maps.event.addListener(app.map, 'click', function() {
		    	if (infoBubble && infoBubble.isOpen()) {
		        	infoBubble.close();
		      		}
		    	});

			marker.hidden = false;
	  		marker.refresh = this.refresh;
	  		if (this.properties) {
			    for (var i = 0; i < this.properties.length; i++) {
			      var prop = this.properties[i];
			      marker[prop] = current[prop];
	    			}
	  			}
	  		}); 
		return marker
}
		
	
 


	app.layers = {
		pinpoint: {
			name: "pinpoint",
			on: function() {
				app.layers.pinpoint.listener = google.maps.event.addListener(app.map, "click", function(e) {
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
		},
		grp: new app.Layer(app.map, "newlayer", 5, "grp")
	}

	app.initializeMap();
	return app
})();