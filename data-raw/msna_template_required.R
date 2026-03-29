# Run this script to regenerate data/msna_template_required.rda.
#
# Prerequisites:
#   devtools::load_all()   # must be run first in the same session
#
# Or from the shell:
#   Rscript -e "devtools::load_all(); source('data-raw/msna_template_required.R')"

path <- system.file("extdata/form.xlsx", package = "Idem")

msna_template_required <- read_xlsform(path)

# Strip the absolute local path — the dataset is a self-contained snapshot
# and the path attribute would otherwise embed the contributor's machine path.
attr(msna_template_required, "path") <- NA_character_

usethis::use_data(msna_template_required, overwrite = TRUE)
