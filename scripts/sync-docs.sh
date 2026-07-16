#!/usr/bin/env bash
#
# Pull each component repo's docs/ into docs/<section>/ for the aggregated site.
# All sources are public, so no auth is needed; repos are cloned shallow + sparse
# (only the docs/ tree is fetched). Run this before `mkdocs build` or serve.
#
# The synced section dirs are git-ignored (see .gitignore) — they are build
# inputs, regenerated from their home repos.
#
set -euo pipefail
export GIT_TERMINAL_PROMPT=0   # never hang on an auth prompt; fail fast instead

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS="$ROOT/docs"

# section      repo                    branch
REPOS=(
  "lilith      LilithSec/Lilith        main"
  "lilu        LilithSec/App-Lilu      main"
  "baphomet    VVelox/Baphomet         main"
  "ereshkigal  LilithSec/Ereshkigal    main"
  "lamashtu    LilithSec/Lamashtu      main"
  "virani      LilithSec/Virani        main"
  "nisaba      VVelox/Plugtools        dev"    # docs live on dev; -> LilithSec/Nissaba after rename
  "allani      LilithSec/Allani        main"
)

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for entry in "${REPOS[@]}"; do
  # shellcheck disable=SC2086
  set -- $entry
  section="$1"; repo="$2"; branch="$3"
  echo ">> $repo@$branch -> docs/$section"
  git clone --quiet --depth 1 --branch "$branch" --filter=blob:none --sparse \
    "https://github.com/$repo.git" "$tmp/$section"
  git -C "$tmp/$section" sparse-checkout set docs >/dev/null
  if [ ! -d "$tmp/$section/docs" ]; then
    echo "!! $repo@$branch has no docs/ directory — skipping" >&2
    continue
  fi
  rm -rf "${DOCS:?}/$section"
  cp -R "$tmp/$section/docs" "$DOCS/$section"
  echo "   files: $(cd "$DOCS/$section" && ls | tr '\n' ' ')"
done

echo "Done."
