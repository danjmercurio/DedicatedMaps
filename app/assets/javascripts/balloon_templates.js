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

        jQuery.each(json.staging_area_details, function(index, element) {
            if (element.value.charAt(0) == '#') {
                //jQuery(div).append("<span class='itemprop'>" + "<span style='color:#2C87F0;'>" + element.name + ":</span> <a target='_blank' href='" + element.value.substr(1, element.value.length - 2) + "'>" + element.value.substr(1, element.value.length - 2) + "</a></span>");

            }
            else { // # This is super sloppy! Refactor!
                if (filtered.indexOf(element) == "-1") jQuery(div).append("<span class='itemprop'>" + "<span style='color:#2C87F0;'>" + element.name + ":</span> " + element.value + "</span>");
            }

        });

        // The span that will hold GRP pdfs
        var pdfspan = document.createElement('span');

        jQuery.each(filtered, function(index, element) {
            var label = element.value.substr(0, element.value.lastIndexOf('.')).toUpperCase();

            // Create a link and make it open in a new tab
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

            pdf2.appendChild(pdfThumb2);
            pdfspan.appendChild(pdf2);

            // Finally, append the PDF span to the div

            div.appendChild(pdfspan);
        });
    }
    return div;
}

var buildEquipmentContainer = function(json, marker, infoBubble) {
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