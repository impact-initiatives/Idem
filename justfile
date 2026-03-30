# justfile — task automation for the idem R package
# Run `just` to list available recipes, `just <recipe>` to execute one.

# Default: list all recipes
default:
    @just --list

# ── Development ───────────────────────────────────────────────────────────────

# Load package into current R session (prints the devtools call for reference)
load:
    Rscript -e "devtools::load_all()"

# ── Documentation ─────────────────────────────────────────────────────────────

# Regenerate man/ pages and NAMESPACE from roxygen2 tags
doc:
    Rscript -e "devtools::document()"

# Knit README.Rmd → README.md
readme:
    Rscript -e "devtools::build_readme()"

# Build pkgdown documentation site into docs/
site:
    Rscript -e "pkgdown::build_site()"

# serve site
serve:
    uvx python -m http.server --directory docs

# ── Checks & Tests ────────────────────────────────────────────────────────────

# Run the full testthat suite
test:
    Rscript -e "devtools::test()"

# Run a single test file by name (e.g. `just test-file read_xlsform`)
test-file name:
    Rscript -e "devtools::test(filter = '{{ name }}')"

# Lint all R source files
lint:
    Rscript -e "lintr::lint_package()"

# Auto-format all R source files with styler
fmt:
    Rscript -e "styler::style_pkg()"

# Full R CMD CHECK (document + build + test + lint)
check:
    Rscript -e "devtools::check()"

# ── Pre-commit hooks ──────────────────────────────────────────────────────────

# Run all pre-commit hooks against every file
hooks:
    pre-commit run --all-files

# Run a single hook by id (e.g. `just hook lintr`)
hook id:
    pre-commit run {{ id }} --all-files

# Update all hook revisions to their latest releases
hooks-update:
    pre-commit autoupdate

# ── Compound workflows ────────────────────────────────────────────────────────

# Regenerate docs + README, then run full check
ci: doc readme check
