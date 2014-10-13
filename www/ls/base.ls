document.body.removeChild document.getElementById 'fallback'
body = d3.select \body
window.ig.infoBar = new ig.InfoBar body
window.ig.displayData = (data) ->
  [id, nazev, obec_volilo, obec_volicu, mcmo_volilo, mcmo_volicu, senat_volilo, senat_volicu, okrsek_nazev] = data
  window.ig.infoBar.displayData {id, nazev, obec_volilo, obec_volicu, mcmo_volilo, mcmo_volicu, senat_volilo, senat_volicu, okrsek_nazev}

selectedOutline = null
suggesterContainer = body.append \div
  ..attr \class \suggesterContainer
  ..append \span .html "Najít obec"

suggester = new window.ig.Suggester suggesterContainer
  ..on 'selected' (obec) ->
    window.ig.map.setView [obec.lat, obec.lon], 14
    setOutline obec.id

setOutline = (iczuj) ->
  if selectedOutline
    window.ig.map.removeLayer selectedOutline
  (err, data) <~ d3.json "/tools/suggester/0.0.1/geojsons/#{iczuj}.geo.json"
  return unless data
  style =
    fill: no
    opacity: 1
    color: '#000'
  selectedOutline := L.geoJson data, style
    ..addTo window.ig.map

setView = (hash) ->
  [iczuj, party] = hash.slice 1 .split '|'
  return unless iczuj.length
  iczuj = parseInt iczuj, 10
  <~ suggester.downloadSuggestions
  obec = suggester.suggestions.filter (.id == iczuj) .0
  return unless obec
  if obec
    setOutline iczuj
    return if window.ig.hashChanged
    {lat, lon, nazev} = obec
    latlng = L.latLng [lat, lon]
    window.ig.map.setView latlng, 12
    window.ig.showKandidatka iczuj, nazev, party
    queueIterations = 0
    checkQueue = ->
      try
        {data} = window.ig.utfgrid._objectForEvent {latlng: latlng}
      if data
        window.ig.displayData data
      else
        ++queueIterations
        setTimeout checkQueue, 100 if queueIterations < 100
    checkQueue!

if window.location.hash
  setView that

window.onhashchange = ->
  setView window.location.hash

