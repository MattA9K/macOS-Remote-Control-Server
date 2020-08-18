# macOS-Remote-Control-Server
Control the mouse with the complimentary iOS app iOS-Remote-Control-Client
https://github.com/MattAndrzejczuk/iOS-Remote-Control-Client

#### macOS Requirements:
- homebrew
- cliclick

### WebSocket Server Installation:
This requires a running Django application "https://github.com/jrief/django-websocket-redis"

Download this Django repo, and get the "example" django project up and running, once installed, start django like so:

`$python3 manage.py runserver 0.0.0.0:8888`

This macOS-Remote-Control-Server app by default is configured to listen to `localhost:8888`

You dont have to use django as your websocket server, any basic one that transfers plain strings is all that's needed.

### Homebrew
Install homebrew by entering this into your terminal
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

### CliClick
Once you have homebrew installed, you'll need cliclick used by this app
to control macOS mouse events
