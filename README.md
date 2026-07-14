# docs

Aggregated documentation for the [LilithSec](https://github.com/LilithSec)
pantheon, built with [MkDocs](https://www.mkdocs.org/) +
[Material](https://squidfunk.github.io/mkdocs-material/) and published to GitHub
Pages.

Each component's docs live in its own repo, under `docs/`.
[`scripts/sync-docs.sh`](scripts/sync-docs.sh) pulls each repo's `docs/` into
`docs/<section>/` (shallow + sparse clone; all sources are public, so no auth is
needed). On top of that this repo adds a landing page, the cross-cutting
[Pantheon](docs/pantheon.md) map, and a hook
([`hooks/pantheon_links.py`](hooks/pantheon_links.py)) that rewrites
inter-component GitHub links into internal links.

## Building locally

```sh
python -m venv .venv && . .venv/bin/activate
pip install -r requirements.txt
./scripts/sync-docs.sh   # pull the component docs into docs/<section>/
mkdocs serve             # http://127.0.0.1:8000
```

Re-run `sync-docs.sh` whenever the component docs change. The synced section
dirs are git-ignored; `docs/virani/` is authored here and not synced. CI runs
the same two steps (see `.github/workflows/deploy.yml`).

The `nav:` in `mkdocs.yml` lists each section's pages explicitly. If a component
adds or removes a doc, update its nav block to match (page titles come from each
page's H1, so only paths are listed).

## Where the docs actually live

| Section | Source repo | Branch | Notes |
|---|---|---|---|
| Lilith | `LilithSec/Lilith` | main | |
| Lilu | `LilithSec/App-Lilu` | main | |
| Baphomet | `VVelox/Baphomet` | main | different org |
| Ereshkigal | `LilithSec/Ereshkigal` | main | |
| Lamashtu | `LilithSec/Lamashtu` | main | |
| Virani | (local) | — | no upstream `docs/` yet; hosted in `docs/Virani/` |
| Nisaba | `VVelox/Plugtools` | **dev** | docs only on `dev`; rename to `LilithSec/Nissaba` pending |

To wire in a new component, add an `!import` line to `nav:` in `mkdocs.yml` and
(if it cross-links) an entry to `hooks/pantheon_links.py`.
