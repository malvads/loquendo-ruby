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
  # This is the class for play downloaded audio
  #
  class Player
    def play_mp3(mp3_file)
      validate_os_support

      if windows_os?
        download_with_powershell(mp3_file)
        play_on_windows
      else
        download_mp3(mp3_file)
        play_on_unix
      end

      delete_mp3_file
    end

    private

    def validate_os_support
      return if %w[linux darwin darwin22 mswin mingw cygwin].include?(RbConfig::CONFIG['host_os'])

      raise NotImplementedError, 'Unsupported operating system.'
    end

    def windows_os?
      %w[mswin mingw cygwin].include?(RbConfig::CONFIG['host_os'])
    end

    def download_with_powershell(mp3_file)
      `powershell -Command "(New-Object Net.WebClient).DownloadFile('#{mp3_file}', 'LoquendoRuby.mp3')"`
    end

    def play_on_windows
      `start LoquendoRuby.mp3`
    end

    def download_mp3(mp3_file)
      `curl -o LoquendoRuby.mp3 #{mp3_file} > /dev/null 2>&1` if %w[darwin darwin22
                                                                    linux].include?(RbConfig::CONFIG['host_os'])
    end

    def play_on_unix
      if macos?
        `afplay LoquendoRuby.mp3`
      else
        player = find_player
        raise 'Please install mpg123 or mpg321 to play MP3 files.' if player.empty?

        `#{player.strip} LoquendoRuby.mp3`
      end
    end

    def macos?
      RbConfig::CONFIG['host_os'] =~ /darwin|mac os/
    end

    def find_player
      `command -v mpg123 > /dev/null 2>&1 && echo "mpg123" || (command -v mpg321 > /dev/null 2>&1 && echo "mpg321")`
    end

    def delete_mp3_file
      File.delete('LoquendoRuby.mp3')
    end
  end
end
