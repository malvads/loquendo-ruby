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

module LoquendoRuby
  #
  # This is the class for parse some values
  #
  class Parser
    def extract_csrf_token(html)
      regex = %r{<input type="hidden" name="csrf_test_name" value="([A-Fa-f0-9]{32})" />}
      csrf_match = html.match(regex)
      csrf_match[1] if csrf_match
    end
  end
end
