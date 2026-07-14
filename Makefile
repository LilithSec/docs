.PHONY: help sync serve build clean deploy

VENV := .venv
PY   := $(VENV)/bin
PIP  := $(PY)/pip

help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*## ' Makefile | \
		awk 'BEGIN{FS=":.*## "}{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

$(VENV): requirements.txt ## Create the virtualenv and install deps
	python3 -m venv $(VENV)
	$(PIP) install -q -r requirements.txt
	@touch $(VENV)

sync: ## Pull each component repo's docs/ into docs/<section>/
	./scripts/sync-docs.sh

serve: $(VENV) sync ## Sync docs, then serve locally at http://127.0.0.1:8000
	$(PY)/mkdocs serve

build: $(VENV) sync ## Sync docs, then build the static site into site/
	$(PY)/mkdocs build

deploy: $(VENV) sync ## Sync docs, then publish to the gh-pages branch
	$(PY)/mkdocs gh-deploy --force

clean: ## Remove build output and synced section dirs
	rm -rf site docs/lilith docs/lilu docs/baphomet docs/ereshkigal docs/lamashtu docs/nisaba
