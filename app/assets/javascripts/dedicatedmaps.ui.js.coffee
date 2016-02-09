dedicatedmaps.ui = (->

  ui = {}

  ui.map_div = ->
    $('div#map_div')

  ui.message_div = ->
    $('div#message')

    # Route Ajax calls through this function to pair them with the UI notification
  ui.ajax_load = (ajaxRequestObject) ->
    ui.message_div.html("<span style=\"color:red;\">loading...</span>")
    ui.message_div.show()
    console.log("ajax_load(" + ajaxRequestObject.url + ")")
    $.ajax(ajaxRequestObject).fail(->
        ui.message_div.html("<span style=\"color:red;\">Connection Error!</span>")
      ).done(->
        ui.message_div.text('Done')
        ui.message_div.fadeOut(1000)
      )

    # Set options on the map and display it after page load
  ui.initializeMap = ->


    loadCallback = ->
    # TODO: Load these in via Ajax from the user
      map_state = {
        "zoom": 7,
        "lon": -123.391,
        "lat": 47.8933,
        "map_type": 'roadmap'
      }

    google.maps.event.addDomListener(window, 'load', loadCallback)

    center = google.maps.LatLng(map_state.lat, map_state.lon)
    map_types = {
      "hybrid":google.maps.MapTypeId.HYBRID,
      "satellite":google.maps.MapTypeId.SATELLITE,
      "roadmap":google.maps.MapTypeId.ROADMAP,
      "terrain":google.maps.MapTypeId.TERRAIN
    }
    mapOptions = {
      center: center,
      zoom: map_state.zoom,
      mapTypeId: map_types[map_state.map_type.toLowerCase()]
    }
    dedicatedmaps.ui.map = google.maps.Map(ui.map_div, mapOptions)

    google.maps.event.addDomListener(ui.map, "dragend", ui.cue_save_map)
    google.maps.event.addDomListener(ui.map, "maptypeid_changed", ui.cue_save_map)
    save_delay = 0;

    return ui
)()