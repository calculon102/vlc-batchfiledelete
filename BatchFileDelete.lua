-- GLOBALS --

-- Debugging-prefix for this extension.
_dbg_prefix = "[BatchFileDelete] "

-- Reference to the main-dialog.
_dialog = nil

-- Reference to the user-visible label holding the filename
_fileLabel = nil

-- Playlist-Id to be removed after input has changed. Windows-only.
_idToRemove = nil

-- Path to file to be reservated for deletion after input has changed. Windows-only.
_winFileReservation = nil

-- Path to file to be really, really deleted on next action. Windows-only.
_winFileDeletion = nil

-- Remeber previous ID of input-changed-event, becaus it's called twice for the same element sometimes. Really, VLC!?
_prevId = nil


-- Extension descriptor
function descriptor()
  return {
    title = "BatchFileDelete",
    version = "0.93",
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
  if vlc.win ~= nil then
    vlc.msg.dbg(_dbg_prefix .. "On Windows-OS")
  end

  -- Create dialog.
  _dialog = vlc.dialog("BatchFileDelete v0.93")
  _dialog:add_label("Delete current input?", 1, 1, 3, 1)

  _fileLabel = _dialog:add_label(get_current_input_uri(), 1, 2, 3, 2)

  _dialog:add_label("<br/>", 1, 3, 3, 1)

  _dialog:add_button("&Delete", on_delete, 1, 4, 1, 1)
  _dialog:add_button("&Skip", on_next, 2, 4, 1, 1)
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
  if _prevId == vlc.playlist.current() then
    return
  end

  vlc.msg.dbg(_dbg_prefix .. "Current item-id: " .. vlc.playlist.current())
  _prevId = vlc.playlist.current()

  if  _idToRemove ~= nil then
    vlc.playlist.delete(_idToRemove)
    _idToRemove = nil
  end

  -- On Windows: Mark the reservated file to be deleted on next action (delete, next, close)
  if _winFileReservation ~= nil then
    _winFileDeletion = _winFileReservation
    _winFileReservation = nil
  end

  -- Update dialog for new input
  _fileLabel:set_text(get_current_input_uri())
  _dialog:update()
end


-- Event-handler for reservation of current input for deletion and switching to next playlist-item if possible.
function on_delete()
  if (vlc.input.item() == nil) then
    vlc.msg.dbg(_dbg_prefix .. "No item in input on delete action. Ignore.")
    return
  end

  remove_garbage()

  local uri = vlc.input.item():uri()
  local itemId = vlc.playlist.current()

  if string.sub(uri, 0, 7) ~= "file://" then
    vlc.msg.warn(_dbg_prefix .. "Input for delete action is not a local file. Removing from playlist and ignore.")
    remove_playlist_item(itemId)
    vlc.playlist.next()
    return
  end

  vlc.msg.dbg(_dbg_prefix .. "Deletion triggered for " .. uri)
  local pathToDelete = convert_uri_to_local_path(uri)

  -- On stupid Windows: Only mark file to be reservated for delete-reservation and reservation playlist-removal.
  -- On not-Windows: Just delete und remove from playlist without fear of crashing the system.
  if vlc.win ~= nil then
    _idToRemove = itemId
    _winFileReservation = pathToDelete
  else
    delete_file(pathToDelete)
    remove_playlist_item(itemId)
  end

  vlc.playlist.next()
end


-- Event-handler for closing the dialog.
function on_close()
  remove_garbage()
  _dialog:delete()
  deactivate()
end


-- Event-handler for playing next item in playlist.
function on_next()
  remove_garbage()
  vlc.playlist.next()
end


-- Removes the given playlist-item.
function remove_playlist_item(itemId)
  if itemId == nil then
    return
  end

  vlc.msg.dbg(_dbg_prefix .. "Removing playlist item with id " .. itemId)
  vlc.playlist.delete(itemId)
end


-- Removes the given path physically from the filesystem from the OS.
function delete_file(path)
  if path == nil then
    return
  end

  local retval, err

  -- Windows-variant: Does not support POSIX-based os.remove-function
  if vlc.win ~= nil then
    local command = vlc.config.userdatadir() .. "\\lua\\extensions\\delfile.exe \"" .. path .. "\""
    retval = os.execute(command)
    vlc.msg.warn("Executed command '" .. command .. "'. Return: " .. retval)
    return
  end

  retval, err = os.remove(path)

  if (retval == nil) then
    vlc.msg.err(_dbg_prefix .. "Error deleting " .. path .. "\n" .. err)
  else
    vlc.msg.info(_dbg_prefix .. "Deleted " .. path)
  end
end


-- Returns the uri of the current input as string or an informative replacement.
function get_current_input_uri()
  if vlc.input.item() ~= nil then
    return vlc.input.item():uri()
  end

  return "No file selected"
end


-- Converts a URI of VLC to a localized string.
function convert_uri_to_local_path(uri)
  local substring = string.sub(uri, get_absolute_path_index())
  local decoded = vlc.strings.decode_uri(substring)

  -- On Windows convert all slashes to backslashes. Possible error if there are slashes as part of the real name.
  if vlc.win ~= nil then
    return decoded:gsub("/", "\\")
  end

  return decoded
end


-- Gets to OS dependent first index of a file path in a URI.
function get_absolute_path_index()
  -- On Windows remove the complete file:/// URI-prefix.
  if vlc.win ~= nil then
    return 9
  end

  -- On POSIX-Systems remove only file:// and keep one slash as root of absolute path
  return 8
end


-- Deletes the current reservated file
function remove_garbage()
    delete_file(_winFileDeletion)
    _winFileDeletion = nil
end