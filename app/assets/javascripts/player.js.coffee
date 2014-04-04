volume = $.cookie("player_volume")
volume = 0.2 if typeof volume == 'undefined'

$(document).ready () ->
  $("#jquery_jplayer_1").jPlayer({
    preload: "auto",
    volume: volume,
    ended: () ->
      play_next()
  })
  $(".jp-seek-bar").slider({
    start: (event, ui) ->
      # disable jplayer event
      $("#jquery_jplayer_1").jPlayer({cssSelector: { playBar: ".jp-play-bars"}})
    stop: (event, ui) ->
      # enable jplayer event
      $("#jquery_jplayer_1").jPlayer({cssSelector: { playBar: ".jp-play-bar"}})
    slide: (event, ui) ->
      $('.jp-play-bar').css(width: ui.value + '%')
  })
  $("#jquery_jplayer_1").bind($.jPlayer.event.progress, (event) ->
    audio = $(this).data("jPlayer").htmlElement.audio
    percent = 0
    if (typeof audio.buffered is "object") && audio.buffered.length > 0
      if audio.duration > 0
        bufferTime = 0
        i = 0
        while i < audio.buffered.length
          bufferTime += audio.buffered.end(i) - audio.buffered.start(i)
          i++
        percent = 100 * bufferTime / audio.duration
    else
      percent = 100
    $('.jp-play-buffer').css 'width', "#{percent}%"
  )
  prepare_controls()

prepare_controls = () ->
  $('.jp-prev').click () ->
    play_prev()
    return false

  $('.jp-next').click () ->
    play_next()
    return false

  $('.jp-shuffle').click () ->
    $(this).toggleClass("disable")
    return false

  # Volume
  $("[data-slider]").simpleSlider("setValue", volume)
  $("[data-slider]").bind("slider:ready slider:changed", (event, data) ->
    $("#jquery_jplayer_1").jPlayer("volume", data.value.toFixed(3))
    $.cookie("player_volume", data.value.toFixed(3));
  )

play_next = () ->
  playlist = $(".audio-content li.active").parent()
  next = playlist.find("li.active").next('li').children('a').first()
  if next.length == 0
    next = playlist.find("li > a").first()
  set_track(next)

play_prev = () ->
  playlist = $(".audio-content li.active").parent()
  prev = playlist.find("li.active").prev('li').children('a').first()
  if prev.length == 0
    prev = playlist.find("li > a").last()
  set_track(prev)

set_track = (link) ->
  $('.jp-title').html(link.attr('data-artist') + ' - ' + link.attr('data-title'))
  link.parent().siblings('li').removeClass('active')
  link.parent().addClass('active')
  $("#jquery_jplayer_1").jPlayer("setMedia", {
    mp3: link.attr('data-song'),
  }).jPlayer("play")
