# Email Template Builder Makefile

# Variables
NODE = node
NPM = npm

BUILD_SCRIPT = scripts/build.js
BUILDDIR ?= build
DIST_DIR = dist
TEMPLATES_DIR = templates
REPLICATED_API_ORIGIN ?= https://api.replicated.com/vendor
REPLICATED_API_TOKEN ?= $(shell yq .token ${HOME}/.replicated/config.yaml)

CONFIG_FILES = $(shell find config -name '*.json' -o -type d)
MJML_FILES = $(shell find src -name '*.css' -o -name '*.mjml' -o -type d)

# Default target
.PHONY: all
all: apply

# Install dependencies
install: package.json
	$(NPM) install

# Clean build artifacts
.PHONY: clean
clean:
	@rm -rf $(DIST_DIR) $(TEMPLATES_DIR)
	@rm -f $(BUILDDIR)/email-templates.json

# Build all templates
build: $(MJML_FILES) $(CONFIG_FILES) install
	BUILDDIR=$(BUILDDIR) $(NODE) $(BUILD_SCRIPT)

# Apply templates to Replicated API
apply: build $(BUILDDIR)/email-templates.json
	@if [ -z "$(REPLICATED_APP)" ]; then \
		echo "Error: REPLICATED_APP environment variable is required"; \
		exit 1; \
	fi
	$(eval APP_ID := $(shell replicated app ls --output json | jq -r --arg slug "$(REPLICATED_APP)" '.[] | select(.app.slug == $$slug) | .app.id'))
	@if [ -z "$(APP_ID)" ] || [ "$(APP_ID)" = "null" ]; then \
		echo "Error: Could not find app ID for slug '$(REPLICATED_APP)'"; \
		exit 1; \
	fi
	curl -X PUT \
		-H "Authorization: $(REPLICATED_API_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @$(BUILDDIR)/email-templates.json \
		"$(REPLICATED_API_ORIGIN)/v3/app/$(APP_ID)/enterprise-portal/email-templates"

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all          - Build all templates (default)"
	@echo "  install      - Install npm dependencies"
	@echo "  clean        - Remove build artifacts"
	@echo "  build        - Build all email templates"
	@echo "  apply        - Build and apply templates to Replicated API"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  BUILDDIR     - Directory to place email-templates.json (default: .)"
	@echo ""
