$(document).ready () ->
  prepare_search_ajax()
  prepare_search_result_actions()
  prepare_scrollbars()
  prepare_lists()

search_page = 0
loading_more_songs = false

prepare_lists = () ->

prepare_scrollbars = () ->
  $(".main-box ul").mCustomScrollbar({
    scrollInertia: 0,
    callbacks: {
      onTotalScroll: () ->
        load_more_songs()
    }
  })
  $(".playlist-box ul").mCustomScrollbar({
    scrollInertia: 0,
  })

prepare_search_ajax = () ->
  send_search_timeout = null;
  $("form#search input#q").on('input', () ->
    clearTimeout(send_search_timeout)
    $('.main-box .empty-results').hide()
    if $("form#search input#q").val().length > 2
      send_search_timeout = setTimeout( () ->
        clear_results()
        search_page = 0
        $('.loading-circle').show()
        send_search_request()
      , 800)
    else
      clear_results()
  )

  $("form#search").on("ajax:success", (e, data, status, xhr) ->
    if loading_more_songs
      loading_more_songs = false
      $('.main-box ul .mCSB_container li:last-child').remove()
      if data.songs.length == 0
        search_page = -1
      add_songs_to_main_list(data.songs)
    else
      add_songs_to_main_list(data.songs)
      $('.main-box ul').mCustomScrollbar("scrollTo", "top")
      $('.loading-circle').hide()
    prepare_search_result_actions()
  )

add_songs_to_main_list = (songs) ->
  $.each songs, (index, song) ->
    $('.main-box ul .mCSB_container').append(
      '<li>' +
        '<a href="#" data-track="' + index + '" data-song="' + song.url + '" data-artist="' + song.artist + '"' +
        ' data-title="' + song.title + '"><b>' + song.artist + '</b> - ' + song.title + '<i class="fa fa-volume-down"></i></a>' +
      '</li>'
    )
  update_scrollbar($('.main-box ul'))

clear_results = () ->
  $('.main-box ul .mCSB_container').html('')

send_search_request = (page = 0) ->
  $("form#search input#search_page").val(page)
  $("form#search").submit()

prepare_search_result_actions = () ->
  $(".main-box ul li a").click ->
    $('.jp-title').html($(this).attr('data-artist') + ' - ' + $(this).attr('data-title'))
    $(this).parent().siblings('li').removeClass('active')
    $(this).parent().addClass('active')
    $("#jquery_jplayer_1").jPlayer("setMedia", {
      mp3: $(this).attr('data-song'),
    }).jPlayer("play")
    return false

update_scrollbar = (parent) ->
  parent.mCustomScrollbar("update");

load_more_songs = () ->
  return false if loading_more_songs || search_page == -1

  loading_more_songs = true
  search_page = search_page + 1
  $('.main-box ul .mCSB_container').append('<li><div class="ajax-loader-horizontal"></div></li>')
  update_scrollbar($('.main-box ul'))
  send_search_request(search_page)


