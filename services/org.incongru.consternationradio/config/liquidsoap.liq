set("log.file.path","/tmp/liquidsoap.log")

# Log to standard output
set("log.stdout", true)

playlist = playlist("/etc/liquidsoap/playlist.pls", mode="randomize", reload=1, reload_mode="rounds")

# For debugging
# output.dummy(fallible=true, playlist)

output.icecast(
  %mp3(bitrate=128),
  mount="/stream.mp3",
  host="icecast", port=8000, password="icecast_source",
  fallible=true,
  playlist
)
