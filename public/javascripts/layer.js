layer = {};   // global
layer.ready = false;
layer.add = function(name, id, optsFn) {
  this[name] = new Layer(this.map, name, id, optsFn);
};

//move these to external file
String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};
String.prototype.replaceAll = function(str1, str2, ignore) {
    return this.replace(new RegExp(str1.replace(/([\/\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g,"\\$&"),(ignore?"gi":"g")),(typeof(str2)=="string")?str2.replace(/\$/g,"$$$$"):str2);
};

/**
* Superclass for handling "layers", lists of markers of a specific type
* @class Markers 
* @constructor 
* @param {String} name The type of object, in particular, the name of the resource.  Uses this to AJAX request info about a particular object via http://"name"/idNum 
* @param {String} id Database column name to use as a key to reference specific markers.
* @param {Function} optsFn A function that takes a specific object and retuns a GMarkerOptions instance.
*/

function Layer(map, name, id, optsFn) {
  this.mgr = new MarkerManager(map);
  this.id = id;
  this.name = name;
  this.optsFn = optsFn;
  this.loaded = false;
  this.list = {};
  this.map = map;
}

Layer.prototype.refresh = function() {};
Layer.prototype.load_callback = function() {};

Layer.prototype.on = function() {
  if (!this.loaded) {
    var name = this.name;
    ajax_load("/" + name + ".json", function(data){layer[name].load(data);});
  }
  this.show();
};

Layer.prototype.off = function() {
  this.hide();
};

Layer.prototype.toggle = function() {this.mgr.toggle();};
Layer.prototype.show = function() {this.mgr.show();};
Layer.prototype.hide = function() {this.mgr.hide();};
Layer.prototype.visible = function() {this.mgr.visible();};

google.maps.Marker.prototype.center = function() {
  map.panTo(this.getPosition());
};

google.maps.Marker.prototype.centerOpen = function() {
  this.center();
  google.maps.event.trigger(this, "click"); 
};

// Called by the refresh button if the layer is checked.
Layer.prototype.reload = function() {
  if (this.loaded) {
    this.clear_markers();
    this.loaded = false;
    this.on();
  }
};

/**
* Load the results of an XMLHTTPRequest into a list of map markers
* @method load
* @param {String} dataStr The returned contents of the HTTP request.
*/
Layer.prototype.component = {};

Layer.prototype.load = function (dataStr) {
  //var data = eval('(' + dataStr + ')');
  var data = dataStr;
  var currList = [];
  for (var i = 0; i < data.length; i++) {
    var current = data[i];
    marker = this.render(current);
    currList.push(marker);
    this.list[current[this.id]] = marker;
  }
  this.mgr.addMarkers(currList, 3);
  this.mgr.refresh();
  this.loaded = true;
  this.load_callback();
  this.load_callback = function() {};
};

Layer.prototype.clear_markers = function () {
   for (var item in this.list) {
     var current = this.list[item];
     google.maps.event.clearInstanceListeners(current);
   }
  this.mgr.clearMarkers();
  this.mgr = new MarkerManager(map);
  this.list = [];
}

loader = (function() {
    var div = document.createElement(div);
    div.id = "loading";
    div.setAttribute("style","margin-top:10px; text-align: center;");
    var spinner = document.createElement('img');
    spinner.setAttribute("src","/images/ajax-loader.gif");
    div.appendChild(spinner);
    return(div);
})();
var infoBubble = null;
//returns a marker, given data
Layer.prototype.render = function(current) {

  options = this.optsFn(current);
  icon = options['icon'];
  title = options['title'];
  var latlng = new google.maps.LatLng(current.lat, current.lon);
  var marker = new google.maps.Marker({
   position: latlng,
   title: title,
   icon: icon
  });
  marker.id = current[this.id];
  
  var name = this.name;
  var balloon_style = this.balloon_style;
  
  if (!current.no_info) {
    google.maps.event.addListener(marker, 'click', function(){ 
      layer.waiting = name;

      if (infoBubble && infoBubble.isOpen()) {
        infoBubble.close();
      }
      //marker has been clicked
        //initialize the infoBubble for each marker
        infoBubble = new InfoBubble({
           maxHeight: 250,
            minHeight: 250,
            maxWidth:400,
            minWidth: 400,
            marker: marker,
            map: layer.map,
            position: latlng,
            disableAutoPan: false
          });
        //open the bubble
        if (infoBubble && !infoBubble.isOpen()) {
          infoBubble.open();
        }
        jQuery.ajax({
          beforeSend: function() {
            infoBubble.addTab('Loading...', loader);
            console.log("AJAX REQUEST: " + "/marker/" + name + "/" + marker.id + ".json");
          },
          url: "/marker/" + name + "/" + marker.id + ".json",
          error: function(reqObject, textstatus, errorthrown) {
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
              infoBubble.addTab('Equip', buildEquipmentContainer(json, marker));
            }
           } 
            
          }
        } //end of ajax() param lists
      );
    });
    google.maps.event.addListener(marker, 'infowindowopen', function(){ 
      layer.ready = true;
    });
    google.maps.event.addListener(marker, 'infowindowclose', function(){ 
      layer.ready = false;
    });
    //close the bubble if user clicks outside the map
    google.maps.event.addListener(layer.map, 'click', function() {
      if (infoBubble && infoBubble.isOpen()) {
        infoBubble.close();
      }
    });
  }
  marker.hidden = false;
  marker.refresh = this.refresh;
  if (this.properties) {
    for (var i = 0; i < this.properties.length; i++) {
      var prop = this.properties[i];
      marker[prop] = current[prop];
    }
  }
  return marker;
};

layer.catcher = function(json) {
  layer.payload = eval('(' + json + ')');
  layer.check();
};

layer.check = function() {
  if (layer.ready) {
    layer[layer.waiting].replace(layer.payload);
  } else {
    setTimeout(layer.check, 500);
  }
};
Layer.prototype.apply_to_all = function(func, type){
  for (var item in this.list) {
    var current = this.list[item];
    if (current[this.categorization] == type) {
      func(current);
    }
  }
  this.mgr.refresh();
};

Layer.prototype.set = function(type, property, value){
  for (var item in this.list) {
    var current = this.list[item];
    if (current[this.categorization] == type) {
     current[property] = value;
    }
  }
  this.mgr.refresh();
};

Layer.prototype.hide_all = function(type){
 for (var item in this.list) {
    var current = this.list[item];
    if (current[this.categorization] == type) {
      current.hide();
    }
  }
};

Layer.prototype.show_all = function(type){
 for (var item in this.list) {
    var current = this.list[item];
    if (current[this.categorization] == type) {
      current.show();
    }
  }
};

// Temporary Poly rendering function:
// GPolyline.prototype.getPoint = function() {return this.getBounds().getCenter();};
// GPolygon.prototype.getPoint = function() {return this.getBounds().getCenter();};
// Layer.prototype.renderPoly = function(current) {
//   var latlng = new GLatLng(current.lat, current.lon);
//   var points = [];
//   for (var i = 0; i < current.points.length; i++) {
//     var point = current.points[i];
//     points.push(new GLatLng(point.lat, point.lon));
//   }
//   if (current.type == "L") {
//     var marker = new GPolyLine(points);   
//   } else if (current.type == "P") {
//     alert("Hello! You shouldn't be seeing this.");
//   }
//   var marker = new GPolyline(points, "#0000FF", 1, 0.8);
//   GEvent.addListener(marker, 'click', function(){});
//   marker.id = current[this.id];
//   return marker;
// };

Layer.prototype.search_filter = function(arg) {

  // this.callback = function(data, responseCode) {
  //   if ([200,304].indexOf(responseCode) != -1) {
  //     this.clear_markers();
  //     this.load(data);
  //   } else if (responseCode == -1) {
  //     alert("Data request timed out. Please try later.");
  //   } else {
      
  //   }
  // };

  var my_layer = this;
  // ajax_load(
  //   ,
  //   function(data,responseCode){my_layer.callback(data, responseCode);}
  // );
  var url = ['/search', 'staging_areas', this.name, arg + '.json'].join('/');
  jQuery.ajax({
    url: url,
    success: function(data) {
      my_layer.clear_markers();
      my_layer.load(JSON.parse(data));
    },
    error: function() { alert("Error processing search. Please try later."); }
  });
}


// Set the title bar so we can use it for multiple tabs in a
// balloon
layer.set_staging_area_container = function(info){
  var container = document.createElement(div);
  container.setAttribute('class','balloon');
    var title = document.createElement(div);
      title.setAttribute("class","balloon_title");
      // Center here image
      var a = document.createElement('a');
      a.setAttribute("title","Center map here.");
      a.href = "javascript:map.panTo(new google.maps.LatLng(" + info.lat + "," + info.lon + "));";
        var image = document.createElement('img');
        image.src = "/images/crosshairs.png";
        image.setAttribute("alt","Center map here.");
        image.setAttribute("class","crosshairs");
        a.appendChild(image);
      title.appendChild(a);  
      
      // Location name    
      title.appendChild(document.createTextNode(info.name));
      var header = document.createElement(div);
        header.setAttribute("class","balloon_company");
        header.appendChild(document.createTextNode(info.staging_area_company.title));
        title.appendChild(header);
    container.appendChild(title);
    var div = document.createElement(div);
    div.setAttribute('class','info_window');
  container.appendChild(div);
  return container;
};

layer.stagingInfo = function(info) {
  //var container = layer.staging_area_container.cloneNode(1);
  var div = document.createElement('div');
  if (info.contact) div.appendChild(createElement(div, info.contact));
  if (info.address) div.appendChild(createElement(div, info.address));
  if (info.city )   div.appendChild(createElement('span', info.city + ', '));
  if (info.state)   div.appendChild(createElement('span', info.state + ' '));
  if (info.zip)     div.appendChild(createElement('span', info.zip));
  if (info.phone)   div.appendChild(createNameValueDiv('Phone: ', info.phone));
  if (info.fax)     div.appendChild(createNameValueDiv('Fax: ', info.fax));
  if (info.email && info.email != "N/A")   {
    var a = document.createElement('a');
    a.setAttribute("href", "mailto:" + info.email);
    a.innerHTML = info.email;
    div.appendChild(createNameValueDiv('Email: ', linkify(info.email)));
  }
  d = info.staging_area_details;
  if (d.length > 0) {
    div.appendChild(createElement('hr', ''));
    for(var i = 0; i < d.length; i++) {
       //div.appendChild(createNameValueDiv(d[i].name + ": ", linkify(d[i].value)));
    }
  }
  return(container);
};

layer.stagingAreaAssetsTable = function(equip) {
  if( !equip || equip.length <= 0) { return null; }

  var table = document.createElement('table');
  var header = document.createElement('tr');
  header.appendChild(createElement('th', 'Type'));
  header.appendChild(createElement('th', 'Asset'));
  table.appendChild(header);
  for(var i = 0; i < equip.length; i++) {
    var row =  document.createElement('tr');
    row.appendChild(createElement('td', equip[i].staging_area_asset_type.name));
    var title = createElement('td', '');
      var a = document.createElement('a');
        a.setAttribute('class', 'attachedAsset');
        a.setAttribute('data-id', equip[i].id);
        a.innerHTML = equip[i].description;
        a.href = "#";
      title.appendChild(a);
    row.appendChild(title);
    table.appendChild(row);
  }

  return table;
}
layer.stagingEquip = function(equip) {
  var container = layer.staging_area_container.cloneNode(1);
  var div = container.lastChild;
  var table = layer.stagingAreaAssetsTable(equip);
  div.appendChild(table);
  return(container);
};

layer.updateEquipmentDetails = function(json) {
  var info = eval('(' + json + ')');
  var container = layer.staging_area_container.cloneNode(1);
  var div = container.lastChild;
  d = info.staging_area_asset_details;
  d.unshift({name:'Type: ', value: info.staging_area_asset_type.name});
  d.unshift({name:'Asset: ', value: info.description});
  if (d.length > 0) {
     for(var i = 0; i < d.length; i++) {
        div.appendChild(createNameValueDiv(d[i].name + ": ", d[i].value));
     }
  }
  if (info.image) {
    var image = document.createElement('img');
    image.setAttribute('class', 'image-thumb');
    image.src = "http://174.143.157.90/asset_photos/" +
      info.staging_area_asset_type.staging_area_company.layer.name.toLowerCase() +
      "/" + encodeURIComponent(info.image);
    div.appendChild(image);
    var a = document.createElement('a');
    a.href = image.src;
    a.setAttribute('target', '_blank');
    image = document.createElement('img');
    image.src = "/images/zoom_in.png";
    a.appendChild(image);
    div.appendChild(a);
  } else {
    div.appendChild(createNameValueDiv("Photo: ","n/a"));
  }

  // Display children assets if any exist
  var children = layer.stagingAreaAssetsTable(info.staging_area_assets);
  if (children) {
      var childrenContainer = document.createElement(div);
      childrenContainer.setAttribute('class', 'children-asset-container');

      var heading = document.createElement(div);
      heading.setAttribute('class','children-heading');
      heading.innerHTML = "Attached Assets"

      childrenContainer.appendChild(heading);
      childrenContainer.appendChild(children);
      div.appendChild(childrenContainer);
  }
  
  
  // Rebuild info window
  win = map.getInfoWindow();
  tabs = win.getTabs();
  tabs[2] = new GInfoWindowTab("Detail", container);
  win.reset(win.getPoint(), tabs, null, win.getPixelOffset(), 2);
};

layer.getEquipmentDetails = function(id) {
  
  // var win = map.getInfoWindow();
  // var tabs = win.getTabs();
  // tabs[2] = new GInfoWindowTab("Detail", loader);
  // win.reset(win.getPoint(), tabs, null, win.getPixelOffset(), 2);
  // GDownloadUrl("/staging_area_assets/" + id + ".json", layer.updateEquipmentDetails);


};

layer.grpInfo = function(info, layer_name) {
  var div = document.createElement(div);
    div.setAttribute('class','info_window');
      var title = document.createElement(div);
        title.setAttribute("class","balloon_title");
    
        // Center here image
        var a = document.createElement('a');
        a.setAttribute("title","Center map here.");
        a.href = "javascript:map.panTo(layer." + layer_name + ".list[" + info.id + "].center())";
          var image = document.createElement('img');
          image.src = "/images/crosshairs.png";
          image.setAttribute("alt","Center map here.");
          image.setAttribute("class","crosshairs");
          a.appendChild(image);
        title.appendChild(a);
      
      if (info.strategy) title.appendChild(document.createTextNode(info.strategy));
      if (info.location_name) {
        title.appendChild(document.createTextNode(" "));
        title.appendChild(document.createTextNode(info.location_name));
      }
    div.appendChild(title);
    var locLine = document.createElement(div);
      locLine.appendChild(createElement('span', info.lat_string));
      locLine.appendChild(document.createTextNode(", "));
      locLine.appendChild(createElement('span', info.lon_string));
    div.appendChild(locLine);
    if (info.staging_area)    div.appendChild(createNameValueDiv('Staging Area: ', info.staging_area));
    if (info.site_access)     div.appendChild(createNameValueDiv('Site Access: ', info.site_access));
    if (info.boom_length)     div.appendChild(createNameValueDiv('Boom length: ', info.boom_length));
    if (info.flow_level)      div.appendChild(createNameValueDiv('Flow level: ', info.flow_level));
    if (info.response)        div.appendChild(createNameValueDiv('Response strategy: ', info.response));
    if (info.implementation)  div.appendChild(createNameValueDiv('Strategy implementation: ', info.implementation));
    if (info.resource)        div.appendChild(createNameValueDiv('Resources protected: ', info.resource));
  return(div);
};

layer.itemInfo = function(item, layer_name) {
  var div = document.createElement(div);
  div.setAttribute('class','info_window');
  var title = createElement(div, item.name);
  title.className = 'balloon_title';
    // Center here image
     var a = document.createElement('a');
     a.setAttribute("title","Center map here.");
     a.href = "javascript:map.panTo(layer." + layer_name + ".list[" + item.asset_id + "].center())";
       var image = document.createElement('img');
       image.src = "/images/crosshairs.png";
       image.setAttribute("alt","Center map here.");
       image.setAttribute("class","crosshairs");
       a.appendChild(image);
     title.appendChild(a);
   div.appendChild(title);
  if (item.lat)       div.appendChild(createNameValueDiv('Lat: ', item.lat)); 
  if (item.lon)       div.appendChild(createNameValueDiv('Lon: ', item.lon));
  if (item.timestamp) div.appendChild(createNameValueDiv('Timestamp: ', item.timestamp));
  for(var i in item.details) {
    div.appendChild(createNameValueDiv(i+': ', item.details[i]));
  }
  return(div);
};

layer.shipInfo = function(ship,layer_name) {
  var div = document.createElement(div);
  div.setAttribute('class','info_window');
  var title = createElement(div, ship.name);
  title.className = 'balloon_title';   
    // Center here image
    var a = document.createElement('a');
    a.setAttribute("title","Center map here.");
    a.href = "javascript:map.panTo(layer." + layer_name + ".list[" + ship.asset_id + "].center())";
      var image = document.createElement('img');
      image.src = "/images/crosshairs.png";
      image.setAttribute("alt","Center map here.");
      image.setAttribute("class","crosshairs");
      a.appendChild(image);
    title.appendChild(a);
  div.appendChild(title);
  if (ship.owner)       div.appendChild(createNameValueDiv('Owner: ', ship.owner)); 
  if (ship.icon.name)   div.appendChild(createNameValueDiv('Type: ', ship.icon.name));
  if (ship.dim_bow)     div.appendChild(createNameValueDiv('Size: ', (
      ship.dim_bow + ship.dim_stern) + 'm x ' + (ship.dim_port + ship.dim_starboard) + 'm')
  );
  if (ship.speed)       div.appendChild(createNameValueDiv('Speed/Course: ', ship.speed + ' nm / ' + ship.cog + ' deg'));
  if (ship.draught)     div.appendChild(createNameValueDiv('Draught: ', ship.draught / 10 + ' m'));
  if (ship.status)      div.appendChild(createNameValueDiv('Status: ', ship.status));
  if (ship.destination) div.appendChild(createNameValueDiv('Destination: ', ship.destination));
  if (ship.age) {div.appendChild(createNameValueDiv('Received: ', ship.age))};  
  if (ship.MMSI)  div.appendChild(createNameValueDiv('MMSI: ', ship.MMSI));
  if (ship.lon)  div.appendChild(createNameValueDiv('Long: ', ship.lon));
  if (ship.lat)  div.appendChild(createNameValueDiv('Lat: ', ship.lat)); 
  return(div);
};

layer.tripInfo = function(info) {
  var div = document.createElement(div);
  div.setAttribute('class','info_window');
  div.appendChild(createNameValueDiv('Confirmation: ', info.trip.confirmation)); 
  var title = createElement('span', 'Declared Gear');
  title.className = 'label';
  div.appendChild(title);
  div.appendChild(createElement('br'));
  for(var i = 0; i < info.gear.length; i++) {
    div.appendChild(document.createTextNode(info.gear[i]));
    div.appendChild(createElement('br'));
  }
  div.appendChild(createElement('br'));
  
  title = createElement('span', 'Declared Catch');
  title.className = 'label';
  div.appendChild(title);
  div.appendChild(createElement('br'));
  for(i = 0; i < info.intended.length; i++) {
    div.appendChild(document.createTextNode(info.intended[i]));
    div.appendChild(createElement('br'));
  }
  div.appendChild(createElement('br'));
  
  var title = createElement('span', 'Actual Catch');
  title.className = 'label';
  div.appendChild(title);
  div.appendChild(createElement('br'));
  for(var i = 0; i < info.actual.length; i++) {
    div.appendChild(document.createTextNode(info.actual[i]));
    div.appendChild(createElement('br'));
  }
  
  return(div);
};

layer.crewInfo = function(info) {
  var div = document.createElement(div);
  div.setAttribute('class','info_window');
  for(var i = 0; i < info.crew.length; i++) {
    div.appendChild(document.createTextNode(info.crew[i]));
    div.appendChild(createElement('br'));
  }
  return(div);
};

layer.gearInfo = function(info) {
  var div = document.createElement(div);
    div.setAttribute('class','info_window');
    div.appendChild(createElement('strong', info.name));
    if (info.contact) div.appendChild(createElement(div, info.contact));
    if (info.address) div.appendChild(createElement(div, info.address));
    if (info.city )   div.appendChild(createElement('span', info.city + ', '));
    if (info.state)   div.appendChild(createElement('span', info.state + ' '));
    if (info.zip)     div.appendChild(createElement('span', info.zip));
    if (info.phone)   div.appendChild(createNameValueDiv('Phone: ', info.phone));
    if (info.fax)     div.appendChild(createNameValueDiv('Fax: ', info.fax));
    if (info.email)   div.appendChild(createNameValueDiv('Email: ', info.email));
    var controls = document.createElement(div);
      controls.id = "controls";
      var a = document.createElement('a');
        a.innerHTML = "Center map here";
        a.href = "javascript:layer." + layer + ".list["+ info.id +"].center()";
      controls.appendChild(a);
    div.appendChild(controls);
  return(div);
};

var overrides = {ships:null, areas:null, staging_areas:null, kmls:null};
overrides.areas = {id:"id"};
overrides.kmls = {geoXml:{}};

overrides.areas.render = function(item) {
  var latlng = new GLatLng(item.lat, item.lon);
  var points = [];
  for (var i = 0; i < item.fishing_area_points.length; i++) {
    var point = item.fishing_area_points[i];
    points.push(new GLatLng(point.lat, point.lon));
  }
  if (item.line_type == "L") {
    var overlay = new GPolyline(points, "#0000FF", 1, 0.8);
  } else if (item.line_type == "P") {
    var overlay = new GPolygon(points, "#0000FF", 0, 0, item.color, 0.5 );
  }
  GEvent.addListener(overlay, 'click', function(){ 
    alert(item.name);
  });
  overlay.id = item[this.id];
  overlay.lt = item.line_type;
  overlay[this.categorization] = item[this.categorization];
  return overlay;
};

overrides.areas.load = function(dataStr) {
  var data = eval('(' + dataStr + ')');
  for (var i = 0; i < data.length; i++) {
    var current = data[i];
    overlay = this.render(current);
    this.list[current[this.id]] = overlay;
    map.addOverlay(overlay);
  }
  this.loaded = true;
}; 

overrides.areas.show = function() {
  for (item in this.list) {
    var current = this.list[item];
    current.show();
  }
};

overrides.areas.hide = function() {
  for (item in this.list) {
    var current = this.list[item];
    current.hide();
  }
};

overrides.booms = {render: function (item) {
  return(new GPolyline([new GLatLng(item.Start_Lat, item.Start_Long), new GLatLng(item.End_Lat, item.End_Long)], "#0000FF", 6, 0.8));
}}

Layer.prototype.balloon_style = "populate";

// KML layers

kml_layer_on = function() {
  for (var id in layer[this.name].geoxmls) {
    if ($('kml_'+id).checked) {
      kml_load(layer[this.name].geoxmls[id], layer[this.name].geoxmls[id].url);
    }
  }
}

kml_layer_off = function() {
  for (var id in layer[this.name].geoxmls) {
    $('kml_'+id).setValue(0);
    layer[this.name].geoxmls[id].setMap(null);
  }
  layer[this.name].geoxmls = {};
};

kml_load = function(id, url) {
  // var geoXml = new GGeoXml(url);
  // layer[this.name].geoxmls[id] = geoXml;
  // if ($(this.name).checked) map.addOverlay(geoXml);
  // $('message').innerHTML = '<span style="color:red;">loading...</span>';
  // $('message').show();
  // ajax_calls.push(url);
  
  // GEvent.addListener(geoXml, 'load', function() {
  //   if (geoXml.loadedCorrectly()) {
  //     //conflicts with Gmaps 3
  //     //geoXml.gotoDefaultViewport(map);
  //   } else {
  //     $('message').innerHTML = '<span style="color:red;">Error loading kml/z.</span>';
  //   }
  //   ajax_calls_pop();
  // });
  console.log("Loading KML");
  console.log(url);
  var geoXml = new google.maps.KmlLayer({
    url: url,
    map: map
  });
  layer[this.name].geoxmls[id] = geoXml;
}

kml_on = function(id, url) {
  // if ( layer[this.name].geoxmls.hasOwnProperty(id) ) {
  //   if ($(this.name).checked) map.addOverlay( layer[this.name].geoxmls[id] );
  // } else {
  //   this.kml_load(id, url);
  // }
  if ($(this.name).checked) {
    this.kml_load(id, url);
  }
}

kml_off = function(id) {
  if (layer[this.name].geoxmls[id]) {
    layer[this.name].geoxmls[id].setMap(null);
    delete layer[this.name].geoxmls[id];
  }
}

function Kml(name) {
  this.name = name;
  this.geoxmls = {};
}

function add_kml(kml) {
  layer[kml.name]           = kml;
  layer[kml.name].on        = kml_layer_on;  
  layer[kml.name].off       = kml_layer_off;
  layer[kml.name].kml_on    = kml_on;
  layer[kml.name].kml_load  = kml_load;
  layer[kml.name].kml_off   = kml_off;
}