"""MkDocs hook: rewrite github.com repo links into internal section links.

The component docs cross-reference each other with absolute GitHub URLs
(e.g. https://github.com/LilithSec/Ereshkigal). Those are correct when a repo
is viewed standalone on GitHub, but in the aggregated site we want them to point
at the corresponding section instead.

Keyed on the *bare repo name* (last path segment), not org/repo, so it absorbs:
  - the LilithSec <-> VVelox org drift (Baphomet lives under VVelox; some docs
    link to LilithSec/Baphomet),
  - the pending Plugtools -> Nissaba rename and the Nisaba/App-Nisaba module name.

If the section slugs multirepo produces differ from these (check `mkdocs serve`),
adjust NAME_TO_SECTION values to match.
"""

import re

# Site root; cross-links become absolute so they resolve the same in prod and
# in `mkdocs build`. (In `mkdocs serve` they will jump to the prod host.)
BASE = "https://lilithsec.github.io/docs"

# bare repo name -> section URL slug. multirepo lowercases the section name for
# the on-disk/URL path, so the slugs here are lowercase to match.
NAME_TO_SECTION = {
    "Lilith": "lilith",
    "App-Lilu": "lilu",
    "Baphomet": "baphomet",
    "Ereshkigal": "ereshkigal",
    "Lamashtu": "lamashtu",
    "Virani": "virani",
    "Plugtools": "nisaba",
    "Nissaba": "nisaba",
    "Nisaba": "nisaba",
}

_RE = re.compile(r"https://github\.com/[\w.-]+/([\w.-]+?)/?(?=[)\s>\"]|$)")


def on_page_markdown(markdown, page, config, files, **kwargs):
    def repl(m):
        section = NAME_TO_SECTION.get(m.group(1))
        return f"{BASE}/{section}/" if section else m.group(0)

    return _RE.sub(repl, markdown)
