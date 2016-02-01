//--------------------------------------------------------------------------
// Main Dedicated Map constructor logic. Initializes Google Map.
//--------------------------------------------------------------------------

// need to count the enumerables in objects
function size(obj) {
    var size = 0;
    for (var key in obj) {
      size++;
    }
    return size;
};

function shipDraw(LinColor,FilColor,mlat,mlng,cog,dim2bow,dim2stern,dim2port,dim2starboard) {

  // direction of ship degrees from true north clockwise (input variable) (converted to radian measure by * Pi/180)
  var shipAngle = cog * Math.PI / 180;

  var OS = .0000125;           //google earth scaling factor meters to lat/long offset
  var shipLen = (dim2bow+dim2stern) *OS;  // vessel length in meters(input variable)
  var shipWid = ((dim2port+dim2starboard) *OS)/2; // vessel width in meters(input variable)
  var shipFront = dim2bow *OS;  // distance in meters from transmitter on vessel to front of vessel (input variable)
  var idim2port = dim2port * OS;
  var idim2starboard = dim2starboard * OS;

  // Center point of beacon  0 = A, ... 1 = B
  var pointa = new GLatLng(mlat, mlng);

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

  map.addOverlay(polygon);

  function p_Lint(tpos,gpos){
    var nlat = mlat+(tpos * Math.cos(shipAngle) - gpos * Math.sin(shipAngle));
    var nlng = mlng+ (gpos * Math.cos(shipAngle) + tpos * Math.sin(shipAngle))/.69;
    var pint = new GLatLng(nlat,nlng);
    points.push(pint);
  }
}

function update() {
  //GDownloadUrl("ships/update",updateShips);
  ajax_load("ships/update",updateShips);
}

function initialize(map_state) {
// Object {lat: 47.7361, lon: -122.268, map_type: "Hybrid", zoom: 3}
  if (true) { 
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
    map = new google.maps.Map(document.getElementById("map_div"), mapOptions);


    layer.map = map;

    var icons = [];

    /*
    *     Fishing Areas
    */

    // layer.fishing_areas = new Layer(map, "fishing_areas", "id", function(item) {return {title:item.strategy, icon:icons.yellow};}); 
    // layer.fishing_areas.render = overrides.areas.render;
    // layer.fishing_areas.load = overrides.areas.load;
    // layer.fishing_areas.show = overrides.areas.show;
    // layer.fishing_areas.hide = overrides.areas.hide;
    // layer.fishing_areas.categorization = "fishing_area_type_id";

    /*
    *     GRPs
    */

    layer.grps = new Layer(map, "grps", "id", function(item) {return {title:item.strategy, icon:get_icon('square_mini/yellow',true)};}); 

    layer.grps.load_booms = function (json) {
      var data = eval('(' + json + ')');
      var currList = [];
      for (var i = 0; i < data.length; i++) {
        var current = data[i];
        line = new GPolyline([new GLatLng(current.start_lat, current.start_lon), new GLatLng(current.end_lat, current.end_lon)], "#FFFF00", 6, 0.8);
        currList.push(line);
        this.list["boom" + current[this.id]] = line;
        line.refresh = this.refresh;
      }
      this.mgr.addMarkers(currList, 14);
    }; 

    //@Override, for booms
    layer.grps.on = function() {
      if (!this.loaded) {
        var name = this.name;
        ajax_load("/grp_booms.json",function(data){layer[name].load_booms(data);});
        ajax_load("/" + name + ".json",function(data){layer[name].load(data);});
      } else {
        this.show();
      }
    };

    layer.grps.replace = function(payload) {
      var text = layer.grpInfo(payload,'grps');
      var tab = new GInfoWindowTab("GRP Info", text);
      map.updateInfoWindow([tab]);
    };

    /*
    *     Staging Areas
    */

    var staging_area_replace = function(payload) {
      layer.set_staging_area_container(payload);
      var content = layer.stagingInfo(payload);
      var tab1 = new GInfoWindowTab("Info", content);
      if (payload.staging_area_assets.length > 0) {
        var equip = layer.stagingEquip(payload.staging_area_assets);
        var tab2 = new GInfoWindowTab("Equip", equip);
        map.updateInfoWindow([tab1, tab2]);
      } else {
        map.updateInfoWindow([tab1]);
      }
    };

    var staging_area_on = function() {
      if (!this.loaded) {
        var name = this.name;
        ajax_load("/staging_areas_company/" + name + ".json", function(data){layer[name].load(data);});
      }
      this.show();
    };

    // Instead of using the same icon instance for each marker for a given company, we have to create new ones for each marker
    // so that we can change the image for just that icon when we show equipment search results.
    // layer.crcs = new Layer(map, "crcs", "id", function(item) {return {title:item.name, icon:icons.blue};});
    // becomes
    // layer.crcs = new Layer(map, "crcs", "id", function(item) {var icon = new GIcon(icons.blue); return {title:item.name, icon:icon};});
    for (var i in layer_config) {
      if (layer_config[i].type == 'StagingArea') {
        var optsFn = function(item) {
          var icon_name = item.icon ? item.icon : layer_config[this.name].icon;
          var icon_obj = get_icon(icon_name, true);
          return {title:item.name, icon:icon_obj};
        };
        layer[i] = new Layer(map, i, "id", optsFn);
        layer[i].replace = staging_area_replace;
        layer[i].on = staging_area_on;
      }
    }
    
    /*
    *    Other Assets (items)
    */
    
    layer.my_items = new Layer(map, "my_items", "id", function(item) {return {title:item.name, icon:icons.green};});
    layer.my_items.replace = function(payload) {
      var content = layer.itemInfo(payload,"my_items");
      var tab1 = new GInfoWindowTab("Info", content);
      map.updateInfoWindow([tab1]);
    }
    
    /*
    *     Public Ships
    */

    layer.public_ships = new Layer(map, "public_ships", "id", function(item) {return {title:item.name, icon:this.ship_icon(item)};});
    layer.public_ships.categorization = "suffix";

    layer.public_ships.replace = function(payload) {
      if (payload.trip) { // this is a fishing vessel
        var tab = new GInfoWindowTab("Ship Info", layer.shipInfo(payload,'public_ships'));
        var fish = new GInfoWindowTab("Trip Info", layer.tripInfo(payload));
        var crew = new GInfoWindowTab("Crew", layer.crewInfo(payload));
        //map.updateInfoWindow([tab,crew,fish]);
        map.updateInfoWindow([tab,fish,crew]);
      } else {
        var text = layer.shipInfo(payload,'public_ships');
        var tab = new GInfoWindowTab("Ship Info", text);
        map.updateInfoWindow([tab]);
      }
    };

    layer.public_ships.image = function(ship) {
      var roundedCog = Math.round(ship.cog/10)*10;
      return ship.suffix + "/" + ship.suffix + "_" + ((roundedCog == 0 || roundedCog == 360) ? "00" : roundedCog);
    };

    layer.public_ships.refresh = function() {
      if (!this.hidden) {
        if (map.getZoom() < 14) {
          var roundedCog = Math.round(this.cog/10)*10;
          var image =  this.suffix + "/" + (this.dim ? "D_" : "") + this.suffix + "_" + ((roundedCog == 0 || roundedCog == 360) ? "00" : roundedCog);
          this.setImage("/images/markers/ships/" + image + ".png")
        } else {
          var point = this.getPoint();
          shipDraw("#FFC20E","#FFFFFF",point.lat(),point.lng(),this.cog,this.dim_bow,this.dim_stern,this.dim_port,this.dim_starboard);
        }
      } else {
        this.hide();
      }
    };

    layer.public_ships.ship_icon = function(item) {
      var icon_sizes = {"AIR":27, "APE":30, "Car":36, "Drg":36, "Fsh":29, "HSC":30, "Mil":34, "Pas":28 ,"Plt":29, "Tan":36, "Tow":27, "Tug":28, "UCG":30, "Uns":28, "Yct":30};
      var image = this.image(item);

      // If we don't have an icon for this particular ship type + angle yet, make one.
      if ((icons[image]) == null ) {
        var url = "/images/markers/ships/" + image + ".png";
        var icon = {url: url,
          name: image};
        var size = icon_sizes[item.suffix];
        icon.iconSize = new google.maps.Size(size,size);
        icons[image] = icon;
        // icons.ship_uns, 
      }
      return icons[image];
    };

    layer.public_ships.properties = ["cog", "suffix", "dim_bow", "dim_stern", "dim_port", "dim_starboard"];

    layer.my_ships = new Layer(map, "my_ships", "id", function(item) {return {title:item.name, icon:this.ship_icon(item)};});
    layer.my_ships.categorization = "suffix";
    layer.my_ships.image = layer.public_ships.image;
    layer.my_ships.replace = layer.public_ships.replace;
    layer.my_ships.ship_icon = layer.public_ships.ship_icon;
    layer.my_ships.properties = layer.public_ships.properties;

    layer.shared_ships = new Layer(map, "shared_ships", "id", function(item) {return {title:item.name, icon:this.ship_icon(item)};});
    layer.shared_ships.categorization = "suffix";
    layer.shared_ships.image = layer.public_ships.image;
    layer.shared_ships.replace = layer.public_ships.replace;
    layer.shared_ships.ship_icon = layer.public_ships.ship_icon;
    layer.shared_ships.properties = layer.public_ships.properties;

    layer.public_ships.update = function(data) {
      var updates = eval('(' + data + ')');
      for (var i = 0; i < updates.length; i++) {
        var current = updates[i];
        /* This should update the ships properly in accordanace with the marker manager; but I'll leave this complexity out for later.
        this.mgr.removeMarker(current.id);
        this.mgr.addMarker(this.render(current)); 
        */
        var image = this.image(current);
        this.list[current.id].setImage("/images/markers/ships/" + image + ".png");
      }
    };

    layer.public_ships.dim = function(category, bool) {
      function dimify(ship) {
        ship.dim = bool;
      }
      this.apply_to_all(dimify, category);
    }

    // Load layers if the browser remembered that they were checked
    // Load layer icons
    // for (var i in layer_config) {
    //   if ($(i).checked) layer[i].on();
    //   if (layer_config[i].icon) $(i + '_icon').src = icon_path(layer_config[i].icon); 
    // }

  }
}

// Loading indicator manager. If something doesn't have its
// own loader indicator, then use ajax_load() instead of GDownloadUrl()

ajax_calls = [];
ajax_calls_pop = function() {
  ajax_calls.pop();
  if (ajax_calls.length < 1) {
    jQuery('message').hide();
  }
}
function ajax_load(url, callback) {
  console.log("AJAX: " + url);
  if (ajax_calls.indexOf(url) == -1) {
    $('message').innerHTML = '<span style="color:red;">loading...</span>';
    $('message').show();
    ajax_calls.push(url);
    ajax_callback = function(data, status) {
      callback(data,status);
      ajax_calls_pop();
    }
    jQuery.get(url, ajax_callback).done(function() {
      $('message').innerHTML = 'Done';
    }).error(function () {
      $('message').innerHTML = '<span style="color:red;">Connection Error!</span>';
    });
  }
}

// Refresh data for checked layers
function refresh() {
  for (var i in layer_config) {
    if ($(i).checked) layer[i].reload();
  } 
}
refresher = {};
function auto_refresh(on) {
  if (on) {
    refresh();
    refresher = setInterval( "refresh()", 60 * 1000 );
  } else {
    clearInterval(refresher);
  }
}