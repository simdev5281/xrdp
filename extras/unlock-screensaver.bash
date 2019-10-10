
dbus-send --session \
    --dest=org.gnome.ScreenSaver \
    --type=method_call \
    --print-reply \
    --reply-timeout=6000 \
    /org/gnome/ScreenSaver \
    org.gnome.ScreenSaver.SetActive boolean:false
