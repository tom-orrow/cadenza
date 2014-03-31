$(document).ready () ->
  prepare_search_ajax()
  prepare_search_result_actions()

prepare_search_ajax = () ->
  $('form#search input#q').autocomplete {
    serviceUrl: '/api/search/suggest',
    minChars: 3,
    deferRequestBy: 300
  }

  $("form#search").on("ajax:success", (e, data, status, xhr) ->
    $('#search_result').html('')
    $('#search_result').append('<ul></ul>')
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
    $("audio.player").attr('src', $(this).attr('data-song'))
    $("audio.player").attr('data-current', $(this).attr('data-track'))
    $("audio.player").attr('autoplay', "true")
    return false
