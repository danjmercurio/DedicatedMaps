class DedicatedMaps
  this.version = 1.0
  this.author = "Dan Mercurio dan.j.mercurio@gmail.com"

  # Return the div that holds the map as a DOM element with jQuery
  getMapDiv: ->
    $('div#map_div')[0]

  initializeMap: (@map_div)->
    tempInstance = this
    google.maps.event.addDomListener(window, 'load', ->
# TODO: Load these in via Ajax from the user
      map_state = {
        "zoom": 7,
        "lon": -123.391,
        "lat": 47.8933,
        "map_type": 'roadmap'
      }

      map_types = {
        "hybrid": google.maps.MapTypeId.HYBRID,
        "satellite": google.maps.MapTypeId.SATELLITE,
        "roadmap": google.maps.MapTypeId.ROADMAP,
        "terrain": google.maps.MapTypeId.TERRAIN
      }
      mapOptions = {
        center: new google.maps.LatLng(map_state.lat, map_state.lon),
        zoom: map_state.zoom,
        mapTypeId: map_types[map_state.map_type.toLowerCase()]
      }
      tempInstance.map = new google.maps.Map(map_div, mapOptions)
      google.maps.event.addDomListener(tempInstance.map, "dragend", this.cue_save_map)
      google.maps.event.addDomListener(tempInstance.map, "maptypeid_changed", this.cue_save_map)
    )
    return tempInstance.map

# Set options on the map and display it after page load
  constructor: (window) ->
    @window = window
    @map_div = this.getMapDiv(window)
    @map = this.initializeMap(@map_div)

  cue_save_map: ->
    console.log("Caught signal to save map...")
  # TODO: Save map state

  this.getVersion = (version) ->
    console.log(version)

  # A generic observer for a DOM element
  observe: (element, callback) ->
    $(element).change(callback)

  getMap: ->
    this.map

class UserInterface extends DedicatedMaps
  constructor: () ->
    super(DedicatedMaps)
    @message_div = this.getMessageDiv()
    @image_directory = "http://www.dedicatedmaps.com/images"

# A spinning loading indicator for the DOM (returns an element)
  loader: ->
    div = document.createElement(div)
    div.id = "loading"
    div.setAttribute("style", "margin-top:10px; text-align: center;")
    spinner = document.createElement('img')
    spinner.setAttribute("src", "/images/ajax-loader.gif")
    div.appendChild(spinner)
    return div

# Returns a jQuery object, not an element!
  getMessageDiv: ->
    $('div#message')

  getIconPath: (name) ->
    "#{this.image_directory}/#{name}.png"

  getIcon: (name) ->
    this.ajaxLoad({url: this.getIconPath(name)}).responseText

# Route Ajax calls through this function to pair them with the UI notification
  ajaxLoad: (ajaxRequestObject, optionalCallbackOnSuccess) ->
    message_div = this.getMessageDiv()
    message_div.html("<span style=\"color:red;\">loading...</span>")
    message_div.show()
    console.log("ajaxLoad(" + ajaxRequestObject.url + ")")
    $.ajax(ajaxRequestObject)
    .fail((error)->
      message_div.html("<span style=\"color:red;\">Connection Error!</span>")
      console.log(error)
    )
    .done((response)->
      message_div.text('Done')
      message_div.fadeOut(1000)
      console.log(response)
      optionalCallbackOnSuccess()
    )
  saveMap: ->
    this.ajaxLoad({
      url: 'maps/updateme', # Not a real route yet
      method: 'put',
      params:  'map[zoom]=' + this.getMap().getZoom() +
        '&map[lat]=' + this.getMap().getCenter().lat() +
        '&map[lon]=' + this.getMap().getCenter().lng() +
        '&map[map_type]=' + map.getMapTypeId().toString() +
        '&authenticity_token=' +
        encodeURIComponent('UM5PoKV0FSPqQpuhRn2wBL13pxoAzZq2hz6MiqNnlrDKmeNAThEmxlHrv4njzJeJDiP5oelgKxL814/zpBlAzQ=='), #may want to dynamically insert csrf token here
    }, ->
      this.getMessageDiv().text("Map saved @ #{Date.now()}").fade(1000)
    )


$(document).ready ->
  window.dedicatedmaps = new DedicatedMaps(window)
  window.dedicatedmaps.ui = new UserInterface(window.dedicatedmaps.getMap())