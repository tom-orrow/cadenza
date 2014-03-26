$(document).ready(function(){
  var player = new MediaElementPlayer('#player', {
    loop: true,
    shuffle: false,
    playlist: true,
    audioHeight: 30,
    playlistposition: 'bottom',
    features: ['playlistfeature', 'prevtrack', 'playpause', 'nexttrack', 'loop', 'shuffle', 'playlist', 'current', 'progress', 'duration', 'volume'],
  });

  player.addToPlaylist(player, 'http://cs6191v4.vk.me/u20090860/audios/daf41022910f.mp3', 'Cocteau Twins – Pearly Dewdrops Drop');
});

