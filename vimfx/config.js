// zuki's vimfx config.

//imports

// source https://github.com/lydell/dotfiles/blob/1213fc092006586164ad777203958aa55b94c62d/.vimfx/config.js#L8
const {Preferences} = Cu.import('resource://gre/modules/Preferences.jsm', {})

// log startup to check confirm confing loaded.
console.log("loading zuki's vimfx config :", vimfx)

// blacklist vimfx from running on neflix and google docs since they don't play nice with vimfx
//vimfx.set('blacklist', '*www.netflix.com* *docs.google.com*')
vimfx.set('blacklist', '*docs.google.com/spreadsheets*')

// source https://github.com/lydell/dotfiles/blob/1213fc092006586164ad777203958aa55b94c62d/.vimfx/config.js#L63
// Set firefox prefs, note this is a array.
const FIREFOX_PREFS = {
    'toolkit.scrollbox.verticalScrollDistance': 6, //set vimfx scroll speed, note defualt value is 3
}

Preferences.set(FIREFOX_PREFS) // apply firefox prefs

vimfx.addKeyOverrides(
  [ location => location.hostname === 'keyboard-test.space',
    ['<space>','j']
  ]
)
// override a few video sites to passthough space+f rather then pass it to vimfx
vimfx.addKeyOverrides(
  [ location => location.hostname === 'www.netflix.com',
    ['<space>','f']
  ]
)

