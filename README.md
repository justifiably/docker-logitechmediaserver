# Docker Container for Logitech Media Server

> **Please note:** there is now an official 
> [LMS community supported Docker image here](https://hub.docker.com/r/lmscommunity/logitechmediaserver).  I encourage you to switch to using that one.

Docker image for
[Logitech Media Server](https://github.com/Logitech/slimserver) (aka
SqueezeCenter, SqueezeboxServer, SlimServer).

Runs as non-root user, installs useful dependencies, sets a locale,
exposes ports needed for various plugins and server discovery and
allows editing of config files like `convert.conf`.

Newer versions of Logitech Media Server support updates in place.  To
recreate this container I keep a tag of the latest version build in the
working directory.  To update that:

    make update

To build the image:

    make build

See Github network for other authors (JingleManSweep, map7, joev000).

Works well with my [MusicIP container](https://hub.docker.com/r/justifiably/musicip/).
See included patch if you want to run MusicIP on another host or want to
avoid running with net=host.


### Running the server

You need a hardware or software player to connect to the server, see
pointers below.

Minimal run example:

    docker run --net=host -v <audio-dir>:/mnt/music justifiably/logitechmediaserver

Then:

* Visit the server and configure it from <http://localhost:9000>
* Skip the `mysqueezebox.com` configuration if you want a local-only solution
* Select `/mnt/music` and `/mnt/playlists` as your music and playlist folders
* If you mainly use streaming services, several are available in the Plugins tab
* Recommended: the modern [Material skin][lms-material], activate the plugin and select it on Interface tab
    * for arcane server settings, you may still need to access [the default skin](http://localhost:9000)

Here is a more complex run example, putting the process in background, mapping the server
and player ports only and mounting volumes for music and state:

    docker run -d -p 9000:9000 -p 3483:3483 -p 3483:3483/udp -v <local-state-dir>:/mnt/state -v <playlist-dir>:/mnt/playlists -v <audio-dir>:/mnt/music justifiably/logitechmediaserver

The music volume mount allows you to map an external directory already
loaded with music.  The state volume mount allows you to persist the
state between different server containers.  This is useful if you want
to play with plugins, or edit `convert.conf` to tweak transcoding
settings.


### Using Docker Compose

See the sample `docker-compose.yml`.  Edit the volume settings
appropriately, run as usual by:

    docker-compose up -d


### Patches to server code

To apply the patches, build the container with "LMS_PATCHES=y".

* `lms-musicmagic-host.patch`: this adds a configuration setting
  MMShost so you can run MusicIP a machine other than `localhost`.  This
  allows the container to be run without the intrusive net=host
  setting.  Notice that only the included server plugins are
  patched, others unfortunately also hardware `localhost`.


### Pointers

Most help and up to date information is available on the excellent 
forums: <https://forums.slimdevices.com> 

* [SqueezePlay software players](http://wiki.slimdevices.com/index.php/SqueezePlay_binaries)
  handy for testing or laptop use.
* Original sadly discontinued [Logitech hardware players](http://wiki.slimdevices.com/index.php/Main_Page#Players_.26_Controllers)
* The excellent [PiCorePlayer](https://www.picoreplayer.org) distribution for Raspberry Pi
* Many others...

[lms-material]: https://forums.slimdevices.com/showthread.php?109624-Announce-Material-Skin
