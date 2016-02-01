// Handle icons for all of the map markers
function icon_path(name) {
  return 'http://dedicatedmaps.com/images/' + name + '.png';
}

// // Cache to reuse icon instances (careful with dynamic icons!)
// var icon_cache = {};

// function get_icon_config(name) {
//   var parts = name.split('/');
//   var config_name = '';
//   while (parts.length > 0) {
//     config_name = parts.join('/');
//     if (icon_config[config_name]) {
//       return icon_config[config_name];
//     } else {
//       parts.pop();
//     }
//   }
// }

// function get_shadow(name, config) {
//   if (config.shadow == 'self') {
//     return name + '.shadow';
//   } else {
//     var path = name.split('/');
//     path.pop();
//     path.push(config.shadow);
//     return path.join('/');
//   }
// }

function get_icon(name, cached_ok) {
  return icon_path(name);
}

// // Configuration settings for different types of icons
// var icon_config = {}
// icon_config['balloon_slant']     = { dims: [32,32],
//                                      anchor:[7,29],
//                                      info_anchor: [15,0],
//                                      shadow_dims: [49,32],                        
//                                      shadow: 'shadow'};                  
// icon_config['balloon_straight']  = { dims: [32,32],
//                                      anchor:[15,27],
//                                      info_anchor: [16,0],
//                                      shadow_dims: [49,32],
//                                      shadow: 'shadow'};
// icon_config['custom']            = { dims: [32,32],
//                                      anchor:[16,32],
//                                      info_anchor: [16,0],
//                                      shadow_dims: [59,32],
//                                      shadow: 'self'};
// icon_config['custom/arrow']      = { dims: [32,32],
//                                      anchor:[16,32],
//                                      info_anchor: [16,0],
//                                      shadow_dims: [39,34],
//                                      shadow: 'self'};
// icon_config['pushpin']           = { dims: [32,32],
//                                      anchor:[10,32],
//                                      info_anchor: [16,0],
//                                      shadow_dims: [49,32],
//                                      shadow: 'self'};
// icon_config['square_small']      = { dims: [27,27],
//                                      anchor:[13,27],
//                                      info_anchor: [13,0],
//                                      shadow_dims: [41,27],
//                                      shadow: 'shadow'};
// icon_config['square']            = { dims: [32,37],
//                                     anchor:[16,37],
//                                     info_anchor: [16,0],
//                                     shadow_dims: [51,37],
//                                     shadow: 'shadow'};
// icon_config['square_mini']       = { dims: [12,12],
//                                      anchor:[6,6],
//                                      info_anchor: [6,0]};
// icon_config['stars']             = { dims: [32,32],
//                                      anchor:[16,32],
//                                      info_anchor: [16,0]};
// icon_config['teardrop']          = { dims: [32,32],
//                                      anchor:[16,32],
//                                      info_anchor: [16,0],
//                                      shadow_dims: [59,32],
//                                      shadow: 'shadow'};
// icon_config['teardrop/alphabet'] = { dims: [20,34],
//                                      anchor:[10,34],
//                                      info_anchor: [10,0],
//                                      shadow_dims: [38,34],
//                                      shadow: 'shadow'};
// icon_config['teardrop_mini']     = { dims: [12,20],
//                                      anchor:[6,20],
//                                      info_anchor: [6,0],
//                                      shadow_dims: [22,20],
//                                      shadow: 'shadow'};

// /*
//   Old Icon Code \/  
// */


// // Create object to hold all markers
// var icons;

// icons = {
//    ship_uns: new google.maps.Icon(),
//    incident: new google.maps.Icon()
// };

// icons.incident.image = "/images/incidents/I_Complete_GRP.png";
// icons.incident.iconSize = new GSize(64,64);
// icons.incident.iconAnchor = new GPoint(6,6);
// icons.incident.infoWindowAnchor = new GPoint(5,1);
// icons.incident.imageMap = [5,0, 1,4, 1,8, 3,12, 8,12, 11,8, 11,4, 7,0];

// icons.ship_uns.image = "images/markers/ships/Uns/Uns_00.png";
// icons.ship_uns.iconSize = new GSize(32,32);
// icons.ship_uns.shadowSize = new GSize(34,24);
// icons.ship_uns.iconAnchor = new GPoint(12,9);
// icons.ship_uns.infoWindowAnchor = new GPoint(12,1);