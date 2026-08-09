The method the IP change detection is done will be by using `ip monitor`.

I wanted an event driven way to detect to avoid polling every seconds.
There will be a systemd service that will be running `ip monitor`.