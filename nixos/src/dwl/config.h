/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }
/* appearance */
static const int sloppyfocus               = 1;  /* focus follows mouse */
static const int bypass_surface_visibility = 0;  /* 1 means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
static const unsigned int borderpx         = 3;  /* border pixel of windows */
static const float rootcolor[]             = COLOR(0x222222ff);
static const float bordercolor[]           = COLOR(0x542aa8ff);
static const float focuscolor[]            = COLOR(0x742ffcff);
static const float urgentcolor[]           = COLOR(0xff0000ff);
static const int smartgaps                 = 0;  /* 1 means no outer gap when there is only one window */
static int gaps                            = 4;  /* 1 means gaps between windows are added */
static const unsigned int gappx            = 4; /* gap pixel between windows */
/* This conforms to the xdg-protocol. Set the alpha to zero to restore the old behavior */
static const float fullscreen_bg[]         = {0.1f, 0.1f, 0.1f, 1.0f}; /* You can also use glsl colors */

/* tagging - TAGCOUNT must be no greater than 31 */
#define TAGCOUNT (9)

/* logging */
static int log_level = WLR_ERROR;

/* Autostart */
static const char *const autostart[] = {
        // "wbg", "/path/to/your/image", NULL,
        "systemctl", "--user", "import-environment", "WAYLAND_DISPLAY", "XDG_CURRENT_DESKTOP", NULL,
        "dbus-update-activation-environment", "--systemd", "WAYLAND_DISPLAY", "XDG_CURRENT_DESKTOP=dwl", NULL,
        // "dwl-startup", NULL,
        "playerctld", NULL,
        "hyprpaper", NULL,
        "kanshi", NULL,
        "dwlb-status", NULL,
        "swayidle", NULL,
        "foot", "--server", NULL,
        // "sh", "-c", "systemctl", "--user", "import-environment", "WAYLAND_DISPLAY", "XDG_CURRENT_DESKTOP", NULL
        NULL /* terminate */
};

/* NOTE: ALWAYS keep a rule declared even if you don't use rules (e.g leave at least one example) */
static const Rule rules[] = {
	/* app_id             title       tags mask     isfloating   monitor */
	/* examples: */
	{ "Gimp_EXAMPLE",     NULL,       0,            1,           -1, 0 }, /* Start on currently visible tags floating, not tiled */
	{ "firefox_EXAMPLE",  NULL,       1 << 8,       0,           -1, 0 }, /* Start on ONLY tag "9" */
    /* scratchpads */
	{ "kittypad",         "scratchpad", 0,            1,           -1,     's' },
	{ "kittypad-blue",    "scratchpad", 0,            1,           -1,     'b' },
	{ "kittypad-nc",      "scratchpad", 0,            1,           -1,     'n' },
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* monitors */
/* (x=-1, y=-1) is reserved as an "autoconfigure" monitor position indicator
 * WARNING: negative values other than (-1, -1) cause problems with Xwayland clients
 * https://gitlab.freedesktop.org/xorg/xserver/-/issues/899
*/
/* NOTE: ALWAYS add a fallback rule, even if you are completely sure it won't be used */
static const MonitorRule monrules[] = {
	/* name       mfact  nmaster scale layout       rotate/reflect                x    y */
	/* example of a HiDPI laptop monitor:
	{ "eDP-1",    0.5f,  1,      2,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
	*/
	/* defaults */
	{ NULL,       0.5f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	/* can specify fields: rules, model, layout, variant, options */
	/* example:
	.options = "ctrl:nocaps",
	*/
	.options = "caps:hyper",
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* Trackpad */
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 0;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;

/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* If you want to use the windows key for MODKEY, use WLR_MODIFIER_LOGO */
// #define MODKEY WLR_MODIFIER_ALT
#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY,SKEY,TAG) \
	{ MODKEY,                    -1, KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  -1, KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, -1, SKEY,           tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,-1,SKEY,toggletag,  {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *termcmd[] = { "footclient", "tmux", NULL };
static const char *menucmd[] = { "fuzzel", NULL };

static const char *lockcmd[] = { "swaylock", "-i", "~/.config/wallpaper", NULL };

static const char *explodecmd[] = { "pkill", "-SIGKILL", "-x","dwl", NULL };

static const char *poweroffcmd[] = { "/bin/sh", "-c", "poweroff", "||", "loginctl", "poweroff", NULL };
static const char *rebootcmd[] = { "/bin/sh", "-c", "reboot", "||", "loginctl", "reboot", NULL };
static const char *rebootfirmwarecmd[] = { "/bin/sh", "-c", "systemctl", "reboot", "--firmware" "||", "loginctl", "reboot", "--firmware", NULL };
static const char *suspendcmd[] = { "/bin/sh", "-c", "systemctl suspend", "||", "loginctl", "suspend", NULL };

/* media keys */
/* wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
 * wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
 */
static const char *volup[] = { "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "2.5%+", NULL};
static const char *voldown[] = { "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "2.5%-", NULL};
static const char *volmute[] = { "wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle", NULL};

/* playerctl */
static const char *pctlPlayPause[] = { "playerctl", "play-pause", NULL };
static const char *pctlPlay[] = { "playerctl", "play", NULL };
static const char *pctlPause[] = { "playerctl", "pause", NULL };
static const char *pctlPrevious[] = { "playerctl", "previous", NULL };
static const char *pctlNext[] = { "playerctl", "next", NULL };

/* first arg is just to match the rule in rules */
/*
static const char *scratchpadcmd[] = { "s", "kitty", "--class", "kittypad", "--title", "scratchpad", NULL };
static const char *scratchpad_blue_cmd[] = { "b", "kitty", "--class", "kittypad-blue", "--title", "scratchpad", "-e", "bluetuith", NULL };
static const char *scratchpad_nc_cmd[] = { "n", "kitty", "--class", "kittypad-nc", "--title", "scratchpad", "-e", "ncpamixer", NULL };
*/ /* disable kitty scratchpads */
static const char *scratchpadcmd[] = { "s", "footclient", "--app-id", "kittypad", "--title", "scratchpad", NULL };
static const char *scratchpad_blue_cmd[] = { "b", "footclient", "--app-id", "kittypad-blue", "--title", "scratchpad", "-e", "bluetuith", NULL };
static const char *scratchpad_nc_cmd[] = { "n", "footclient", "--app-id", "kittypad-nc", "--title", "scratchpad", "-e", "ncpamixer", NULL };

static const Key keys[] = {
	/* Note that Shift changes certain key codes: c -> C, 2 -> at, etc. */
	/* modifier                  chain  key                 function        argument */
	{ MODKEY,                    -1,    XKB_KEY_d,          spawn,          {.v = menucmd} },
	{ MODKEY,                    -1,    XKB_KEY_Return,     spawn,          {.v = termcmd} },
    /* scratchpads&scripts */
	{ MODKEY,         XKB_KEY_space,    XKB_KEY_a,          togglescratch,  {.v = scratchpadcmd } },
	{ MODKEY,         XKB_KEY_space,    XKB_KEY_b,          togglescratch,  {.v = scratchpad_blue_cmd } },
	{ MODKEY,         XKB_KEY_space,    XKB_KEY_v,          togglescratch,  {.v = scratchpad_nc_cmd } },
	{ MODKEY,         XKB_KEY_space,    XKB_KEY_r,          spawn,          {.v = explodecmd } },
	{ MODKEY,         XKB_KEY_space,    XKB_KEY_l,          spawn,          {.v = lockcmd } },
    /* powermenu */
	{ MODKEY,             XKB_KEY_p,    XKB_KEY_p,          spawn,          {.v = poweroffcmd } },
	{ MODKEY,             XKB_KEY_p,    XKB_KEY_r,          spawn,          {.v = rebootcmd } },
	{ MODKEY,             XKB_KEY_p,    XKB_KEY_f,          spawn,          {.v = rebootfirmwarecmd } },
	{ MODKEY,             XKB_KEY_p,    XKB_KEY_s,          spawn,          {.v = suspendcmd } },

    /* media keys */
	{ 0,                    -1,    XKB_KEY_XF86AudioRaiseVolume,     spawn,          {.v = volup} },
	{ 0,                    -1,    XKB_KEY_XF86AudioLowerVolume,     spawn,          {.v = voldown} },
	{ 0,                    -1,    XKB_KEY_XF86AudioMute,     spawn,          {.v = volmute} },
    /* playerctl keys */
	{ 0,                    -1,    XKB_KEY_XF86AudioMedia,     spawn,          {.v = pctlPlayPause} },
	{ MODKEY,               -1,    XKB_KEY_XF86AudioMute,     spawn,          {.v = pctlPlayPause} },
	{ 0,                    -1,    XKB_KEY_XF86AudioPlay,     spawn,          {.v = pctlPlay} },
	{ 0,                    -1,    XKB_KEY_XF86AudioPause,     spawn,          {.v = pctlPause} },
	{ 0,                    -1,    XKB_KEY_XF86AudioNext,     spawn,          {.v = pctlNext} },
	{ 0,                    -1,    XKB_KEY_XF86AudioPrev,     spawn,          {.v = pctlPrevious} },


    /* back to normal binds */
	{ MODKEY,                    -1,    XKB_KEY_j,          focusstack,     {.i = +1} },
	{ MODKEY,                    -1,    XKB_KEY_k,          focusstack,     {.i = -1} },
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_J,          pushdown,       0 },
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_K,          pushup,         0 },
	{ MODKEY,                    -1,    XKB_KEY_h,          setmfact,       {.f = -0.05f} },
	{ MODKEY,                    -1,    XKB_KEY_l,          setmfact,       {.f = +0.05f} },
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_H,          incnmaster,     {.i = +1} },
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_L,          incnmaster,     {.i = -1} },
	{ MODKEY,                    -1,    XKB_KEY_w,          zoom,           {0} },
	// { MODKEY,                    -1,    XKB_KEY_Tab,        view,           {0} },
	{ MODKEY,                    -1,    XKB_KEY_q,          killclient,     {0} },
	{ MODKEY,           XKB_KEY_Tab,    XKB_KEY_t,          setlayout,      {.v = &layouts[0]} }, /* tile */
	{ MODKEY,           XKB_KEY_Tab,    XKB_KEY_s,          setlayout,      {.v = &layouts[1]} }, /* float */
	{ MODKEY,           XKB_KEY_Tab,    XKB_KEY_f,          setlayout,      {.v = &layouts[2]} }, /* monicle */
	// { MODKEY,           XKB_KEY_Tab,    XKB_KEY_space,      setlayout,      {0} },                /* cycle though layouts */
	{ MODKEY,                    -1,    XKB_KEY_s,          togglefloating, {0} },
	{ MODKEY,                    -1,    XKB_KEY_f,          togglefullscreen, {0} },
	{ MODKEY,                    -1,    XKB_KEY_0,          view,           {.ui = ~0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_parenright, tag,            {.ui = ~0} },
	{ MODKEY,                    -1,    XKB_KEY_comma,      focusmon,       {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY,                    -1,    XKB_KEY_period,     focusmon,       {.i = WLR_DIRECTION_RIGHT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_less,       tagmon,         {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_greater,    tagmon,         {.i = WLR_DIRECTION_RIGHT} },
	TAGKEYS(          XKB_KEY_1,        XKB_KEY_exclam,                     0),
	TAGKEYS(          XKB_KEY_2,        XKB_KEY_at,                         1),
	TAGKEYS(          XKB_KEY_3,        XKB_KEY_numbersign,                 2),
	TAGKEYS(          XKB_KEY_4,        XKB_KEY_dollar,                     3),
	TAGKEYS(          XKB_KEY_5,        XKB_KEY_percent,                    4),
	TAGKEYS(          XKB_KEY_6,        XKB_KEY_asciicircum,                5),
	TAGKEYS(          XKB_KEY_7,        XKB_KEY_ampersand,                  6),
	TAGKEYS(          XKB_KEY_8,        XKB_KEY_asterisk,                   7),
	TAGKEYS(          XKB_KEY_9,        XKB_KEY_parenleft,                  8),
	{ MODKEY|WLR_MODIFIER_SHIFT, -1,    XKB_KEY_Q,          quit,           {0} },

	/* Ctrl-Alt-Backspace and Ctrl-Alt-Fx used to be handled by X server */
	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,-1,XKB_KEY_Terminate_Server, quit, {0} },
	/* Ctrl-Alt-Fx is used to switch to another VT, if you don't know what a VT is
	 * do not remove them.
	 */
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,-1,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
