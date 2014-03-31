module Api
  class SearchController < BaseController
    before_filter :validate_request!

    def complete
      original = Echowrap.song_search(
        combined:  params[:q],
        results: 1
      )
      puts '>>>>>>'
      puts original
      if original.empty?
        render json: { error: 'Search result is empty.'}, status: :unprocessable_entity
      else
        if session[:echonest_session_id].present?
          Echowrap.playlist_dynamic_restart(
            session_id: session[:echonest_session_id],
            song_id:  original.first.id,
            type: 'song-radio'
          )
        else
          session[:echonest_session_id] = Echowrap.playlist_dynamic_create(
            song_id:  original.first.id,
            type: 'song-radio',
          ).session_id
        end
        results = get_next_songs()
        render json: { songs: results }
      end
    end

    def suggest
      songs = @vk.audio.search(q: params[:query], count: 6, sort: 2)
      songs.shift
      songs = songs.map { |i| { value: i["artist"] + ' - ' + i["title"], data: i["aid"] }}

      render json: { query: params[:query], suggestions: songs }
    end

    private

    def get_next_songs
      results = []
      i = 0
      while results.count < 5 && i < 3 do
        i = i + 1
        suggested_songs = Echowrap.playlist_dynamic_next(
          session_id: session[:echonest_session_id],
          results: 25
        ).songs
        break if suggested_songs.empty?

        suggested_songs.each do |song|
          search = song.artist_name + ' - ' + song.title
          # Try to find in VK
          song = find_in_vk(search)
          # Try to find in yandex
          song = find_in_yandex(search) if song.nil?

          results << song unless song.nil?
          break if results.count == 5
        end
      end
      results
    end

    private

    def find_in_vk(search)
      song = @vk.audio.search(q: search, count: 1, sort: 2)
      song[0] == 0 ? nil : song[1]
    end

    def find_in_yandex(search)
      song = Api::YandexController.search(search)
    end
  end
end
