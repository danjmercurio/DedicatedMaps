dedicatedmaps.ui = (->

  ui = {}

  ui.map_div = ->
    $('div#map_div')
  message_div: ->
    $('div#message')

    # Route Ajax calls through this function to pair them with the UI notification
  ui.ajax_load = (ajaxRequestObject) ->
    message_div.html('<span style="color:red;">loading...</span>')
    message_div.show()
    console.log("ajax_load(" + ajaxRequestObject.url + ")")
    $.ajax(ajaxRequestObject).fail((reqObject, textstatus, errorthrown) ->
        message_div.html('<span style="color:red;">Connection Error!</span>')
      ).done(->
        message_div.text('Done')
        message_div.fadeOut(1000)
      )

    # Set options on the map and display it after page load
  ui.initializeMap = ->
    layer_config = {"grpboom":{"type":"KML","icon":"alphabet/blue_A"},
      "GrpNT":{"type":"StagingArea","icon":"square_mini/purple"},
      "grp2016":{"type":"StagingArea","icon":"square_mini/yellow"},
      "grpBL":{"type":"StagingArea","icon":"square_mini/yellow"},
      "grpWDOE":{"type":"KML","icon":""},
      "grpsa":{"type":"StagingArea","icon":"square_mini/blue"},
      "kml_test":{"type":"KML","icon":""},
      "astoria_marine_map":{"type":"Custom","icon":null},
      "pinpoint":{"type":"Custom","icon":null},
      "wrrls":{"type":"StagingArea","icon":"teardrop_mini/alphabet/green_W"},
      "iess":{"type":"StagingArea","icon":"custom/water"},
      "ccss":{"type":"StagingArea","icon":"square_mini/purple"},
      "AIS_Towersa":{"type":"StagingArea","icon":"square/misc/wifi"},
      "cics":{"type":"StagingArea","icon":"teardrop_mini/alphabet/yellow_M"},
      "bcos":{"type":"StagingArea","icon":"teardrop_mini/alphabet/brown_D"},
      "nrcs":{"type":"StagingArea","icon":"teardrop_mini/green"},
      "public_ships":{"type":"Custom","icon":null},
      "pois":{"type":"StagingArea","icon":"teardrop_mini/green"},
      "mfsas":{"type":"StagingArea","icon":"teardrop/purple"},
      "crc":{"type":"StagingArea","icon":"teardrop_mini/blue"}}

    google.maps.event.addDomListener(window, "load", ->
      map_state = {"zoom":7,
      "lon":-123.391,
      "lat":47.8933,
      "map_type":"roadmap"
      # TODO: Load these in via Ajax
    )

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