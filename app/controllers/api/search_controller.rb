module Api
  class SearchController < BaseController
    def complete
      @user = @vk.users.get(uid: session[:vk_id], fields: [:screen_name, :photo]).first
      @song = Echowrap.song_search(artist: 'Daft Punk')
      ap @song
    end
  end
end
