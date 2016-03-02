// Our one global app object
var dedicatedmaps = (function() {
    var app = {};
    app.version = 1.0;
    app.icons = {};
    app.balloons = {};
    app.map = null;

    app.getVersion = function() {
        console.log(this.version);
    };

    // Functions related to manipulating the user interface
    app.ui = {
        // A helper sub-module for loading in icons
        icons: {
            // http://dedicatedmaps.com/images/<name>.<suffix>
            image_directory: "../images",
            getIconPath: function (name, suffix) {
                switch (arguments.length) {
                    case 1: // Called without a file type
                        return encodeURI([app.ui.icons.image_directory, name + '.png'].join('/'));
                    case 2:
                        return encodeURI([app.ui.icons.image_directory, name + '.' + suffix].join('/'));
                }
            },
            getIcon: function (name) {
                var params = {
                    url: app.ui.icons.getIconPath(name)
                };
                return app.ui.ajaxLoad(params);
            }
        },
        // Methods for the loading indicator
        messageSpan: {
            getMessageSpan: function () {
                // Careful! This returns a DOM node, hot a jQuery DOM element
                // To access jQuery methods, use $() notation of the return value
                return document.getElementById('message');
            },
            clear: function () {
                var messageSpan = this.getMessageSpan();
                $(messageSpan).text('').hide();
            },
            setDone: function () {
                var messageSpan = this.getMessageSpan();
                $(messageSpan).text('Done').addClass('done').fadeOut(1000);
            },
            setLoading: function () {
                var messageSpan = this.getMessageSpan();
                $(messageSpan).text('Loading...').addClass('loading').show();
            },
            setError: function () {
                var messageSpan = this.getMessageSpan();
                $(messageSpan).text('Connection Error').addClass('error').show();
            }
        },
        // Route all AJAX requests through this function to link them to the loading indicator
        ajaxLoad: function(ajaxRequestObject) {
            app.ui.messageSpan.setLoading();
            console.log("Loading: " + ajaxRequestObject.url);
            return $.ajax(ajaxRequestObject)
                .fail(function(error) {
                    app.ui.messageSpan.setError();
                    console.log(error);
                })
                .done(function(response) {
                    app.ui.messageSpan.setDone();
                    console.log(response);
                    console.log('Done');
                });
        },
        // Spinning wheel loader indicator
        loader: function() {
            var div = document.createElement('div');
            div.id = "loading";
            $(div).addClass('loader');
            var spinner = document.createElement('img');
            spinner.setAttribute('src', app.ui.icons.getIconPath('ajax-loader', 'gif'));
            div.appendChild(spinner);
            return div;
        },
        // Save the map zoom, center, and map_type 2 seconds after the user has stopped moving it.
        cue_save_map: function() {
            console.log("Caught signal to save map...");
            app.ui.pushMapState();
        },
        getMapDiv: function() {
            return document.getElementById('map_div');
        },
        getMap: function() {
            return app.map;
        },
        setMap: function(map) {
            app.map = map;
        },
        setCheckboxHandlers: function() {
            // Select all checkboxes with property data-layer
            var layerCheckboxes = $("input[data-layer]");
            layerCheckboxes.each(function(index, element) {
               var layerName = $(element).data('layer');
                var id = $(element).data('id');
                newLayer = new app.layer.Layer(layerName, app.ui.getMap(), id, layer_config[layerName].type, layer_config[layerName].icon);
                $(element).click(function() {
                    this.checked ? function() { dedicatedmaps.layer.layers[layerName].on(); console.log("turned on " + layerName);}() : function () {dedicatedmaps.layer.layers[layerName].off(); console.log("turned off " + layerName)}()
                });
            });
        },
        getMapState: function () {
            var id = mapState.id;
            var map = app.ui.getMap();
            var zoom = map.getZoom();
            var map_type = map.getMapTypeId();
            var center = map.getCenter();
            var lat = center.lat();
            var lon = center.lng();
            return {
                id: id,
                zoom: zoom,
                map_type: map_type,
                lat: lat,
                lon: lon
            };
        },
        pushMapState: function () {
            var mapState = app.ui.getMapState();
            var ajaxParameters = {
                url: 'http://0.0.0.0:3000/maps/' + mapState.id,
                data: mapState,
                method: 'PUT'
            };
            app.ui.ajaxLoad(ajaxParameters);
        }
    };
    app.onPageReady = function () {
        // Check that jQuery has loaded
        if (typeof(jQuery) === 'undefined') {
            throw new Error('jQuery failed to load. Cannot continue.');
        }
        // Check that infoBubble.js has loaded
        if (typeof(InfoBubble) === 'undefined') {
            throw new Error('infoBubble.js failed to load. Cannot continue');
        }
        $(document).ready(function () {
            // Detect if the Google Maps JS has loaded yet
            if (window.google && google.maps) {
                // Map script is already loaded
                alert("Map script is already loaded. Initialising...");
            } else {
                console.log('Loading Google Maps API...');
                var url = 'https://maps.googleapis.com/maps/api/js?v=3.22&key=AIzaSyCXWCJQoRqKt74nUWgvJBmk_naVR-TbeBg';
                $.getScript(url, function () {
                    console.log('Done.');
                    app.initializeMap();
                });
            }
        });
    };

    // Set options on the map and display it after page load. The main init function.
    app.initializeMap = function() {
        google.maps.event.addDomListener(window, 'load', function () {
            // Make sure we have an element to use for the map. This should only raise an error if the page does not load completely
            if (!app.ui.getMapDiv()) {
                throw new Error('Cannot load Google Maps because element div#map_div was not found in the DOM');
            }
            console.log('Initializing map...');
            if (!mapState) {
                console.log('Warning: unable to load previous map state.');
            } else {
                console.log('Previous map state found. Loading...');
            }
            var center = new google.maps.LatLng(mapState.lat, mapState.lon);
            var map_types = {
                "hybrid": google.maps.MapTypeId.HYBRID,
                "satellite": google.maps.MapTypeId.SATELLITE,
                "roadmap": google.maps.MapTypeId.ROADMAP,
                "terrain": google.maps.MapTypeId.TERRAIN
            };
            var mapOptions = {
                center: center,
                zoom: mapState.zoom,
                mapTypeId: map_types[mapState.map_type.toLowerCase()]
            };
            var map = new google.maps.Map(app.ui.getMapDiv(), mapOptions);
            app.ui.setMap(map);

            // Not implemented yet
            google.maps.event.addDomListener(app.map, "dragend", function () {
                app.ui.cue_save_map();
            });
            google.maps.event.addDomListener(app.map, "maptypeid_changed", function () {
                app.ui.cue_save_map();
            });
            // Set event handlers on left-hand checkboxes so layers appear when we check them
            app.ui.setCheckboxHandlers();
        });
    };

    // Top of the app.layer namespace
    app.layer = {};

    // Container for all the layers.
    app.layer.layers = {};

    // Some convenience methods for working with the layers stack
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

    app.layer.getActivatedLayersAsObject = function() {
        var returnObj = {};
        app.layer.getActivatedLayersAsList().forEach(function(layer) {
            returnObj[layer.name] = layer;
        });
        return returnObj;
    };

    app.layer.getActivatedLayersAsList = function() {
        return app.layer.getAllLayersAsList().filter(function(layer) {
            return layer.isOn;
        });
    };

    // Our main layer prototype
    // To inherit prototype methods, call Layer() with the new keyword
    app.layer.Layer = function(name, map, id, type, icon) {
        // Layers must have a type
        if (!type) {
            throw new Error("Attempted to instantiate a Layer without a type!");
        }
        this.name = name;
        this.map = map;
        this.id = id;
        this.icon = icon;
        this.type = type;
        this.loaded = false;
        this.isOn = false;
        this.markers = [];
        app.layer.layers[name] = this;
        return this;
    };

    app.layer.Layer.prototype.toString = function() {
      return "[Layer " + this.name + "]";
    };

    // Called when the checkbox for its respective layer is checked
    app.layer.Layer.prototype.on = function() {
            var layer = this;
            var name = this.name;

            // Determine the correct URL to load this Layer's markers
            switch (layer.type) {
                case 'StagingArea':
                    if (!layer.loaded) {
                        var url = ['/', 'staging_areas_company', '/', layer.name, '.json'].join('');
                        // Load JSON marker list
                        app.ui.ajaxLoad({
                            url: url,
                            success: function(data) {
                                $.each(data, function(key, value){
                                    layer.load(value);
                                });

                                // Convenience methods that extend the Marker prototype for what we are about to do
                                google.maps.Marker.prototype.center = function () {
                                    app.ui.getMap().panTo(this.getPosition());
                                };

                                google.maps.Marker.prototype.centerOpen = function () {
                                    this.center();
                                    google.maps.event.trigger(this, "click");
                                };

                                // Staging areas have locator select tags that need a jquery change event handler assigned to them
                                layer.layerLocatorElement = $('#' + layer.name + "_locate");
                                layer.layerLocatorElement.change(function () {
                                    var target = layer.layerLocatorElement.val();
                                    $('#' + layer.name)[0].checked ? layer.getMarkerByID(target).centerOpen() : layer.load_callback = function () {
                                        layer.getMarkerByID(target).centerOpen()
                                    }
                                });

                                // Staging areas also have a similar equipment search function
                                layer.search_filter = function(arg) {
                                    if (arg != "0" && arg != 0) {
                                        app.ui.ajaxLoad({
                                            url: ['/search', 'staging_areas', layer.name, arg + '.json'].join('/'),
                                            success: function(data) {
                                                //in this context, this refers to the jQuery ajax request object
                                                layer.clearMarkers();
                                                $.each(data, function(index, element) {
                                                    layer.load(element);
                                                });
                                                layer.show();
                                            },
                                            error: function() {
                                                alert("Error processing search. Please try later.");
                                            }
                                        });
                                    } else {
                                        layer.off();
                                        layer.on();
                                        $(layer.equipmentLocatorElement).val(-1);
                                    }
                                };
                                layer.equipmentLocatorElement = $('#' + layer.name + "_gear");
                                layer.equipmentLocatorElement.change(function () {
                                    var target = layer.equipmentLocatorElement.val();
                                    layer.search_filter(target);
                                });

                                // Set layer status to on
                                layer.isOn = true;
                                layer.show();
                            },
                            error: function() {
                                throw new Error("Unable to load layer: " + name + "!");
                            }
                        });
                    } else {
                        layer.show();
                    }
                    break;
                case 'Custom':  // Overrides for special layers like pinpoint are defined here
                    switch (layer.name.toLowerCase()) {
                        case 'pinpoint':
                            layer.textArea = $('#pinpoint_data');
                            layer.copyButton = $("a[data-role='pinpoint_data']");
                            layer.copyButton.bind('click', function () {
                                    window.prompt("Copy to clipboard: Ctrl+C, Enter", layer.textArea.text());
                            });
                            layer.listener = google.maps.event.addDomListener(app.ui.getMap(), "click", function (e) {
                                layer.textArea.text(e.latLng.lat() + "," + e.latLng.lng());
                            });
                            layer.off = function () {
                                google.maps.event.removeListener(layer.listener);
                                layer.isOn = false;
                            };
                            layer.isOn = true;

                            break;
                        case 'public_ships':
                            layer.render = app.publicShips.render;
                            if (!layer.loaded) {
                                var url = ['/', 'public_ships', '.json'].join('');
                                // Load JSON marker list
                                app.ui.ajaxLoad({
                                    url: url,
                                    success: function(data) {
                                        $.each(data, function(key, value){
                                            layer.load(value);
                                        });
                                        layer.isOn = true;
                                        this.loaded = true;
                                        layer.show();
                                    },
                                    error: function() {
                                        throw new Error("Unable to load layer: " + name + "!");
                                    }
                                });
                            } else {
                                layer.show();
                            }
                            break;

                            break;
                        case 'my_ships':
                            break;
                        case 'shared_ships':
                            break;
                    }
                    break;
                case 'KML': // KML layers have special properties so defaults are overridden here
                    // Top of the KML namespace. Kml related functions here.
                    layer.kml = {};
                    // List to hold all geoXML objects
                    layer.kml.geoxmls = [];

                    layer.kml.getControlDiv = function() {
                      var div = $('#layer' + this.id);
                    };

                    layer.kml.kmlLayerOn = function (id, url) {
                        if (layer.isOn) {
                            if ( $('#kml_'+id)[0].checked ) {
                                layer.kml.loadKML(id, url);
                            }
                        } else {
                            throw new Error('Attempted to turn on a KML despite layer being turned off');
                        }
                    };
                    layer.kml.kmlLayerOff = function(id) {
                        if (layer.kml.geoxmls[id]) {
                            layer.kml.geoxmls[id].setMap(null);
                        }
                    };
                    layer.kml.loadKML = function(id, url) {
                        console.log("Loading KML");
                        console.log(url);
                        var geoXml = new google.maps.KmlLayer({
                            url: url,
                            map: app.ui.getMap()
                        });
                        layer.kml.geoxmls[id] = geoXml;
                    };
                    layer.off = function() {
                        layer.kml.geoxmls.forEach(function(item) {
                            item.setMap(null)
                        });
                        // Uncheck all boxes
                        $('.kmlsubbox').each(function(index, elem) {
                            elem.checked = false;
                        });
                        // Turn layer state off
                        layer.isOn = false;
                    };
                    layer.isOn = true;
                    break;
                default:
                    throw new Error("Unrecognized layer type when instantiating new layer!");
                    break;
            }
    };

    // Called when checkbox in map view for respective layer is unchecked
    app.layer.Layer.prototype.off = function() {
        // If there is an info bubble open and it is open on this layer, close it
        if (app.balloons.infoBubble.isOpen() && app.balloons.infoBubble.layer == this.name) {
            app.balloons.infoBubble.close();
        }
        this.clearMarkers();
        this.isOn = false;
        this.loaded = false;
    };

    app.layer.Layer.prototype.getMarkerByID = function (id) {
        var ret, intID = parseInt(id);
        this.forEachMarker(function (index, element) {
            console.log(element.id, intID, element.id == intID);
            if (element.id == intID) {
                ret = element;
            }
        });
        if (ret) {
            return ret;
        } else {
            throw new Error('Could not find a marker with id: ' + id);
        }
    };

    // This calls Layer.render, so don't worry about calling it manually.
    app.layer.Layer.prototype.load = function (data) {
        // data: Object {id: 71005, name: "Tesoro Facility",
        // staging_area_company_id: 1,
        // contact: "Mike Alleyn",
        // address: "2211 St. Francis Lane"
        // ...
        // }
        var marker = this.render(data) || function() {throw new Error("Unable to render marker");};
        this.markers.push(marker);
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

    app.layer.Layer.prototype.setMapOnAll = function(map) {
        this.forEachMarker(function(index, marker) {
            marker.setMap(map);
        });
    };

    app.layer.Layer.prototype.clearMarkers = function() {
        this.hide();
        this.markers = [];
    };

    app.layer.Layer.prototype.hide = function() {
        this.setMapOnAll(null);
    };

    app.layer.Layer.prototype.show = function() {
        this.setMapOnAll(app.ui.getMap())
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

    // Side load icon and create a google.maps Marker object
    app.layer.Layer.prototype.render = function(current) {
        var iconPath = app.ui.icons.getIconPath(this.icon);
        var latLng = new google.maps.LatLng(current.lat, current.lon);
        var marker = new google.maps.Marker({
            position: latLng,
            icon: iconPath,
            map: app.ui.getMap()
        });
        marker.id = current.id;
        app.balloons.addBubble(marker, this.name);
        console.log('Marker:');
        console.log(marker);
        return marker;
    };

    // Beginning of app.balloons namespace
    // Methods in app.balloons generate DOM elements to inject into an InfoBubble.js class

    // Some DOM convenience methods
    app.balloons.dom = {
        createElement: function (elemName, text) {
            var element = document.createElement(elemName);
            if (typeof(text) == 'string') {
                if (text !== '') element.appendChild(document.createTextNode(text));
            } else {
                element.appendChild(text);
            }
            return element;
        },
        linkify: function (email_or_hlink) {
            var a = document.createElement('a');
            email_regex = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i;
            link_regex = /^[(www)(#?http:\/\/).*]/i;

            if (email_regex.test(email_or_hlink)) {
                a.setAttribute("href", "mailto:" + email_or_hlink);
            } else if (link_regex.test(email_or_hlink)) {
                if (email_or_hlink.substring(0, 3) == 'www') email_or_hlink = 'http://' + email_or_hlink;
                email_or_hlink = email_or_hlink.replace(/^#?(.*)#?$/, '$1');
                a.setAttribute("href", email_or_hlink);
            } else {
                return email_or_hlink;
            }
            a.innerHTML = email_or_hlink;
            return a;
        },
        createNameValueDiv: function (name, value) {
            var div, labelSpan, valueSpan;
            div = document.createElement('div');
            $(div).addClass('nameValueDiv');
            labelSpan = this.createElement('span', name);
            $(labelSpan).addClass('label');
            valueSpan = this.createElement('span', value);
            $(valueSpan).addClass('value');

            div.appendChild(labelSpan);
            $(div).append('&nbsp;'); // Add a non-breaking space between elements
            div.appendChild(valueSpan);
            return div;
        },
        // Convenience methods for displaying PDFs and PDF thumbnail images in balloons
        pdf: {
            pdfPath: 'pdf',
            getPDFPath: function (name) {
                return encodeURI(['/', app.balloons.dom.pdf.pdfPath, '/', name, ".pdf"].join(''));
            },
            getPDFThumbPath: function (name) {
                return encodeURI(['/', app.balloons.dom.pdf.pdfPath, '/thumbs/', name, ".png"].join(''));
            }
        },
        image: {
            // http://dedicatedmaps.com/images/asset_photos/<layer name>/<filename>.<format>
            // Example path: http://dedicatedmaps.com/images/asset_photos/crc/002.JPG
            assetImagePath: '../images/asset_photos',
            getAssetImagePath: function (name, layer) {
                return encodeURI([app.balloons.dom.image.assetImagePath, layer, name].join('/'));
            }
        }
    };

    // Container for the infoBubble.
    // Since we want only one infoBubble open at a time ever, we set it as a property on the global app object
    // When an infoBubble is instantiated this object is overwritten by infobubble.js's InfoBubble class (below)
    app.balloons.infoBubble = {
        isOpen: function () {
            return false;
        }
    };

    // The infoBubble is triggered by assigning a click handler on a marker
    app.balloons.addBubble = function(marker, layerName) {
        marker['clickListener'] = google.maps.event.addListener(marker, 'click', function () { // When marker is clicked...

            // Make sure infoBubble library is loaded
            if (!InfoBubble) throw new Error('infoBubble class not loaded. Check existence of infoBubble.js in assets and proper instantiation');

            // If there is an infoBubble already open, close it
            if (app.balloons.infoBubble.isOpen()) {
                app.balloons.infoBubble.close();
            }

            // Initialize the infoBubble for each new marker
            app.balloons.infoBubble = new InfoBubble({
                minHeight: 250,
                maxHeight: 500,
                minWidth: 500,
                maxWidth: 600,
                marker: marker,
                map: app.ui.getMap(),
                position: marker.position
            });

            // Close the bubble if user clicks on the map outside of it
            google.maps.event.addListener(app.ui.getMap(), 'click', function() {
                if (app.balloons.infoBubble.isOpen()) {
                    app.balloons.infoBubble.close();
                }
            });

            // Open the bubble
            app.balloons.infoBubble.open();

            // Add a reference to the layer that this bubble is open on
            app.balloons.infoBubble['layer'] = layerName;

            // Set up an Ajax request object
            var req = {
                beforeSend: function() {
                    app.balloons.infoBubble.addTab('Loading...', app.ui.loader());
                },
                url: ["/marker/", layerName, "/", marker.id, ".json"].join(''),
                success: function(json) {
                    // If the bubble is for public ships layer, use a different balloon loader
                    if (layerName == 'public_ships') {
                        app.balloons.infoBubble.updateTab('0', 'Info', app.balloons.shipInfo(json, 'public_ships'));
                    } else {
                        // Build the info tab
                        app.balloons.infoBubble.updateTab('0', 'Info', app.balloons.getInfoTabContainer(json));

                        // Build equipment tab
                        // If there is equipment in the json, tell us about it
                        if (json.staging_area_assets && json.staging_area_assets.length > 0) {
                            app.balloons.infoBubble.addTab('Equipment', app.balloons.getEquipmentContainer(json, app.balloons.infoBubble));
                        }
                    }
                }

            };
            app.ui.ajaxLoad(req);
        });
    };

    // Generic marker info container
    app.balloons.getInfoTabContainer = function (json) {
        // TODO: Refactor this
        var div = document.createElement('div');
        if (json.staging_area_company) {
            div.appendChild(app.balloons.set_staging_area_container(json));
        }
        if (json.contact) div.appendChild(app.balloons.dom.createElement('div', json.contact));
        if (json.address) div.appendChild(app.balloons.dom.createElement('div', json.address));
        if (json.city )   div.appendChild(app.balloons.dom.createElement('span', json.city + ', '));
        if (json.state)   div.appendChild(app.balloons.dom.createElement('span', json.state + ' '));
        if (json.zip)     div.appendChild(app.balloons.dom.createElement('span', json.zip));
        if (json.phone)   div.appendChild(app.balloons.dom.createNameValueDiv('Phone:', json.phone));
        if (json.fax)     div.appendChild(app.balloons.dom.createNameValueDiv('Fax:', json.fax));
        // If we have a valid email...
        if (json.email && json.email != "N/A" && json.email.length > 4 && json.email.indexOf('@') != -1) {
            var email = app.balloons.dom.createNameValueDiv('Email: ', app.balloons.dom.linkify(json.email));
            div.appendChild(email);
        }
        if (json.staging_area_details && json.staging_area_details.length > 0) {
            // The span that will hold GRP pdfs
            var pdfspan = document.createElement('span');


            // Filter images/pdfs out of staging area details
            var predicate = function(x) {
                if (x.name.toLowerCase().startsWith("pdf") ||
                    x.name.toLowerCase().startsWith("image") ||
                    x.name.toLowerCase().startsWith("img")) {
                    if (typeof(parseInt(x.name[x.name.length-1])) === "number") {
                        return true;
                    }
                }
                return false;
            };
            var filtered = json.staging_area_details.filter(predicate);

            $.each(json.staging_area_details, function (index, element) {
                div.appendChild(app.balloons.dom.createNameValueDiv(element.name, element.value));
            });

            // The span that will hold GRP pdfs
            var pdfspan = document.createElement('span');

            var that = this;

            $.each(filtered, function(index, element) {
                var label = element.value.substr(0, element.value.lastIndexOf('.')).toUpperCase();

                // Create a link and make it open in a new tab
                var pdf2 = document.createElement('a');
                var path = that.dom.pdf.getPDFPath(label);
                pdf2.setAttribute('href', path);
                pdf2.setAttribute('target', '_new');

                // Build thumbnail URL from PDF file path
                var thumb = that.dom.pdf.getPDFThumbPath(label);

                // Use document's createElement here since our createElement expects a text node
                var pdfThumb2 = document.createElement('img');
                pdfThumb2.setAttribute('src', thumb);
                pdfThumb2.setAttribute('height', '150px');
                pdfThumb2.setAttribute('width', '150px');

                pdf2.appendChild(pdfThumb2);
                pdfspan.appendChild(pdf2);

                // Finally, append the PDF span to the div
                div.appendChild(pdfspan);
            });
        }
        return div;
    };

    // Equipment info container renderer
    app.balloons.getEquipmentContainer = function (json, infoBubble) {
        if (json.staging_area_assets && json.staging_area_assets.length > 0) {
            var div = document.createElement('div');
            div.appendChild(this.set_staging_area_container(json));
            $.each(json.staging_area_assets, function(name, el) {
                // For each piece of equipment...
                var link = document.createElement('a');
                $(link).addClass('equipmentList');
                link.innerHTML = el.description;
                link.setAttribute('href', '#');
                $(link).click(function() {
                    var id = el.id;
                    app.ui.ajaxLoad({
                        url: ['/staging_area_assets', id + ".json"].join('/'),
                        success: function (response) {
                            //if infoBubble.tabs_ contains a 'Detail' tab, update it, else, add a new tab
                            if (infoBubble.tabs_.length >= 3) {
                                infoBubble.updateTab('2', 'Detail', app.balloons.getAssetDetailsContainer(response));
                                infoBubble.setTabActive_(infoBubble.tabs_[2].tab);
                            } else {
                                infoBubble.addTab('Detail', app.balloons.getAssetDetailsContainer(response));
                                infoBubble.setTabActive_(infoBubble.tabs_[2].tab);
                            }
                        }
                    });
                });
                div.appendChild(link);
            });
        } else {
            app.ui.messageSpan.setError();
            throw new Error('Attempted to build marker equipment tab but response from server was empty or malformed.');
        }
        return div;
    };

    app.balloons.set_staging_area_container = function(info) {
        var container = document.createElement('div');
        container.setAttribute('class','balloon');
        var title = document.createElement('div');
        title.setAttribute("class","balloon_title");
        // Center here image
        var a = document.createElement('a');
        a.setAttribute("title","Center map here.");
        a.href = "javascript:dedicatedmaps.ui.getMap().panTo(new google.maps.LatLng(" + info.lat + "," + info.lon + "));";
        var image = document.createElement('img');
        image.src = "/images/crosshairs.png";
        image.setAttribute("alt","Center map here.");
        image.setAttribute("class","crosshairs");
        a.appendChild(image);
        title.appendChild(a);

        // Location name
        title.appendChild(document.createTextNode(info.name));
        var header = document.createElement('div');
        header.setAttribute("class","balloon_company");
        header.appendChild(document.createTextNode(info.staging_area_company.title));
        title.appendChild(header);
        container.appendChild(title);
        var div = document.createElement('div');
        //div.setAttribute('class','info_window');
        container.appendChild(div);
        return container;
    };

    app.balloons.getAssetDetailsContainer = function(json) {
        var div = document.createElement('div');
        var title = app.balloons.dom.createElement('span', json.description);
        $(title).addClass('assetTitle');
        div.appendChild(title);

        if (json.staging_area_asset_details && json.staging_area_asset_details.length > 0) {
            $.each(json.staging_area_asset_details, function (index, element) {
                switch (element.name) {
                    case 'Serial_Number':
                        var serial = app.balloons.dom.createNameValueDiv('Serial Number', element.value);
                        div.appendChild(serial);
                        break;
                    case 'Manufacture_Year':
                        var manufactureYear = app.balloons.dom.createNameValueDiv('Year Manufactured', element.value);
                        div.appendChild(manufactureYear);
                        break;
                    default:
                        var detail = app.balloons.dom.createNameValueDiv(element.name, element.value);
                        div.appendChild(detail);
                        break;
                }
            });
        }

        // Detect an image reference in the JSON response.
        if (json.hasOwnProperty('image') && json.image !== null) {
            var name = json.image;
            if (!!name && name !== '' && name != 'undefined' && name !== 'nil' && name.length > 1) {
                // This image reference is valid. Construct a URL to begin loading.
                var url = app.balloons.dom.image.getAssetImagePath(name, json.staging_area_asset_type.staging_area_company.layer.name.toLowerCase());
                var imgLink = document.createElement('a');
                imgLink.setAttribute('href', '#');
                var img = document.createElement('img');
                $(img).addClass('assetPhoto');
                img.setAttribute('src', url);
                imgLink.appendChild(img);
                $(imgLink).click(function () {
                    // TODO: Make asset image display window mobile-friendly
                    var strWindowFeatures = "location=yes,scrollbars=yes,status=yes";
                    window.open(url, "_blank", strWindowFeatures);
                });
                div.appendChild(imgLink);
            } else {
                app.ui.messageSpan.setError();
                throw new Error('Attempted to render Asset Details Container, but Asset details either failed to load or are empty.');
            }
        }

        // Display assets attached to this asset.
        if (json.staging_area_assets && json.staging_area_assets.length > 0) {
            var attached = document.createElement('div');
            attached.appendChild(app.balloons.dom.createElement('span', 'Attached Assets'));
            $.each(json.staging_area_assets, function (index, element) {
                var asset = app.balloons.dom.createElement('span', element.description);
                $(asset).addClass('block');
                attached.appendChild(asset);
            });
            div.appendChild(attached);
        }

        // Apply styles for the entire container here.
        $(div).addClass('assetDetailsContainer');
        return div;
    };

    // Renders DOM fragment to display Public Ship info.
    app.balloons.shipInfo = function(ship, layer_name) {
        var div = document.createElement('div');
        var title = app.balloons.dom.createElement('div', ship.name);
        title.className = 'balloon_title';
        // Center here image
        var a = document.createElement('a');
        a.setAttribute("title","Center map here.");
        a.href = "javascript:dedicatedmaps.ui.getMap().panTo(dedicatedmaps.layer." + layer_name + ".getAllMarkers[" + ship.asset_id + "].center())";
        var image = document.createElement('img');
        image.src = app.ui.icons.getIconPath("crosshairs");
        image.setAttribute("alt","Center map here.");
        image.setAttribute("class","crosshairs");
        a.appendChild(image);
        title.appendChild(a);
        div.appendChild(title);
        if (ship.owner)       div.appendChild(app.balloons.dom.createNameValueDiv('Owner: ', ship.owner));
        if (ship.icon && ship.icon.name)   div.appendChild(app.balloons.dom.createNameValueDiv('Type: ', ship.icon.name));
        if (ship.dim_bow)     div.appendChild(app.balloons.dom.createNameValueDiv('Size: ', (
            ship.dim_bow + ship.dim_stern) + 'm x ' + (ship.dim_port + ship.dim_starboard) + 'm')
        );
        if (ship.speed)       div.appendChild(app.balloons.dom.createNameValueDiv('Speed/Course: ', ship.speed + ' nm / ' + ship.cog + ' deg'));
        if (ship.draught)     div.appendChild(app.balloons.dom.createNameValueDiv('Draught: ', ship.draught / 10 + ' m'));
        if (ship.status)      div.appendChild(app.balloons.dom.createNameValueDiv('Status: ', ship.status));
        if (ship.destination) div.appendChild(app.balloons.dom.createNameValueDiv('Destination: ', ship.destination));
        if (ship.age) {
            div.appendChild(app.balloons.dom.createNameValueDiv('Received: ', ship.age))
        }
        if (ship.MMSI)  div.appendChild(app.balloons.dom.createNameValueDiv('MMSI: ', ship.MMSI));
        if (ship.lon)  div.appendChild(app.balloons.dom.createNameValueDiv('Long: ', ship.lon.toString()));
        if (ship.lat)  div.appendChild(app.balloons.dom.createNameValueDiv('Lat: ', ship.lat.toString()));
        return div;
    };


    // Public Ships namespace
    app.publicShips = {};

    // TODO: Public Ships sublayer JS

    app.publicShips.shipIcons = {};

    app.publicShips.shipDraw = function shipDraw(LinColor,FilColor,mlat,mlng,cog,dim2bow,dim2stern,dim2port,dim2starboard) {

        // direction of ship degrees from true north clockwise (input variable) (converted to radian measure by * Pi/180)
        var shipAngle = cog * Math.PI / 180;

        var OS = .0000125;           //google earth scaling factor meters to lat/long offset
        var shipLen = (dim2bow+dim2stern) *OS;  // vessel length in meters(input variable)
        var shipWid = ((dim2port+dim2starboard) *OS)/2; // vessel width in meters(input variable)
        var shipFront = dim2bow *OS;  // distance in meters from transmitter on vessel to front of vessel (input variable)
        var idim2port = dim2port * OS;
        var idim2starboard = dim2starboard * OS;

        // Center point of beacon  0 = A, ... 1 = B
        var pointa = new google.maps.LatLng(mlat, mlng);

        //create an array 'points' holding the polygon end points for the outline of the vessel
        var points = [];

        p_Lint(((-shipLen)*.9)+shipFront,-idim2port);
        p_Lint(((-shipLen)*.3)+shipFront,-idim2port);
        p_Lint(((-shipLen)*.18)+shipFront,-idim2port*.8);
        p_Lint(shipFront,idim2starboard-shipWid);
        p_Lint(((-shipLen)*.18)+shipFront,(idim2starboard*.8));
        p_Lint(((-shipLen)*.3)+shipFront,idim2starboard);
        p_Lint(((-shipLen)*.9)+shipFront,idim2starboard,7);
        p_Lint(((-shipLen)*1)+shipFront,idim2starboard*.8);
        p_Lint(((-shipLen)*1)+shipFront,-idim2port*.8);
        p_Lint(((-shipLen)*.9)+shipFront,-idim2port);

        var polygon = new GPolygon(points,LinColor , 2, 1, FilColor, 0.3);

        app.ui.getMap().addOverlay(polygon);

        function p_Lint(tpos,gpos){
            var nlat = mlat+(tpos * Math.cos(shipAngle) - gpos * Math.sin(shipAngle));
            var nlng = mlng+ (gpos * Math.cos(shipAngle) + tpos * Math.sin(shipAngle))/.69;
            var pint = new GLatLng(nlat,nlng);
            points.push(pint);
        }
    };

    app.publicShips.image = function(ship) {
        var roundedCog = Math.round(ship.cog/10)*10;
        return ship.suffix + "/" + ship.suffix + "_" + ((roundedCog == 0 || roundedCog == 360) ? "00" : roundedCog);
    };

    app.publicShips.ship_icon = function(item) {
        var icon_sizes = {"AIR":27, "APE":30, "Car":36, "Drg":36, "Fsh":29, "HSC":30, "Mil":34, "Pas":28 ,"Plt":29, "Tan":36, "Tow":27, "Tug":28, "UCG":30, "Uns":28, "Yct":30};
        var image = app.publicShips.image(item);

        // If we don't have an icon for this particular ship type + angle yet, make one.
        if ((app.publicShips.shipIcons[image]) == null ) {
            var url = app.ui.icons.getIconPath("markers/ships/" + image);
            var icon = {url: url,
                name: image};
            var size = icon_sizes[item.suffix];
            icon.iconSize = new google.maps.Size(size,size);
            app.publicShips.shipIcons[image] = icon;
            // icons.ship_uns,
        }
        return app.publicShips.shipIcons[image];
    };
    // {id: 285940, name: "SEA CLIPPER", suffix: "Car", cog: 292, lat: 46.9062…}
    app.publicShips.render = function(ship) {
        var icon = app.publicShips.ship_icon(ship);
        var position = new google.maps.LatLng(ship.lat, ship.lon);
        var marker = new google.maps.Marker({
            map: app.ui.getMap(),
            title: ship.name,
            icon: icon.url,
            position: position
        });
        marker.id = ship.id;
        app.balloons.addBubble(marker, 'public_ships');
        return marker;
    };

    // This is the main call that starts everything.
    app.onPageReady();
    return app
})();
