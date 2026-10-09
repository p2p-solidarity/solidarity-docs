export default {
  // Archived docs: hide "Last updated on <date>" on every page (the theme
  // setting cascades into the usage/ and architecture/ folders). Cloudflare
  // builds from a shallow clone, so every page would show the date of the
  // latest commit while the banner says the docs are no longer updated.
  '*': {
    theme: {
      timestamp: false
    }
  },
  index: 'Introduction',
  'usage': 'Usage Guide',
  'architecture': 'Architecture',
  'contribute': 'Contributing'
}
