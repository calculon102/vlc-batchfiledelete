# BatchFileDelete

Extension for the [VLC] media player extension. Enables batch-processing a playlist while deciding to skip or physically delete the current playing item. In any case, the next item will be played after decision is made.

## Installation

Copy the only lua file to the lua-extension folder of your VLC-installation and restart the media player. See [https://www.vlchelp.com/install-vlc-media-player-addon/] for further details.

As of now (August 2016) these locations are

### For All Users

* In Windows: Program Files\VideoLAN\VLC\lua\extensions\ *not supported!*
* In Mac OS X: /Applications/VLC.app/Contents/MacOS/share/lua/extensions/
* In Linux: /usr/lib/vlc/lua/playlist/ or /usr/share/vlc/lua/extensions/

### For Current User

* In Windows: %APPDATA%\vlc\lua\extensions\
* In Mac OS X: /Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/extensions/
* In Linux: ~/.local/share/vlc/lua/extensions/

### For Windows only

Copy delfile.exe to %APPDATA%\vlc\lua\extensions\ this file implements the deletion of files from the filesystem as the Lua scripting-engine does not (reliably) support this on Windows-machines.

## Motivation

I was surprised that after so many years of VLC and VLC-extensions there was no real option to reliably delete files directly from VLC (or any other media player). Yes, there are some platform-dependent alternatives, but these are not made for batch-processing large playlists with previewing via playing.

## Current state

This extension just _works for me_ on my linux-machine and is in beta-state. It probably needs additional testing for different OS and playlist situations. Please do not hesistate to write a comment or mail describing a concrete error message or situation.

Windows-support is experimental. Because the OS-functions of Lua only support POSIX-filesystems the deletion on windows is implementend by the companion-executable 'delfile.exe'. However, on my testing-VMs this call caused VLC to freeze! Maybe you have more luck on your Windows-machine.


[VLC]: https://www.videolan.org/vlc/ "VLC"
