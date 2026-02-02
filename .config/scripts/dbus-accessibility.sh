# Enable accessibility status on dbus
dbus-send --session --dest=org.a11y.Status /org/a11y/status \
  org.freedesktop.DBus.Properties.Set \
  string:org.a11y.Status string:IsEnabled variant:boolean:true
dbus-send --session --dest=org.a11y.Status /org/a11y/status \
  org.freedesktop.DBus.Properties.Set \
  string:org.a11y.Status string:ScreenReaderEnabled variant:boolean:true
