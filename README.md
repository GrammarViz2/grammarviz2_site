GrammarViz website
==================

Source for the GrammarViz project site, published at
<https://grammarviz2.github.io/grammarviz2_site/>.
For the application itself see <https://github.com/GrammarViz2/grammarviz2_src>.

Built with [Hugo](https://gohugo.io/) (extended). The previous Jekyll/Morea
stack has been retired — content now lives as plain Markdown under `content/`.

Layout
------

```
hugo.toml              site config (baseURL is the GitHub Pages subpath)
content/               page content (Markdown)
  _index.md              home
  anomaly/ motif/ …      one folder per module: _index.md + child pages
assets/css/main.css    the design system (shared look with the SAX-VSM site)
layouts/               templates, partials, shortcodes, render hooks
static/images/         figures and screenshots
```

Develop
-------

```
hugo server            # live preview at http://localhost:1313/grammarviz2_site/
```

Build & deploy
--------------

```
hugo --gc --minify     # static site is emitted to public/
```

GitHub Pages serves the `gh-pages` branch. To publish, build and push the
contents of `public/` to `gh-pages` (e.g. with a worktree or
`peaceiris/actions-gh-pages`). Do not edit `gh-pages` by hand.

Writing content
----------------

- Figures: `{{< fig src="name.png" w="800" alt="…" >}}` (images live in
  `static/images/`). Markdown `![alt](name.png)` works too.
- Math: write `$$ … $$` (display) and `\( … \)` (inline); MathJax loads
  automatically on pages that contain math.
- A module is a folder with `_index.md` (the section landing page) plus one
  Markdown file per tutorial/reading; `weight` controls ordering.
