bezKandidatky =
  "Petkovy"
  "Zadní Střítež"
  "Srní"
  "Úherce"
  "Víska u Jevíčka"
  "Slavníč"
  "Růžená"
percentage = -> "#{window.ig.utils.formatNumber it * 100}&nbsp;%"

window.ig.InfoBar = class InfoBar
  (parentElement) ->
    @init parentElement

  displayData: ({id, nazev, obec_volilo, obec_volicu, mcmo_volilo, mcmo_volicu, senat_volilo, senat_volicu}) ->
    @nazev.text "#{nazev}"
    @container.classed \noData obec_volicu == 0
    if !obec_volicu
      if nazev in bezKandidatky
        @helpText.html "Obec nesestavila kandidátku"
      else
        @helpText.html "Vojenský újezd"
    else
      @helpText.html if !senat_volicu and !mcmo_volicu
        "V obci se volilo pouze obecní zastupitelstvo"
      else if !mcmo_volicu
        "V obci se nevolilo do zastupitelstva městské části"
      else if !senat_volicu
        "V obci se nevolilo do senátu"
      else
        ""

    obec =
      | obec_volicu => percentage obec_volilo / obec_volicu
      | _ => "&mdash;"
    senat =
      | senat_volicu => percentage senat_volilo / senat_volicu
      | _ => "&mdash;"
    mcmo =
      | mcmo_volicu => percentage mcmo_volilo / mcmo_volicu
      | _ => "&mdash;"

    @stats.data [obec, senat, mcmo] .html -> it


  init: (parentElement) ->
    @container = parentElement.append \div
      ..attr \class "infoBar noData"
    @nazev = @container.append \h2
      ..text "Mapa volební účasti"
    @helpText = @container.append \span
      ..attr \class \clickInvite
      ..text "Podrobnosti o obci zobrazíte najetím myši nad obec"

    stats = @container.append \div
      ..attr \class \stats
      ..append \div
        ..attr \class \celkem
        ..append \h4 .html "Obecní"
        ..append \span .attr \class \value
      ..append \div
        ..attr \class \mandaty
        ..append \h4 .html "Senátní"
        ..append \span .attr \class \value
      ..append \div
        ..attr \class \tlacenka
        ..append \h4 .html "Městská část"
        ..append \span .attr \class \value
    @stats = stats.selectAll \span.value
