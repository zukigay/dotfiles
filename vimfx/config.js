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

const {classes: Cc, interfaces: Ci} = Components

const mpv_path = '/usr/bin/mpv'
const mpv_options = '--video-unscaled=no'
//const mpv_options = '--video-unscaled=yes'

vimfx.addCommand({
  name: 'play_with_mpv',
  description: 'Play the focused link with MPV'
}, ({vim}) => {
  vimfx.send(vim, 'getCurrentUrl', null, url => {
    let file = Cc['@mozilla.org/file/local;1'].createInstance(Ci.nsIFile)
    file.initWithPath(mpv_path)

    let process = Cc['@mozilla.org/process/util;1'].createInstance(Ci.nsIProcess)
    process.init(file)

    let args = mpv_options.split(' ')

    if (url.includes('youtube.com')) {
      // Parse url params to an object like:
      // {"v":"g04s2u30NfQ","index":"3","list":"PL58H4uS5fMRzmMC_SfMelnCoHgB8COa5r"}
      let qs = (function(a) {
        if (a == '') return {}
        let b = {}
        for (let i = 0; i < a.length; ++i) {
          let p = a[i].split('=', 2)
          if (p.length == 1) {
            b[p[0]] = ''
          } else {
            b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, ' '))
          }
        }
        return b
      })(url.substr(1).split('&'))

      if (qs['list'] && qs['index']) {
        // Example args: ['--video-unscaled=yes', '--ytdl-raw-options=format=best']
        // So check for ytdl-raw-options.
        let ytdlRawOptionsIndex = -1
        for (let i = 0; i < args.length; i++) {
          if (args[i].includes('ytdl-raw-options')) {
            ytdlRawOptionsIndex = i
            break
          }
        }

        if (ytdlRawOptionsIndex > -1) {
            args[ytdlRawOptionsIndex] += `,yes-playlist=,playlist-start=${qs['index']}`
        } else {
            args.push(`--ytdl-raw-options=yes-playlist=,playlist-start=${qs['index']}`)
        }
      }
    }

    args.push(url)

    // process.run(false, args, args.length)
    process.runAsync(args, args.length)
  })
})

vimfx.addCommand({
  name: 'play_link_with_mpv',
  description: 'Play the focused link with MPV'
}, ({vim}) => {
  vimfx.send(vim, 'getCurrentHref', null, url => {
    let file = Cc['@mozilla.org/file/local;1'].createInstance(Ci.nsIFile)
    file.initWithPath(mpv_path)

    let process = Cc['@mozilla.org/process/util;1'].createInstance(Ci.nsIProcess)
    process.init(file)

    let args = mpv_options.split(' ')
    console.log('href', url)

    if (url.includes('youtube.com')) {
      // Parse url params to an object like:
      // {"v":"g04s2u30NfQ","index":"3","list":"PL58H4uS5fMRzmMC_SfMelnCoHgB8COa5r"}
      let qs = (function(a) {
        if (a == '') return {}
        let b = {}
        for (let i = 0; i < a.length; ++i) {
          let p = a[i].split('=', 2)
          if (p.length == 1) {
            b[p[0]] = ''
          } else {
            b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, ' '))
          }
        }
        return b
      })(url.substr(1).split('&'))

      if (qs['list'] && qs['index']) {
        // Example args: ['--video-unscaled=yes', '--ytdl-raw-options=format=best']
        // So check for ytdl-raw-options.
        let ytdlRawOptionsIndex = -1
        for (let i = 0; i < args.length; i++) {
          if (args[i].includes('ytdl-raw-options')) {
            ytdlRawOptionsIndex = i
            break
          }
        }

        if (ytdlRawOptionsIndex > -1) {
            args[ytdlRawOptionsIndex] += `,yes-playlist=,playlist-start=${qs['index']}`
        } else {
            args.push(`--ytdl-raw-options=yes-playlist=,playlist-start=${qs['index']}`)
        }
      }
    }

    args.push(url)

    // process.run(false, args, args.length)
    process.runAsync(args, args.length)
  })
})

vimfx.set('custom.mode.normal.play_with_mpv', 'z')
vimfx.set('custom.mode.normal.play_link_with_mpv', 'Z')
