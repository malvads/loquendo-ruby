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

require 'net/http'
require 'json'

module LoquendoRuby
  #
  # This is class for handle the requests to loquendo.io website
  #
  class Requester
    def get(url)
      uri = URI(url)
      response = Net::HTTP.get_response(uri)
      handle_response(response)
    end

    def post(url, body, cookie = nil)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data body
      request['Cookie'] = cookie if cookie
      response = http.request(request)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        response.body
      when Net::HTTPClientError, Net::HTTPServerError
        raise "HTTP Request Failed: #{response.code} - #{response.message}"
      else
        raise "Unknown HTTP Response: #{response.code} - #{response.message}"
      end
    end
  end
end
