# BatchFileDelete

Extension for the [VLC] media player extension. Enables batch-processing a playlist while deciding to skip or physically delete the current playing item. In any case, the next item will be played after decision is made.

## Installation

Copy the only lua file to the lua-extension folder of your VLC-installation and restart the media player. See [https://www.vlchelp.com/install-vlc-media-player-addon/] for further details.

As of now (August 2016) these locations are

### For All Users

* In Windows: Program Files\VideoLAN\VLC\lua\extensions\
* In Mac OS X: /Applications/VLC.app/Contents/MacOS/share/lua/extensions/
* In Linux: /usr/lib/vlc/lua/playlist/ or /usr/share/vlc/lua/extensions/

### For Current User

* In Windows: %APPDATA%\vlc\lua\extensions\
* In Mac OS X: /Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/extensions/
* In Linux: ~/.local/share/vlc/lua/extensions/

## Motivation

I was surprised that after so many years of VLC and VLC-extension there was no real option or extension to reliably delete files directly from VLC (or any other media player). Yes, there are some platform-dependent alternatives, but these are not made for batch-processing large playlists with previewing via playing.

## Current state

This extension just _works for me_ and is in beta-state. It probably needs additional testing for different OS and playlist situations. Please do not hesistate to write a comment or mail describing a concrete error message or situation.

[VLC]: https://www.videolan.org/vlc/ "VLC"
