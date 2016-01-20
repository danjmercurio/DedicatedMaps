function createElement(elemName, text) {
  var element = document.createElement(elemName);
  if (typeof(text) == 'string') {
    if (text !== '') element.appendChild(document.createTextNode(text));
  } else {
    element.appendChild(text);
  }
  return(element); 
}

function createNameValueDiv(name, value) {
  var div = document.createElement('div');
  var label_span = createElement('span', name);
  label_span.setAttribute('class', 'label');
  div.appendChild(label_span);
  var value_span = createElement('span', value);
  value_span.setAttribute('class', 'value');
  div.appendChild(value_span);
  return div;
}

function linkify(email_or_hlink) {
  var a = document.createElement('a');
  email_regex = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i;
  link_regex = /^[(www)(#?http:\/\/).*]/i;
  
  if (email_regex.test(email_or_hlink)) {
    a.setAttribute("href", "mailto:" + email_or_hlink);
  } else if (link_regex.test(email_or_hlink)) {
    if (email_or_hlink.substring(0,3) == 'www') email_or_hlink = 'http://' + email_or_hlink;
    email_or_hlink = email_or_hlink.replace( /^#?(.*)#?$/ , '$1' );
    a.setAttribute("href", email_or_hlink);
  } else {
    return email_or_hlink;
  }
  a.innerHTML = email_or_hlink;
  return a;
}
var buildInfoTabContainer = function(json, marker) {
  var div = document.createElement('div');
  if (json.staging_area_company) {
    jQuery(div).append(layer.set_staging_area_container(json));
  }
  jQuery(div).append("<br /><br />");
  if (json.contact) div.appendChild(createElement('div', json.contact));
  if (json.address) div.appendChild(createElement('div', json.address));
  if (json.city )   div.appendChild(createElement('span', json.city + ', '));
  if (json.state)   div.appendChild(createElement('span', json.state + ' '));
  if (json.zip)     div.appendChild(createElement('span', json.zip));
  if (json.phone)   div.appendChild(createNameValueDiv('Phone: ', json.phone));
  if (json.fax)     div.appendChild(createNameValueDiv('Fax: ', json.fax));
  if (json.email && json.email != "N/A")   {      
    jQuery(div).append("<span class='label'>Email: <a href='" + linkify(json.email) + "'>" + json.email + "</a></span>");
  }
  if (json.staging_area_details && json.staging_area_details.length > 0) {
    jQuery.each(json.staging_area_details, function(index, element) { 
      if (element.value.charAt(0) == '#') {
          jQuery(div).append("<span class='itemprop'>" + "<span style='color:#2C87F0;'>" + element.name + ":</span> <a target='_blank' href='" + element.value.substr(1, element.value.length - 2) + "'>" + element.value.substr(1, element.value.length - 2) + "</a></span>");

      } 
      else { // # This is super sloppy! Refactor!
          if (element.name !== "pdf_1" && element.name !== "pdf_2") jQuery(div).append("<span class='itemprop'>" + "<span style='color:#2C87F0;'>" + element.name + ":</span> " + element.value + "</span>");
      }    
      if (element.name == "pdf_1"){

        // Insert a page break for good looks
        div.appendChild(document.createElement('br'));

        // Eliminate any issues with case sensitivity
        var label = element.value.substr(0, element.value.lastIndexOf('.')).toUpperCase();

        // PDF icons for GRP layer
        var pdf1 = createElement('a', element.value)
        pdf1.setAttribute('href', "http://www.dedicatedmaps.com/pdf/" + label + ".pdf");
        pdf1.setAttribute('target', '_new');

        // Build thumbnail URL from PDF file path
        var thumb = "http://www.dedicatedmaps.com/pdf/thumbs/" + label + ".png";

        // Use document's createElement here since our createElement expects a text node
        var pdfThumb1 = document.createElement('img');
        pdfThumb1.setAttribute('src', thumb);
        pdfThumb1.setAttribute('height', '150px');
        pdfThumb1.setAttribute('width', '150px');
        
        pdf1.appendChild(document.createElement('br'));
        pdf1.appendChild(pdfThumb1);
        div.appendChild(pdf1);
        div.appendChild(document.createElement('br'));
      }
      if (element.name == "pdf_2"){
        
        // Eliminate any issues with case sensitivity
        var label = element.value.substr(0, element.value.lastIndexOf('.')).toUpperCase();

        //PDF icons for GRP layer
        var pdf2 = createElement('a', element.value)
        pdf2.setAttribute('href', "http://www.dedicatedmaps.com/pdf/" + label + ".pdf");
        pdf2.setAttribute('target', '_new');

        // Build thumbnail URL from PDF file path
        var thumb = "http://www.dedicatedmaps.com/pdf/thumbs/" + label + ".png";

        // Use document's createElement here since our createElement expects a text node
        var pdfThumb2 = document.createElement('img');
        pdfThumb2.setAttribute('src', thumb);
        pdfThumb2.setAttribute('height', '150px');
        pdfThumb2.setAttribute('width', '150px');

        pdf2.appendChild(document.createElement('br'));
        pdf2.appendChild(pdfThumb2);
        div.appendChild(pdf2); 
      }     
    });
  }
  return div;  
}

var buildEquipmentContainer = function(json, marker, infoBubble) {

              if (json.staging_area_assets && json.staging_area_assets.length > 0) {
                var div = document.createElement('div');
                jQuery(div).append(layer.set_staging_area_container(json));
                jQuery(div).append("<br /><br />");
                jQuery.each(json.staging_area_assets, function(name, el) { 
                  //for each piece of equipment...
                  var link = document.createElement('a');
                  link.setAttribute('style', 'display:block;');
                  link.innerHTML = el.description;
                  jQuery(div).append(link);
                  jQuery(link).click(function() {
                    var id = el.id;
                    jQuery.ajax({
                        beforeSend: function() {
                          console.log("AJAX REQUEST: " + "/staging_area_assets/" + id + ".json");
                        },
                        url: "/staging_area_assets/" + id + ".json",
                        error: function(reqObject, textstatus, errorthrown) {
                            console.log("ERROR: Resp code..." + errorthrown);
  
                        },
                        success: function(response, status, reqObject) {
                          var json = reqObject.responseJSON;
                          var getAssetDetailsContainer = function(json) {
                            var div = document.createElement(div);
                            jQuery(div).append("<b><span style='color:#2C89F0;'>" + json.description + "</b>");
                            jQuery(div).append('<br />');
                            jQuery.each(json.staging_area_asset_details, function(index, element) {
                            if (element.name == "Specification") {
                              jQuery(div).append("<ul><span style='color:#2C87F0;'>" + element.name + ": </span>" + element.value + "</ul>");
                            }
                            else if (element.name == "Serial_Number") {
                              jQuery(div).append("<ul><span style='color:#2C87F0;'>" + "Serial Number" + ": </span>" + element.value + "</ul>");
                            }
                            else if (element.name == "Manufacture") {
                              jQuery(div).append("<ul><span style='color:#2C87F0;'>" + element.name + ": </span>" + element.value + "</ul>");
                            }
                            else if (element.name == "Model") {
                              jQuery(div).append("<ul><span style='color:#2C87F0;'>" + element.name + ": </span>" + element.value + "</ul>");
                            }
                            else if (element.name == "Manufacture_Year") {
                              jQuery(div).append("<ul><span style='color:#2C87F0;'>" + "Manufacture Year" + ": </span>" + element.value + "</ul>");
                            }
                          });
                          jQuery.each(json.staging_area_asset_details, function(index, element) {
                            if (["Specification", "Serial_Number", "Manufacture", "Model", "Manufacture_Year"].indexOf(element.name) == -1) {
                              jQuery(div).append("<ul><span style='color:#2C87F0;'>" + element.name + ":</span> " + element.value + "</ul>");
                            }                           
                          });
                            jQuery.each(json, function(index, element){ 
                              if (index == 'image' && element != null && element != "null" && json.staging_area_asset_type.staging_area_company.layer.name) {
                                jQuery(div).append("<br />");
                                var url = 'http://174.143.157.90/asset_photos/' + json.staging_area_asset_type.staging_area_company.layer.name.toLowerCase() + '/' + encodeURIComponent(element);
                                console.log(url);
                                var imglink = document.createElement('a');
                                imglink.setAttribute('href', '#');
                                var img = document.createElement('img');
                                img.setAttribute('height', '75px');
                                img.setAttribute('src', url);
                                img.setAttribute('target', '_blank');
                                jQuery(imglink).click(function() {
                                  var strWindowFeatures = "location=yes,height=570,width=520,scrollbars=yes,status=yes";                                  
                                  var win = window.open(url, "_blank", strWindowFeatures);
                                });
                                jQuery(imglink).append(img);
                                jQuery(div).append(imglink);
                                jQuery(div).append("<br /><br />");
                              }                             
                            });
                          var children = json.staging_area_assets;
                          if (children.length > 0) {
                              jQuery(div).append("<span style='display:block;'>Attached Assets</span>");
                              jQuery.each(children, function(index, element) {
                                var newelem = document.createElement('span');
                                newelem.innerHTML = element.description;
                                jQuery(div).append(newelem);
                                jQuery(div).append("<br />");
                              });
                          }
                          
                          return div;
                          }
                          //if infoBubble.tabs_ contains a 'Detail' tab, update it, else, add a new tab
                          if (infoBubble.tabs_.length >= 3) {
                            infoBubble.updateTab('2', 'Detail', getAssetDetailsContainer(reqObject.responseJSON));
                            infoBubble.setTabActive_(infoBubble.tabs_[2].tab);
                          } else {
                            infoBubble.addTab('Detail', getAssetDetailsContainer(reqObject.responseJSON));
                            infoBubble.setTabActive_(infoBubble.tabs_[2].tab);
                          }                                                                
                        }
                      });
                  });
                });                              
              }
              return div;
            }
var buildShipInfoContainer = function(json, marker) {
  var div = document.createElement('div');
  if (json.name) {
    jQuery(div).append("<ul><span style='color:#2C87F0;'>" + "Name" + ": </span>" + json.name + "</ul>");}
  if (json.status) {
    jQuery(div).append("<ul><span style='color:#2C87F0;'>" + "Status" + ": </span>" + json.status + "</ul>");
  }
  if (json.speed) {
    jQuery(div).append("<ul><span style='color:#2C87F0;'>" + "Speed/Course" + ": </span>" + json.speed + "</ul>");
  }
  if (json.destination) {
    jQuery(div).append("<ul><span style='color:#2C87F0;'>" + "Destination" + ": </span>" + json.destination + "</ul>");
  }
  if (json.eta) {
  jQuery(div).append("<ul><span style='color:#2C87F0;'>" + "ETA" + ": </span>" + json.eta + "</ul>");
  }
  return div;
};
layer.shipInfo = function(ship,layer_name) {
  var div = document.createElement('div');
  //div.setAttribute('class','info_window');
  var title = createElement('div', ship.name);
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
  //if (ship.icon.name)   div.appendChild(createNameValueDiv('Type: ', ship.icon.name));
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