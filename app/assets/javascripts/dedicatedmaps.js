// Our one global app object
var dedicatedmaps = (function() {
    var app = {};
    app.version = 1.0;
    app.icons = {};
    app.balloons = {};

    app.getVersion = function() {
        console.log(this.version);
    };

    // Functions related to manipulating the user interface
    app.ui = {
        // A helper sub-module for loading in icons
        icons: {
            image_directory:"http://www.dedicatedmaps.com/images",
            getIconPath: function(name) {return [this.image_directory, name + '.png'].join('/')},
            getIcon: function(name) {return app.ui.ajaxLoad({url: app.ui.icons.getIconPath(name)})}
        },
        // Route all AJAX requests through this function to link them to the loading indicator
        ajaxLoad: function(ajaxRequestObject) {
            var message_div = app.ui.getMessageDiv();
            $(message_div).html("<span style=\"color:red;\">loading...</span>");
            $(message_div).show();
            console.log("ajaxLoad(" + ajaxRequestObject.url + ")");
             return $.ajax(ajaxRequestObject)
                .fail(function(error) {
                    $(message_div).html("<span style=\"color:red;\">Connection Error!</span>");
                    console.log(error)
                })
                .done(function(response) {
                    $(message_div).text('Done');
                    $(message_div).fadeOut(1000);
                    console.log(response);
                });
        },
        // Save the map zoom, center, and map_type 2 seconds after the user has stopped moving it.
        cue_save_map: function() {
            console.log("caught signal to save map");
            // TODO: Implement saving state when we get a cue to save the map
        },
        getMapDiv: function() {
            return document.getElementById('map_div');
        },
        getMessageDiv: function() {
            return document.getElementById('message');
        },
        getMap: function() {
            return this.map;
        }
    };

    // Set options on the map and display it after page load. The main init function.
    app.initializeMap = function() {
        $(document).ready(function() {
            google.maps.event.addDomListener(window, "load", function() {
                var map_state = {"zoom":7,
                    "lon":-123.391,
                    "lat":47.8933,
                    "map_type":"roadmap"
                }; //TODO: Load this in via Ajax

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
                app.map = new google.maps.Map(app.ui.getMapDiv(), mapOptions);

                google.maps.event.addDomListener(app.map, "dragend", function() {
                    app.ui.cue_save_map();
                });
                google.maps.event.addDomListener(app.map, "maptypeid_changed", function() {
                    app.ui.cue_save_map();
                });
            });
        });
    };

    // Top of the dedicatedmaps.layer namespace
    app.layer = {};

    // Container for all the layers.
    app.layer.layers = {};

    // Some convenience methods
    app.layer.forEachLayer = function(callback) {
        // callback is called with (index, element) or (key, value) for objects
        $.each(app.layer.layers, callback);
    };

    app.layer.getAllLayersAsList = function() {
        return $.map(app.layer.layers, function(value) {
            return [value];
        });
    };

    app.layer.getAllLayersAsObject = function () {
        return app.layer.layers;
    };

    app.layer.getAllActivatedLayersAsObject = function() {
        var newObj = {};
        var list = app.layer.getAllLayersAsList();
        var onList = filter(function() {
            return this.isOn;
        }, list);

        onList.forEach(function(element) {
            newObj[element.name] = element
        });

        return newObj;
    };

    app.layer.getAllActivatedLayersAsList = function() {
        var list = [];
        var obj = app.layer.getAllActivatedLayersAsObject();
        $.each(obj, function(key, value){
            list.push(value);
        });
        return list;
    };

    // Our main layer prototype
    // To inherit prototype methods, call Layer() with the new keyword
    app.layer.Layer = function(name, map, id, type) {
        // Layers must have a type
        if (!type) {
            throw new Error("Attempted to instantiate a Layer without a type");
        }
        this.name = name;
        this.map = map;
        this.id = id;
        this.icon = null;
        this.type = type;
        this.loaded = false;
        this.isOn = false;
        this.markers = [];
        app.layer.layers[name] = this;
        return this;
    };

    // Shared methods
    app.layer.Layer.prototype.on = function() {
        if (!this.loaded) {
            var layer = this
            var name = this.name;

            // Determine the correct URL to load this Layer's markers
            switch (layer.type) {
                case 'StagingArea':
                    var url = ['/', 'staging_areas_company', '/', layer.name, '.json'].join('');
                    break;
                default:
                    throw new Error("Unrecognized layer type when instantiating new layer.");
                    break;
            }

            // Load JSON marker list
            app.ui.ajaxLoad({
                url: url,
                success: function(data) {
                    layer.isOn = true;
                    $.each(data, function(key, value){
                        layer.load(value);
                    });
                },
                error: function() {
                    throw new Error("Unable to load layer: " + name);
                }
            });
                //"/" + name + ".json", function(data){this.name.load(data);});

        }
    };

    app.layer.Layer.prototype.off = function() {
        this.hide();
        this.isOn = false;
    };

    app.layer.Layer.prototype.load = function (data) {
        // data: Object {id: 71005, name: "Tesoro Facility",
        // staging_area_company_id: 1,
        // contact: "Mike Alleyn",
        // address: "2211 St. Francis Lane"
        // ...
        // }
        var marker = this.render(data);
        this.markers.push(marker);
        this.loaded = true;
        this.load_callback();
        this.load_callback = function() {};
    };
    // Called by the refresh button if the layer is checked.
    app.layer.Layer.prototype.reload = function() {
        if (this.loaded) {
            this.clear_markers();
            this.loaded = false;
            this.on();
        }
    };

    app.layer.Layer.prototype.getAllMarkersAsList = function() {
      return this.markers;
    };

    app.layer.Layer.prototype.forEachMarker = function(callback) {
        //Call like this: exampleLayer.forEachMarker(function(index, element) {
        // # Do something
        // });
        $.each(this.markers, callback);
    };

    app.layer.Layer.prototype.refresh = function() {};
    app.layer.Layer.prototype.load_callback = function() {};

    app.layer.Layer.prototype.render = function(current) {
        var latLng = new google.maps.LatLng(current.lat, current.lon);
        var marker = new google.maps.Marker({
            position: latLng,
        });
        marker.id = current[this.id];

        return marker;
    };

    app.layer.Layer.prototype.addBubble = function(marker) {
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
            };

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
    };

    //app.layers = {
    //    pinpoint: {
    //        name: "pinpoint",
    //        on: function() {
    //            app.layers.pinpoint.listener = google.maps.event.addListener(app.map, "click", function(e) {
    //                $('#pinpoint_data').text(e.latLng.lat() + "," + e.latLng.lng());
    //                // Handle browser <IE8 here
    //            });
    //        },
    //        off: function() {
    //            google.maps.event.removeListener(app.layers.pinpoint.listener);
    //        },
    //        copyToClipboard: function() {
    //            window.prompt("Copy to clipboard: Ctrl+C, Enter", $('#pinpoint_data').val());
    //        }
    //    },
    //    grp: new app.Layer(app.map, "newlayer", 5, "grp")
    //};

    app.initializeMap();
    return app
})();
