-- Debugging-prefix for this extension.
_dbg_prefix = "[BatchFileDelete] "

-- Reference to the main-dialog.
_dialog = nil

-- Reference to the user-visible label holding the filename
_fileLabel = nil

-- Absolute path to the current file to delete or nil.
_pathToDelete = nil

-- Absolute path to the current file to delete or nil.
_playlistIdToDelete = nil


-- Extension descriptor
function descriptor()
  return {
    title = "BatchFileDelete",
    version = "0.9",
    shortdesc = [[BatchFileDelete]],
    longdesc= [[
Enables batch-processing a playlist while deciding to skip or physically delete the current playing item. In any case, the next item will be played after decision is made.

This extension just works for me and is in beta-state. It probably needs additional testing for different OS and playlist situations. Please do not hesitate to write a comment or mail describing a concrete error message or situation.
	  ]],
    url="https://github.com/calculon102/vlc-batchfiledelete",
    capabilities = { "input-listener" }
  }
end


-- Extension activator
function activate()
  vlc.msg.dbg(_dbg_prefix .. "Activated")
  _dialog = vlc.dialog("FileDelete")
  _dialog:add_label("Delete <b>from disk and from playlist</b>?", 1, 1, 3, 1)

  _fileLabel = _dialog:add_label(get_current_input_uri(), 1, 2, 3, 2)

  _dialog:add_label("<br/>", 1, 3, 3, 1)

  _dialog:add_button("&Delete", on_delete, 1, 4, 1, 1)
  _dialog:add_button("&Next", on_next, 2, 4, 1, 1)
  _dialog:add_button("&Close", on_close, 3, 4, 1, 1)
  _dialog:show()
end


-- Extension desctructor
function deactivate()
  vlc.msg.dbg(_dbg_prefix .. "Deactivated")
end


-- VLC-callback if metadata changes.
function meta_changed()
  -- NOP - function must exist for VLC
end


-- VLC-callback if vlc-input has changed
function input_changed()
  vlc.msg.dbg(_dbg_prefix .. "Current item-id: " .. vlc.playlist.current())
  
  -- Check if state of globals has changed due to user-interaction
  delete_if_needed_synced()
  
  -- Update dialog for new input
  _fileLabel:set_text(get_current_input_uri())
  _dialog:update()
end


-- Event-handler for reservation of current input for deletion and switching to next playlist-item if possible.
function on_delete()
  _pathToDelete = nil
  _playlistIdToDelete = nil

  if (vlc.input.item() == nil) then
    vlc.msg.dbg(_dbg_prefix .. "No item in input on delete action. Ignore.")
    return
  end

  local uri = vlc.input.item():uri()
  if string.sub(uri, 0, 7) ~= "file://" then
    vlc.msg.warn(_dbg_prefix .. "Input for delete action is not a local file. Removing from playlist and ignore.")
  else
    vlc.msg.dbg(_dbg_prefix .. "Deletion reserved for " .. uri)
    _pathToDelete = vlc.strings.decode_uri( string.sub(uri, 8) )
  end

  _playlistIdToDelete = vlc.playlist.current()
  vlc.playlist.next()
end


-- Event-handler for closing the dialog.
function on_close()
  _dialog:delete()
end


-- Event-handler for playing next item in playlist.
function on_next()
  vlc.playlist.next()
end


-- Handles needed deletions of playlist-items and files.
function delete_if_needed_synced()
  remove_playlist_item()
  delete_file()
end


-- Removes the currently buffered playlist-item.
function remove_playlist_item()
  if _playlistIdToDelete ~= nil then
    vlc.msg.dbg(_dbg_prefix .. "Removing playlist item with id " .. _playlistIdToDelete)
    vlc.playlist.delete(_playlistIdToDelete)
    _playlistIdToDelete = nil
  end
end


-- Deletes the currently buffered path
function delete_file()
  if _pathToDelete == nil then
    return
  end
  
  local retval, err = os.remove(_pathToDelete)
  if (retval == nil) then
    vlc.msg.err(_dbg_prefix .. "Error deleting " .. _pathToDelete .. "\n" .. err)
  else  
    vlc.msg.info(_dbg_prefix .. "Deleted " .. _pathToDelete)
  end
  
  _pathToDelete = nil
end


-- Returns the uri of the current input as string or an informative replacement.
function get_current_input_uri()
  if (vlc.input.item() ~= nil) then
    return vlc.input.item():uri()
  end
    
  return "No file selected"
end
