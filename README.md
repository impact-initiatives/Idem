
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Idem

<!-- badges: start -->

<!-- badges: end -->

Idem helps you validate XLSForm files against an authoritative reference
form. It is designed for workflows where a canonical form is maintained
centrally and partner or localised copies must stay in sync with it —
catching drift in question names, choice lists, and answer options
before it causes problems in data collection or analysis.

## Installation

``` r
# install.packages("pak")
pak::pak("impact-initiatives/Idem")
```

## Key concepts

### `target` — the authoritative reference form

The **`target`** form is the canonical, centrally maintained XLSForm. It
defines the full set of permitted questions, choice lists, and answer
options for a given data collection exercise. Think of it as the source
of truth: what *can* legally appear in any deployed copy of the form.

### `dev` — the form being validated

The **`dev`** form is the copy you want to check — a localised
adaptation, a partner’s version, or a form deployed in a specific
context. It is validated *against* `target` to confirm it stays within
the boundaries that `target` defines.

### The rule: target must be a subset of dev

Idem enforces one rule: **everything present in `target` must also exist
in `dev`**. In other words, `target` is a valid *subset* of `dev`.

This means:

- `dev` is allowed to have questions, lists, or options that `target`
  does not have — that is expected and fine.
- `dev` is **not** allowed to be missing questions, lists, or options
  that `target` requires — those gaps are flagged as errors.

## The checks

Four checks apply this rule to different parts of the form:

| Check | What is tested |
|----|----|
| `question_names` | Every question name in `target` must exist in `dev`. |
| `list_names` | Every choice list *defined* in `target`’s choices sheet must also be defined in `dev`’s choices sheet. |
| `survey_list_names` | Every choice list *referenced* by `target`’s survey questions must also be referenced in `dev`’s survey questions. |
| `choices` | For every shared list, every choice option in `target` must exist in the same list in `dev`. |

All checks return a tidy tibble — one row per issue — so results can be
filtered, counted, and passed to downstream reporting tools.

------------------------------------------------------------------------

## Setup

``` r
library(Idem)
```

Idem ships with a sample XLSForm. We will use it as our reference
throughout this tutorial.

``` r
path   <- system.file("extdata/form.xlsx", package = "Idem")
target <- read_xlsform(path)
target
#> <xlsform> '/tmp/RtmpZ2Qf99/temp_libpath2df315ed3db24/Idem/extdata/form.xlsx'
#> • survey: 315 rows
#> • choices: 2497 rows
```

------------------------------------------------------------------------

## Exploring a form

Before running validation, the extractor functions let you inspect the
contents of any form.

### Question names

``` r
xlsform_questions(target) |> head(15)
#>  [1] "audit"           "start"           "end"             "today"          
#>  [5] "deviceid"        "instance_name"   "recall_date"     "recall_event"   
#>  [9] "recall_month"    "recall_event_en" "recall_event_fr" "introduction"   
#> [13] "survey_modality" "enum_id"         "enum_gender"
```

### Choice lists referenced in the survey

These are the list names extracted from the `type` column — the second
token in values like `select_one l_yn`.

``` r
xlsform_list_names(target)
#>  [1] "l_survey_modality"                         
#>  [2] "l_enum_id"                                 
#>  [3] "l_gender"                                  
#>  [4] "l_country"                                 
#>  [5] "l_admin1"                                  
#>  [6] "l_admin2"                                  
#>  [7] "l_admin3"                                  
#>  [8] "l_admin4"                                  
#>  [9] "l_cluster_id"                              
#> [10] "l_yn"                                      
#> [11] "l_setting"                                 
#> [12] "l_aap_priority_challenge"                  
#> [13] "l_aap_priority_support_ngo"                
#> [14] "l_aap_preferred_modality"                  
#> [15] "l_yn_dnk_pnta"                             
#> [16] "l_aap_received_assistance_date"            
#> [17] "l_edu_level_grade"                         
#> [18] "l_edu_barrier"                             
#> [19] "l_snfi_shelter_type"                       
#> [20] "l_snfi_shelter_type_individual"            
#> [21] "l_snfi_shelter_issue"                      
#> [22] "l_snfi_fds_cooking"                        
#> [23] "l_snfi_fds_cooking_issue"                  
#> [24] "l_snfi_fds"                                
#> [25] "l_snfi_fds_sleeping_issue"                 
#> [26] "l_snfi_fds_storing"                        
#> [27] "l_snfi_fds_storing_issue"                  
#> [28] "l_energy_lighting_source"                  
#> [29] "l_hlp_occupancy"                           
#> [30] "l_hlp_threat_eviction"                     
#> [31] "l_wash_drinking_water_source"              
#> [32] "l_wash_drinking_water_time_yn"             
#> [33] "l_wash_drinking_water_time_sl"             
#> [34] "l_wash_hwise"                              
#> [35] "l_wash_sanitation_facility"                
#> [36] "l_wash_handwashing_facility"               
#> [37] "l_wash_handwashing_facility_observed_water"
#> [38] "l_wash_soap_observed"                      
#> [39] "l_wash_handwashing_facility_reported"      
#> [40] "l_wash_soap_type"                          
#> [41] "l_fsl_hhs"                                 
#> [42] "l_fsl_source_food"                         
#> [43] "l_fsl_lcsi"                                
#> [44] "l_fsl_lcsi_other"                          
#> [45] "l_fsl_lcsi_en_other"                       
#> [46] "l_cm_expenditure_frequent"                 
#> [47] "l_cm_expenditure_infrequent"               
#> [48] "l_health_ind_healthcare_needed_type"       
#> [49] "l_nut_ind_under5_sick_symptoms"            
#> [50] "l_nut_ind_under5_sick_location"            
#> [51] "l_prot_perceived_risk"                     
#> [52] "l_prot_needs_1_services"                   
#> [53] "l_prot_needs_1_justice"                    
#> [54] "l_prot_needs_2_activities"                 
#> [55] "l_prot_needs_2_social"                     
#> [56] "l_prot_needs_3_movement"                   
#> [57] "l_prot_child_sep_reason"
```

### Choice lists defined in the choices sheet

``` r
xlsform_choices_list_names(target)
#>  [1] "l_survey_modality"                         
#>  [2] "l_enum_id"                                 
#>  [3] "l_gender"                                  
#>  [4] "l_country"                                 
#>  [5] "l_admin3"                                  
#>  [6] "l_admin4"                                  
#>  [7] "l_cluster_id"                              
#>  [8] "l_yn"                                      
#>  [9] "l_yn_dnk_pnta"                             
#> [10] "l_setting"                                 
#> [11] "l_ind_age_under1"                          
#> [12] "l_edu_level_grade"                         
#> [13] "l_edu_barrier"                             
#> [14] "l_fsl_hhs"                                 
#> [15] "l_fsl_source_food"                         
#> [16] "l_fsl_lcsi"                                
#> [17] "l_fsl_lcsi_other"                          
#> [18] "l_fsl_lcsi_en_other"                       
#> [19] "l_cm_income_source"                        
#> [20] "l_nut_ind_under5_sick_symptoms"            
#> [21] "l_nut_ind_under5_sick_location"            
#> [22] "l_aap_priority_challenge"                  
#> [23] "l_aap_priority_support_ngo"                
#> [24] "l_aap_preferred_modality"                  
#> [25] "l_aap_received_assistance_date"            
#> [26] "l_snfi_shelter_type"                       
#> [27] "l_snfi_shelter_type_individual"            
#> [28] "l_snfi_shelter_issue"                      
#> [29] "l_snfi_fds_cooking"                        
#> [30] "l_snfi_fds_cooking_issue"                  
#> [31] "l_snfi_fds"                                
#> [32] "l_snfi_fds_storing"                        
#> [33] "l_snfi_fds_sleeping_issue"                 
#> [34] "l_snfi_fds_storing_issue"                  
#> [35] "l_snfi_fds_personal_hygiene_issue"         
#> [36] "l_hlp_threat_eviction"                     
#> [37] "l_wash_drinking_water_source"              
#> [38] "l_wash_drinking_water_time_yn"             
#> [39] "l_wash_drinking_water_time_sl"             
#> [40] "l_wash_hwise"                              
#> [41] "l_wash_sanitation_facility"                
#> [42] "l_wash_handwashing_facility"               
#> [43] "l_wash_handwashing_facility_observed_water"
#> [44] "l_wash_handwashing_facility_observed_soap" 
#> [45] "l_wash_handwashing_facility_reported"      
#> [46] "l_wash_soap_observed"                      
#> [47] "l_wash_soap_type"                          
#> [48] "l_health_ind_healthcare_needed_type"       
#> [49] "l_prot_perceived_risk"                     
#> [50] "l_energy_lighting_source"                  
#> [51] "l_hlp_occupancy"                           
#> [52] "l_prot_child_sep_reason"                   
#> [53] "l_prot_needs_1_services"                   
#> [54] "l_prot_needs_1_justice"                    
#> [55] "l_prot_needs_2_activities"                 
#> [56] "l_prot_needs_2_social"                     
#> [57] "l_prot_needs_3_movement"                   
#> [58] "l_cm_expenditure_frequent"                 
#> [59] "l_cm_expenditure_infrequent"               
#> [60] "l_admin1"                                  
#> [61] "l_admin2"
```

### Choice options per list

``` r
xlsform_choices(target)[["l_yn"]]
#> [1] "yes" "no"
```

------------------------------------------------------------------------

## Validating forms

### The clean case — no issues

A form is always a valid subset of itself. Running `validate_xlsform()`
against an identical form returns an empty tibble.

``` r
validate_xlsform(target, target)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>
```

### What is and isn’t flagged

The following examples make the subset rule concrete by demonstrating
the **passing direction** for each check: `dev` carrying extra content
that `target` doesn’t require. In every case the result is an empty
tibble.

``` r
# dev has an extra question that target doesn't need — passes
dev_extra_q      <- target$survey[1L, ]
dev_extra_q$name <- "dev_only_question"
dev_with_extra_q <- xlsform(
  survey  = rbind(target$survey, dev_extra_q),
  choices = target$choices
)
validate_question_names(target, dev_with_extra_q)   # 0 issues — target is a valid subset
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# dev defines an extra choice list that target doesn't use — passes
dev_extra_list           <- target$choices[target$choices$list_name == "l_yn" &
                                             !is.na(target$choices$list_name), ]
dev_extra_list$list_name <- "l_dev_only"
dev_with_extra_list      <- xlsform(
  survey  = target$survey,
  choices = rbind(target$choices, dev_extra_list)
)
validate_list_names(target, dev_with_extra_list)    # 0 issues — target need not use every list in dev
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# dev references an extra list in its survey that target doesn't — passes
dev_survey_extra     <- target$survey
dev_survey_extra$type[dev_survey_extra$type == "text"][1L] <- "select_one l_dev_only"
dev_with_extra_ref   <- xlsform(
  survey  = dev_survey_extra,
  choices = rbind(target$choices, dev_extra_list)
)
validate_survey_list_names(target, dev_with_extra_ref)  # 0 issues — target simply doesn't use that list
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# dev has an extra choice option in a shared list that target doesn't — passes
dev_extra_opt      <- target$choices[target$choices$list_name == "l_yn" &
                                       !is.na(target$choices$list_name), ][1L, ]
dev_extra_opt$name <- "not_applicable"
dev_with_extra_opt <- xlsform(
  survey  = target$survey,
  choices = rbind(target$choices, dev_extra_opt)
)
validate_choices(target, dev_with_extra_opt)  # 0 issues — target uses a subset of available options
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>
```

All four return empty tibbles — no issues — confirming that `dev` being
a superset of `target` is always allowed.

### Building a target form with issues

In practice you load both forms from disk:

``` r
target <- read_xlsform("path/to/target.xlsx")
dev    <- read_xlsform("path/to/dev.xlsx")
```

For this tutorial we construct a `target` that has content `dev` is
missing, introducing one example of each issue type.

``` r
# 1. target requires a question dev doesn't have
extra_q        <- target$survey[1L, ]
extra_q$name   <- "required_indicator"
target_survey  <- rbind(target$survey, extra_q)

# 2. target requires a choice option dev is missing (in the 'l_yn' list)
extra_opt      <- target$choices[target$choices$list_name == "l_yn" &
                                   !is.na(target$choices$list_name), ][1L, ]
extra_opt$name <- "mandatory_option"

# 3. target defines a choice list that dev's choices sheet doesn't have
new_list           <- target$choices[target$choices$list_name == "l_yn" &
                                       !is.na(target$choices$list_name), ][1:2, ]
new_list$list_name <- "l_required_scale"
new_list$name      <- c("low", "high")

target_choices <- rbind(target$choices, extra_opt, new_list)

# 4. target references a list in its survey that dev's survey doesn't have
target_survey$type[target_survey$type == "text"][1L] <- "select_one l_required_scale"

# Build a dev form that is the original (without the additions above)
# so that it is missing everything target now requires
dev <- xlsform(survey = target$survey, choices = target$choices)

# Re-assign target with all the additions
target_with_issues <- xlsform(survey = target_survey, choices = target_choices)
```

### Running all checks at once

`validate_xlsform()` runs every check and returns a combined tibble.

``` r
issues <- validate_xlsform(target_with_issues, dev)
knitr::kable(issues)
```

| check | severity | name | list_name | detail |
|:---|:---|:---|:---|:---|
| question_names | error | required_indicator | NA | Question ‘required_indicator’ is present in target but not in dev. |
| list_names | error | l_required_scale | NA | List ‘l_required_scale’ is defined in target’s choices but not in dev’s choices. |
| survey_list_names | error | l_required_scale | NA | List ‘l_required_scale’ is referenced in target’s survey but not in dev’s survey. |
| choices | error | mandatory_option | l_yn | Choice ‘mandatory_option’ in list ‘l_yn’ is present in target but not in dev. |

------------------------------------------------------------------------

## Individual checks

Each check can also be run in isolation when you only need a focused
result.

### `validate_question_names()`

Checks that every question name in `target` exists in `dev`.

``` r
result_qn <- validate_question_names(target_with_issues, dev)
knitr::kable(result_qn)
```

| check | severity | name | list_name | detail |
|:---|:---|:---|:---|:---|
| question_names | error | required_indicator | NA | Question ‘required_indicator’ is present in target but not in dev. |

### `validate_list_names()`

Checks that every choice list *defined* in `target`’s choices sheet also
exists in `dev`’s choices sheet.

``` r
result_ln <- validate_list_names(target_with_issues, dev)
knitr::kable(result_ln)
```

| check | severity | name | list_name | detail |
|:---|:---|:---|:---|:---|
| list_names | error | l_required_scale | NA | List ‘l_required_scale’ is defined in target’s choices but not in dev’s choices. |

### `validate_survey_list_names()`

Checks that every choice list *referenced* in `target`’s survey
questions is also referenced in `dev`’s survey questions.

This is complementary to `validate_list_names()`: a list might be
defined in the choices sheet but never used — or, as in our example, a
question type changed from `text` to `select_one l_required_scale`
without a matching entry in dev’s survey.

``` r
result_sln <- validate_survey_list_names(target_with_issues, dev)
knitr::kable(result_sln)
```

| check | severity | name | list_name | detail |
|:---|:---|:---|:---|:---|
| survey_list_names | error | l_required_scale | NA | List ‘l_required_scale’ is referenced in target’s survey but not in dev’s survey. |

### `validate_choices()`

For every choice list present in *both* forms, checks that all options
in `target` also exist in `dev`.

Note: lists that exist only in `target` (caught by
`validate_list_names()`) are not reported here — this check focuses on
options within shared lists.

``` r
result_ch <- validate_choices(target_with_issues, dev)
knitr::kable(result_ch)
```

| check | severity | name | list_name | detail |
|:---|:---|:---|:---|:---|
| choices | error | mandatory_option | l_yn | Choice ‘mandatory_option’ in list ‘l_yn’ is present in target but not in dev. |

------------------------------------------------------------------------

## Running a subset of checks

Pass a character vector to the `checks` argument to run only the checks
you need.

``` r
validate_xlsform(
  target_with_issues, dev,
  checks = c("question_names", "choices")
) |>
  knitr::kable()
```

| check | severity | name | list_name | detail |
|:---|:---|:---|:---|:---|
| question_names | error | required_indicator | NA | Question ‘required_indicator’ is present in target but not in dev. |
| choices | error | mandatory_option | l_yn | Choice ‘mandatory_option’ in list ‘l_yn’ is present in target but not in dev. |

------------------------------------------------------------------------

## Working with results

Because `validate_xlsform()` returns a plain tibble, standard data
manipulation works directly on the output.

``` r
# Count issues by check
issues |>
  dplyr::count(check, severity, name = "n_issues")
#> # A tibble: 4 × 3
#>   check             severity n_issues
#>   <chr>             <chr>       <int>
#> 1 choices           error           1
#> 2 list_names        error           1
#> 3 question_names    error           1
#> 4 survey_list_names error           1
```
