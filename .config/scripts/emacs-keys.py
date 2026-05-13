#!/usr/bin/env python3
# Emacs-style key bindings system-wide for X11, with per-app passthrough.
from Xlib import X, XK, display
from Xlib.protocol import event

# Apps where bindings are disabled because they already handle emacs keys natively.
PASSTHROUGH_CLASSES = {'Alacritty'}

# Bindings: pressing the bindkey synthesizes the sentkey into the focused window.
BINDINGS = [
    ('ctrl+w', 'ctrl+BackSpace'),
    ('ctrl+h', 'BackSpace'),
    ('ctrl+f', 'Right'),
    ('ctrl+e', 'End'),
    ('ctrl+d', 'Delete'),
    ('ctrl+b', 'Left'),
    ('ctrl+a', 'Home'),
    ('ctrl+j', 'Return'),
    ('alt+f', 'ctrl+Right'),
    ('alt+d', 'ctrl+Delete'),
    ('alt+s', 'alt+d'),
    ('alt+b', 'ctrl+Left'),
    ('ctrl+shift+w', 'ctrl+w'),
    ('ctrl+shift+h', 'shift+Left'),
    ('ctrl+shift+f', 'shift+Right'),
    ('ctrl+shift+e', 'shift+End'),
    ('ctrl+shift+d', 'shift+Right'),
    ('ctrl+shift+b', 'shift+Left'),
    ('ctrl+shift+a', 'ctrl+a'),
    ('ctrl+shift+j', 'shift+Return'),
    ('alt+shift+f', 'ctrl+shift+Right'),
    ('alt+shift+d', 'ctrl+shift+Right'),
    ('alt+shift+b', 'ctrl+shift+Left'),
]

# Modifier name lookup, plus lock-state modifiers that grabs must be registered against.
MODS = {'ctrl': X.ControlMask, 'alt': X.Mod1Mask, 'shift': X.ShiftMask}
IGNORE_MODS = [0, X.LockMask, X.Mod2Mask, X.LockMask | X.Mod2Mask]

# Open the X display and resolve atoms used to query the focused window.
d = display.Display()
root = d.screen().root
NET_ACTIVE_WINDOW = d.intern_atom('_NET_ACTIVE_WINDOW')
WM_CLASS = d.intern_atom('WM_CLASS')


# Resolve a keysym name to a keycode for the current keyboard layout.
def keycode(name):
    return d.keysym_to_keycode(XK.string_to_keysym(name))


# Parse a 'ctrl+shift+a'-style combo into (modifier mask, keycode).
def parse(combo):
    parts = combo.split('+')
    mods = 0
    for p in parts[:-1]:
        mods |= MODS[p.lower()]
    return mods, keycode(parts[-1])


# Pre-parse all bindings into a lookup table and track current grab state.
grabs = [(parse(b), parse(s)) for b, s in BINDINGS]
binding_map = dict(grabs)
grabbed = False


# Get the currently focused top-level X window via _NET_ACTIVE_WINDOW.
def focused_window():
    p = root.get_full_property(NET_ACTIVE_WINDOW, X.AnyPropertyType)
    if not p or not p.value[0]:
        return None
    return d.create_resource_object('window', p.value[0])


# Get the resource class of the focused window.
def focused_class():
    win = focused_window()
    if not win:
        return None
    try:
        c = win.get_full_property(WM_CLASS, X.AnyPropertyType)
    except Exception:
        return None
    if not c:
        return None
    parts = c.value.decode('latin-1', errors='replace').rstrip('\x00').split('\x00')
    return parts[-1] if parts else None


# Register or unregister passive grabs for every binding crossed with every ignorable-mod combo.
def set_grabs(on):
    global grabbed
    if on == grabbed:
        return
    for (mods, kc), _ in grabs:
        for extra in IGNORE_MODS:
            if on:
                root.grab_key(kc, mods | extra, True, X.GrabModeAsync, X.GrabModeAsync)
            else:
                root.ungrab_key(kc, mods | extra)
    grabbed = on
    d.sync()


# Toggle grabs based on whether the focused window is in PASSTHROUGH_CLASSES.
def update_grabs():
    set_grabs(focused_class() not in PASSTHROUGH_CLASSES)


# Send the destination key directly to the focused window, bypassing all grabs.
def inject(dst_mods, dst_kc):
    win = focused_window()
    if not win:
        return
    for cls in (event.KeyPress, event.KeyRelease):
        ev = cls(
            time=X.CurrentTime,
            root=root,
            window=win,
            same_screen=1,
            child=X.NONE,
            root_x=0, root_y=0, event_x=0, event_y=0,
            state=dst_mods,
            detail=dst_kc,
        )
        win.send_event(ev, propagate=True)
    d.sync()


# Subscribe to focus changes and apply the initial grab state.
root.change_attributes(event_mask=X.PropertyChangeMask)
update_grabs()

# Event loop: dispatch grabbed presses to inject(), and refresh grabs whenever focus changes.
while True:
    ev = d.next_event()
    if ev.type == X.KeyPress:
        mods = ev.state & (X.ControlMask | X.Mod1Mask | X.ShiftMask)
        dst = binding_map.get((mods, ev.detail))
        if dst:
            inject(*dst)
    elif ev.type == X.PropertyNotify and ev.atom == NET_ACTIVE_WINDOW:
        update_grabs()
