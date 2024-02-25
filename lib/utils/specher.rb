# frozen_string_literal: true

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require_relative './http'
require_relative './parser'
require_relative './player'

module LoquendoRuby
  #
  # This is the main class for interact with loquendo.io website
  #
  class Specher
    def initialize
      @http = LoquendoRuby::Requester.new
      @parser = LoquendoRuby::Parser.new
      @player = LoquendoRuby::Player.new
      @options = {
        lang: '',
        voice: ''
      }
    end

    def spech(text)
      csrf_token = extract_csrf_token
      spech_http_response = @http.post('https://loquendo.io/home/tryme_action/', {
                                         'csrf_test_name' => csrf_token,
                                         'front_tryme_language' => @options[:lang],
                                         'front_tryme_voice' => @options[:voice],
                                         'front_tryme_text' => text
                                       }, "csrf_cookie_name=#{csrf_token};")
      mp3_file = extract_mp3_audio spech_http_response
      @player.play_mp3 mp3_file
    end

    def set_voice(language_code, name)
      voices = download_voices
      voice = voices.find { |data| data['languageCode'] == language_code && data['name'] == name }
      @options.merge!({ lang: language_code, voice: voice['ids'] }) if voice
    end

    private

    def extract_csrf_token
      response = @http.get 'https://loquendo.io'
      @parser.extract_csrf_token response
    end

    def extract_mp3_audio(text)
      json_data = JSON.parse(text)
      tts_uri = json_data['tts_uri']
      "https://loquendo.io/#{tts_uri}"
    end

    def download_voices
      voices_http_response = @http.get 'https://loquendo.io/home/tryme_voice/'
      JSON.parse voices_http_response
    end
  end
end
