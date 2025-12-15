# Project Goals

In short - what will Libra be?

Ideals and values:
- Modern in styling while still keeping with the DIY ethic of Gemini
  - Prioritize readability and accessibility
  - Allow users to make it their own
  - By default, don't "hide" the protocol or the markup as heavily as HTML pages tend to
- Don't try to do everything
  - Keep a focused feature set

Core Gemini client features:
- Protocol compliance and support
  - Support the client-server protocol
  - Support Gemtext rendering
  - Support good server certificate management:
    - Transparent to the user until a problem occurs
  - Support good client certificate management:
    - Multiple certificates, assigned per-domain
    - Discourage using certificates across multiple domains

Standard features from other clients:
- Default homepage
- Tabs
- Page history
- Bookmarks
- Titan uploads

Anti-features - things we won't tackle:
- Feeds: we can do this in a capsule too, or an addon?
- HTTP viewing: too difficult, just redirect to other browsers
- Inline content viewing (except images?): just download content
