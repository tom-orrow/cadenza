$(document).ready () ->
  prepare_search_ajax()
  prepare_search_result_actions()

prepare_search_ajax = () ->
  $('form#search input#q').autocomplete {
    serviceUrl: '/api/search/suggest',
    minChars: 3,
    deferRequestBy: 300
  }

  $("form#search").bind("ajax:beforeSend", (e, request, options) ->
    $('#search_result ul').html('')
    $('.loading-circle').show()
  ).on("ajax:success", (e, data, status, xhr) ->
    $('.loading-circle').hide()
    $('#search_result ul').html('')
    $.each data.songs, (index, song) ->
      $('#search_result ul').append(
        '<li>' +
          '<a href="#" data-track="' + index + '" data-song="' + song.url + '" data-artist="' + song.artist + '"' +
          ' data-title="' + song.title + '"><b>' + song.artist + '</b> ' + song.title + '</a>' +
        '</li>'
      )
    prepare_search_result_actions()
  ).bind "ajax:error", () ->
    $('#search_result').html('<h4>Search result is empty.</h4>')

prepare_search_result_actions = () ->
  $("#search_result ul li a").click ->
    $('.jp-title').html($(this).attr('data-artist') + ' - ' + $(this).attr('data-title'))
    $(this).parent().siblings('li').removeClass('active')
    $(this).parent().addClass('active')
    $("#jquery_jplayer_1").jPlayer("setMedia", {
      mp3: $(this).attr('data-song'),
    }).jPlayer("play")
    return false

