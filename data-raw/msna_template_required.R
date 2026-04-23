# Run this script to regenerate data/msna_template_required.rda.
#
# Prerequisites:
#   devtools::load_all()   # must be run first in the same session
#
# Or from the shell:
#   Rscript -e "devtools::load_all(); source('data-raw/msna_template_required.R')"
path <- system.file("extdata/form.xlsx", package = "idem")

survey_cols <- c(
  "type",
  "name",
  "label::english (en)",
  "label::french (fr)",
  "hint::english (en)",
  "hint::french (fr)",
  "calculation",
  "required",
  "relevant",
  "constraint",
  "default",
  "repeat_count",
  "constraint_message::english (en)",
  "constraint_message::french (fr)",
  "appearance",
  "choice_filter",
  "parameters"
)

choices_cols <- c(
  "list_name",
  "name",
  "label::english (en)",
  "label::french (fr)",
  "parent_country",
  "parent_admin1",
  "parent_admin2",
  "parent_admin3"
)

msna_template_required <- read_xlsform(path)
msna_template_required$survey <- msna_template_required$survey[
  msna_template_required$survey$req == 1,
  survey_cols
]
msna_template_required$choices <- msna_template_required$choices[, choices_cols]

# Strip the absolute local path — the dataset is a self-contained snapshot
# and the path attribute would otherwise embed the contributor's machine path.
attr(msna_template_required, "path") <- NA_character_
attr(msna_template_required, "version") <- as.character(packageVersion("idem"))

usethis::use_data(msna_template_required, overwrite = TRUE)
