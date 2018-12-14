# Search for things using the F2, F3, and F4 keys, all at once

Note: while you're welcome to use this, I'm mostly putting this here as part of my switch to using straight.el.

## Example of usage:


`C-<key>` to search for a thing at the point AND to save that search string for later use by that same key

`<key>` to repeat the search, forwards

`S-<key>` to search backwards

search strings will be saved across sessions
*WARNING*: This probably won't work out-of-the-box.  If anyone ever uses this package let me know & I can refactor it for your ease-of-use

```
(use-package mike-search
  :bind (
         ("C-<f2>" . search-thing-at-point)
         ("C-<f3>" . search-thing-at-point)
         ("C-<f4>" . search-thing-at-point)
         ("C-<f5>" . search-thing-at-point)
         ("<f2>" . repeat-search-thing-at-point-forward)
         ("<f3>" . repeat-search-thing-at-point-forward)
         ("<f4>" . repeat-search-thing-at-point-forward)
         ("<f5>" . repeat-search-thing-at-point-forward)
         ("S-<f2>" . repeat-search-thing-at-point-backward)
         ("S-<f3>" . repeat-search-thing-at-point-backward)
         ("S-<f4>" . repeat-search-thing-at-point-backward)
         ("S-<f5>" . repeat-search-thing-at-point-backward)
         )
  )

```
