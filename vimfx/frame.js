// holy this is all it took?
// this single line sets the app title of firefox to
// {url} — Mozilla Firefox
//content.document.title = content.document.location 
vimfx.listen('getCurrentUrl', (data, callback) => {
  //let {href} = content.document.activeElement
  let {href} = content.document.location
  callback(href)
})

vimfx.listen('getCurrentHref', (data, callback) => {
  let {href} = content.document.activeElement
  //let {href} = content.document.location
  callback(href)
})
