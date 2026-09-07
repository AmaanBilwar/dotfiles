{ 
home.file.".config/kanata/config.kbd".text = ''
    ;; Two-layer keyboard layout.
    ;; Hold Left Alt for lower; release to return to main.
    ;; Right Alt emits Backspace. Grave (`) is Escape.
    ;; Right Ctrl toggles mouse layer.

    (defcfg
      process-unmapped-keys yes
      concurrent-tap-hold yes
      linux-dev-names-include (
        "ITE Tech. Inc. ITE Device(8295) Keyboard"
        "Ideapad extra buttons"
        "ITE Tech. Inc. ITE Device(8910) Keyboard"
        "AT Translated Set 2 keyboard"
        "Glorious Model O Keyboard"
        "Evision RGB Keyboard"
      )
    )

    (defvar
      tap-time 200
      hold-time 200
    )

    (defsrc
      grv  1    2    3    4    5    6    7    8    9    0    -    =
      tab  q    w    e    r    t    y    u    i    o    p    [    bspc
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      z    x    c    v    b    n    m    ,    .    /
      lalt ralt lctl rctrl
      lsft rsft
    )

    (deflayer main
      esc  1    2    3    4    5    6    7    8    9    0    -    =
      @tab-nav q    w    e    r    t    y    u    i    o    p    bspc bspc
      lctl @a-lmet @s-lalt d f g h j k @l-ralt @semi-lmet ' ret
      z    x    c    v    b    n    m    ,    .    /
      @la-hold bspc esc @mouse-on
      lsft rsft
    )

    (deflayer lower
      _    _    _    _    _    _    _    _    _    _    _    _    _
      @tab-nav S-9  S-0  '    S-'  `    \    /    ;    S-[  S-]  bspc bspc
      lctl S-1  S-2  S-3  S-4  S-5  S-6  S-7  S-8  [    ]    \    ret
      @lt-sh @gt-sh = - S-- S-= _ _ _ _
      _ bspc esc esc
      lsft rsft
    )

    (deflayer nav
      _ _ _ _ _ _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _ _ ` _ _ _
      _ _ _ _ _ _ left down up rght del _ _
      _ _ _ _ _ _ _ _ _ _
      _ bspc _ _
      _ _
    )

    (deflayer mouse
      XX _ _ _ _ _ _ _ _ _ _ _ _
      XX XX @msu XX XX XX XX XX XX XX XX XX XX
      XX @msl @msd @msr mltp mrtp @mswl @mswd @mswu @mswr mmtp XX XX
      XX XX XX XX XX XX XX XX XX XX
      XX bspc XX @mouse-off
      XX XX
    )

    (defalias
      tab-nav (tap-hold-press $tap-time $hold-time tab (layer-while-held nav))
      la-hold (tap-hold-press $tap-time $hold-time lalt (layer-while-held lower))
      a-lmet (tap-hold-tap-keys $tap-time $hold-time a lmet (q w e r t y u i o p s d f g h j k l z x c v b n m , . / ; ' [ bspc ret))
      s-lalt (tap-hold-tap-keys $tap-time $hold-time s lalt (q w e r t y u i o p a d f g h j k z x c v b n m , . / ; ' [ bspc ret))
      l-ralt (tap-hold-tap-keys $tap-time $hold-time l ralt (q w e r t y u i o p a s d f g h j k z x c v b n m , . / ; ' [ bspc ret))
      semi-lmet (tap-hold-tap-keys $tap-time $hold-time ; lmet (q w e r t y u i o p a s d f g h j k l z x c v b n m , . / ' [ bspc ret))
      mouse-on (layer-switch mouse)
      mouse-off (layer-switch main)
      lt-plain (unmod ,)
      gt-plain (unmod .)
      lt-sh (fork S-, @lt-plain (lsft rsft))
      gt-sh (fork S-. @gt-plain (lsft rsft))
      msl (movemouse-accel-left 8 700 1 15)
      msd (movemouse-accel-down 8 700 1 15)
      msu (movemouse-accel-up 8 700 1 15)
      msr (movemouse-accel-right 8 700 1 15)
      mswd (mwheel-down 50 120)
      mswu (mwheel-up 50 120)
      mswl (mwheel-left 50 120)
      mswr (mwheel-right 50 120)
    )
  '';
 }
