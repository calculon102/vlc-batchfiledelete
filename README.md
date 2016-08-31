# BatchFileDelete - Version 0.94

Extension for the [VLC] media player extension. Enables batch-processing a playlist while deciding to skip or physically delete the current playing item. In any case, the next item will be played after decision is made.

See: [REPOSITORY]

## Installation

Copy the only lua file to the lua-extension folder of your VLC-installation and restart the media player. See [https://www.vlchelp.com/install-vlc-media-player-addon/] for further details.

As of now (August 2016) these locations are for the current user

* In Windows: %APPDATA%\vlc\lua\extensions\
* In Mac OS X: /Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/extensions/
* In Linux: ~/.local/share/vlc/lua/extensions/

### For Windows only

Copy delfile.exe to %APPDATA%\vlc\lua\extensions\

This file implements the deletion of files for Windows-filesystems as the Lua scripting-engine does not support this non POSIX-machines.

*Important note:* The deletion behaviour on Windows is a also bit different this way. Instead of immediate deletion when pressing the according button, the deletion is reserved for the next user-action within the extension-dialog (delete, skip, close). This is to prevent VLC from freezing, when a current input-file is deleted on Windows. In addition you will see a short pop-up of a command-window as result of the external file-execution.   

## Motivation

I was surprised that after so many years of VLC and VLC-extensions there was no real option to reliably delete files directly from VLC (or any other media player). Yes, there are some platform-dependent alternatives, but these are not made for batch-processing large playlists with previewing via playing.

## Current state

This extension just _works for me_ on my linux-machine and is in beta-state. It probably needs additional testing for different OS and playlist situations. Please do not hesistate to write a comment or mail describing a concrete error message or situation.

Windows-support is experimental. Because the OS-functions of Lua only support POSIX-filesystems the deletion on windows is implementend by the companion-executable 'delfile.exe'. As described under installation, the deletion does not happen immediately as under POSIX-compatible systems.


## Changelog

### [0.94]
- Fixed Windows-deletion with only one playlist-item left.
- Added Windows-specific note to dialog.
- Fixed deactivation-call.

### [0.93]
- First Windows-implementation without freezes on Win8.1. Deletion happens asynchronous on next action instead within the event-handler for input-changes.

### [0.92]
- Experimental Windows-support with companion-executable 'delfile.exe'.

### [0.91]
- Changed from lazy to direct deletion of files if possible to prevent VLC-freezes.

### [0.90]
- Working implementation for POSIX-machine.



[REPOSITORY]: https://github.com/calculon102/vlc-batchfiledelete "BatchFileDelete-Repository"
[VLC]: https://www.videolan.org/vlc/ "VLC"

