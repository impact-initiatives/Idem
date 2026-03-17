
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
library(gt)
```

Idem ships with a sample XLSForm. We will use it as our reference
throughout this tutorial.

``` r
path   <- system.file("extdata/form.xlsx", package = "Idem")
target <- read_xlsform(path)
target
#> <xlsform> '/tmp/RtmprdzN2c/temp_libpath2bcf77a498f2c/Idem/extdata/form.xlsx'
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
issues
#> # A tibble: 4 × 5
#>   check             severity name               list_name detail                
#>   <chr>             <chr>    <chr>              <chr>     <chr>                 
#> 1 question_names    error    required_indicator <NA>      Question 'required_in…
#> 2 list_names        error    l_required_scale   <NA>      List 'l_required_scal…
#> 3 survey_list_names error    l_required_scale   <NA>      List 'l_required_scal…
#> 4 choices           error    mandatory_option   l_yn      Choice 'mandatory_opt…
```

<div id="wlqckrkmkw" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#wlqckrkmkw table {
  font-family: 'IBM Plex Mono', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#wlqckrkmkw thead, #wlqckrkmkw tbody, #wlqckrkmkw tfoot, #wlqckrkmkw tr, #wlqckrkmkw td, #wlqckrkmkw th {
  border-style: none;
}
&#10;#wlqckrkmkw p {
  margin: 0;
  padding: 0;
}
&#10;#wlqckrkmkw .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #004D80;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #004D80;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#wlqckrkmkw .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#wlqckrkmkw .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#wlqckrkmkw .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#wlqckrkmkw .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#wlqckrkmkw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#wlqckrkmkw .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#wlqckrkmkw .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#wlqckrkmkw .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#wlqckrkmkw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#wlqckrkmkw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#wlqckrkmkw .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#wlqckrkmkw .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#wlqckrkmkw .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#wlqckrkmkw .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: middle;
}
&#10;#wlqckrkmkw .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#wlqckrkmkw .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#wlqckrkmkw .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: none;
  border-top-width: 1px;
  border-top-color: #89D3FE;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #89D3FE;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #89D3FE;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#wlqckrkmkw .gt_stub {
  color: #FFFFFF;
  background-color: #0076BA;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #0076BA;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wlqckrkmkw .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#wlqckrkmkw .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#wlqckrkmkw .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#wlqckrkmkw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wlqckrkmkw .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #0076BA;
}
&#10;#wlqckrkmkw .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#wlqckrkmkw .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#wlqckrkmkw .gt_grand_summary_row {
  color: #333333;
  background-color: #89D3FE;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wlqckrkmkw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #0076BA;
}
&#10;#wlqckrkmkw .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #0076BA;
}
&#10;#wlqckrkmkw .gt_striped {
  background-color: #F4F4F4;
}
&#10;#wlqckrkmkw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#wlqckrkmkw .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#wlqckrkmkw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wlqckrkmkw .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#wlqckrkmkw .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wlqckrkmkw .gt_left {
  text-align: left;
}
&#10;#wlqckrkmkw .gt_center {
  text-align: center;
}
&#10;#wlqckrkmkw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#wlqckrkmkw .gt_font_normal {
  font-weight: normal;
}
&#10;#wlqckrkmkw .gt_font_bold {
  font-weight: bold;
}
&#10;#wlqckrkmkw .gt_font_italic {
  font-style: italic;
}
&#10;#wlqckrkmkw .gt_super {
  font-size: 65%;
}
&#10;#wlqckrkmkw .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#wlqckrkmkw .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#wlqckrkmkw .gt_indent_1 {
  text-indent: 5px;
}
&#10;#wlqckrkmkw .gt_indent_2 {
  text-indent: 10px;
}
&#10;#wlqckrkmkw .gt_indent_3 {
  text-indent: 15px;
}
&#10;#wlqckrkmkw .gt_indent_4 {
  text-indent: 20px;
}
&#10;#wlqckrkmkw .gt_indent_5 {
  text-indent: 25px;
}
&#10;#wlqckrkmkw .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#wlqckrkmkw div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" style="table-layout:fixed;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <colgroup>
    <col/>
    <col/>
    <col/>
    <col/>
    <col style="width:340px;"/>
  </colgroup>
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal" style><span class='gt_from_md'><strong>Validation results</strong></span></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style><span class='gt_from_md'>All checks — <code>target</code> vs <code>dev</code></span></td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="check">Check</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="severity">Severity</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="name">Name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="list_name">List</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="detail">Detail</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="check" class="gt_row gt_left" style="background-color: #FCE8E8;">question_names</td>
<td headers="severity" class="gt_row gt_left" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left" style="background-color: #FCE8E8;">required_indicator</td>
<td headers="list_name" class="gt_row gt_left" style="background-color: #FCE8E8;">NA</td>
<td headers="detail" class="gt_row gt_left" style="background-color: #FCE8E8;">Question 'required_indicator' is present in target but not in dev.</td></tr>
    <tr><td headers="check" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">list_names</td>
<td headers="severity" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">l_required_scale</td>
<td headers="list_name" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">NA</td>
<td headers="detail" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">List 'l_required_scale' is defined in target's choices but not in dev's choices.</td></tr>
    <tr><td headers="check" class="gt_row gt_left" style="background-color: #FCE8E8;">survey_list_names</td>
<td headers="severity" class="gt_row gt_left" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left" style="background-color: #FCE8E8;">l_required_scale</td>
<td headers="list_name" class="gt_row gt_left" style="background-color: #FCE8E8;">NA</td>
<td headers="detail" class="gt_row gt_left" style="background-color: #FCE8E8;">List 'l_required_scale' is referenced in target's survey but not in dev's survey.</td></tr>
    <tr><td headers="check" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">choices</td>
<td headers="severity" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">mandatory_option</td>
<td headers="list_name" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">l_yn</td>
<td headers="detail" class="gt_row gt_left gt_striped" style="background-color: #FCE8E8;">Choice 'mandatory_option' in list 'l_yn' is present in target but not in dev.</td></tr>
  </tbody>
  &#10;</table>
</div>

------------------------------------------------------------------------

## Individual checks

Each check can also be run in isolation when you only need a focused
result.

### `validate_question_names()`

Checks that every question name in `target` exists in `dev`.

``` r
result_qn <- validate_question_names(target_with_issues, dev)
result_qn
#> # A tibble: 1 × 5
#>   check          severity name               list_name detail                   
#>   <chr>          <chr>    <chr>              <chr>     <chr>                    
#> 1 question_names error    required_indicator <NA>      Question 'required_indic…
```

<div id="fmogsnhndv" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#fmogsnhndv table {
  font-family: 'IBM Plex Mono', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#fmogsnhndv thead, #fmogsnhndv tbody, #fmogsnhndv tfoot, #fmogsnhndv tr, #fmogsnhndv td, #fmogsnhndv th {
  border-style: none;
}
&#10;#fmogsnhndv p {
  margin: 0;
  padding: 0;
}
&#10;#fmogsnhndv .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #004D80;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #004D80;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#fmogsnhndv .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#fmogsnhndv .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#fmogsnhndv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#fmogsnhndv .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#fmogsnhndv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#fmogsnhndv .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#fmogsnhndv .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#fmogsnhndv .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#fmogsnhndv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#fmogsnhndv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#fmogsnhndv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#fmogsnhndv .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#fmogsnhndv .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#fmogsnhndv .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: middle;
}
&#10;#fmogsnhndv .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#fmogsnhndv .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#fmogsnhndv .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: none;
  border-top-width: 1px;
  border-top-color: #89D3FE;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #89D3FE;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #89D3FE;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#fmogsnhndv .gt_stub {
  color: #FFFFFF;
  background-color: #0076BA;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #0076BA;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fmogsnhndv .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#fmogsnhndv .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#fmogsnhndv .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#fmogsnhndv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fmogsnhndv .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #0076BA;
}
&#10;#fmogsnhndv .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#fmogsnhndv .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#fmogsnhndv .gt_grand_summary_row {
  color: #333333;
  background-color: #89D3FE;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fmogsnhndv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #0076BA;
}
&#10;#fmogsnhndv .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #0076BA;
}
&#10;#fmogsnhndv .gt_striped {
  background-color: #F4F4F4;
}
&#10;#fmogsnhndv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#fmogsnhndv .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#fmogsnhndv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fmogsnhndv .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#fmogsnhndv .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fmogsnhndv .gt_left {
  text-align: left;
}
&#10;#fmogsnhndv .gt_center {
  text-align: center;
}
&#10;#fmogsnhndv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#fmogsnhndv .gt_font_normal {
  font-weight: normal;
}
&#10;#fmogsnhndv .gt_font_bold {
  font-weight: bold;
}
&#10;#fmogsnhndv .gt_font_italic {
  font-style: italic;
}
&#10;#fmogsnhndv .gt_super {
  font-size: 65%;
}
&#10;#fmogsnhndv .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#fmogsnhndv .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#fmogsnhndv .gt_indent_1 {
  text-indent: 5px;
}
&#10;#fmogsnhndv .gt_indent_2 {
  text-indent: 10px;
}
&#10;#fmogsnhndv .gt_indent_3 {
  text-indent: 15px;
}
&#10;#fmogsnhndv .gt_indent_4 {
  text-indent: 20px;
}
&#10;#fmogsnhndv .gt_indent_5 {
  text-indent: 25px;
}
&#10;#fmogsnhndv .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#fmogsnhndv div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" style="table-layout:fixed;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <colgroup>
    <col/>
    <col/>
    <col/>
    <col/>
    <col style="width:340px;"/>
  </colgroup>
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal" style><span class='gt_from_md'><strong>Check: <code>question_names</code></strong></span></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Questions present in target but absent from dev</td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="check">Check</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="severity">Severity</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="name">Name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="list_name">List</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="detail">Detail</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="check" class="gt_row gt_left" style="background-color: #FCE8E8;">question_names</td>
<td headers="severity" class="gt_row gt_left" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left" style="background-color: #FCE8E8;">required_indicator</td>
<td headers="list_name" class="gt_row gt_left" style="background-color: #FCE8E8;">NA</td>
<td headers="detail" class="gt_row gt_left" style="background-color: #FCE8E8;">Question 'required_indicator' is present in target but not in dev.</td></tr>
  </tbody>
  &#10;</table>
</div>

### `validate_list_names()`

Checks that every choice list *defined* in `target`’s choices sheet also
exists in `dev`’s choices sheet.

``` r
result_ln <- validate_list_names(target_with_issues, dev)
result_ln
#> # A tibble: 1 × 5
#>   check      severity name             list_name detail                         
#>   <chr>      <chr>    <chr>            <chr>     <chr>                          
#> 1 list_names error    l_required_scale <NA>      List 'l_required_scale' is def…
```

<div id="zdofjxurjs" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#zdofjxurjs table {
  font-family: 'IBM Plex Mono', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#zdofjxurjs thead, #zdofjxurjs tbody, #zdofjxurjs tfoot, #zdofjxurjs tr, #zdofjxurjs td, #zdofjxurjs th {
  border-style: none;
}
&#10;#zdofjxurjs p {
  margin: 0;
  padding: 0;
}
&#10;#zdofjxurjs .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #004D80;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #004D80;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#zdofjxurjs .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#zdofjxurjs .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#zdofjxurjs .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#zdofjxurjs .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#zdofjxurjs .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#zdofjxurjs .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#zdofjxurjs .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#zdofjxurjs .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#zdofjxurjs .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#zdofjxurjs .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#zdofjxurjs .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#zdofjxurjs .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#zdofjxurjs .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#zdofjxurjs .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: middle;
}
&#10;#zdofjxurjs .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#zdofjxurjs .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#zdofjxurjs .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: none;
  border-top-width: 1px;
  border-top-color: #89D3FE;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #89D3FE;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #89D3FE;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#zdofjxurjs .gt_stub {
  color: #FFFFFF;
  background-color: #0076BA;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #0076BA;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zdofjxurjs .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#zdofjxurjs .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#zdofjxurjs .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#zdofjxurjs .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zdofjxurjs .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #0076BA;
}
&#10;#zdofjxurjs .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#zdofjxurjs .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#zdofjxurjs .gt_grand_summary_row {
  color: #333333;
  background-color: #89D3FE;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zdofjxurjs .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #0076BA;
}
&#10;#zdofjxurjs .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #0076BA;
}
&#10;#zdofjxurjs .gt_striped {
  background-color: #F4F4F4;
}
&#10;#zdofjxurjs .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#zdofjxurjs .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#zdofjxurjs .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zdofjxurjs .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#zdofjxurjs .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zdofjxurjs .gt_left {
  text-align: left;
}
&#10;#zdofjxurjs .gt_center {
  text-align: center;
}
&#10;#zdofjxurjs .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#zdofjxurjs .gt_font_normal {
  font-weight: normal;
}
&#10;#zdofjxurjs .gt_font_bold {
  font-weight: bold;
}
&#10;#zdofjxurjs .gt_font_italic {
  font-style: italic;
}
&#10;#zdofjxurjs .gt_super {
  font-size: 65%;
}
&#10;#zdofjxurjs .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#zdofjxurjs .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#zdofjxurjs .gt_indent_1 {
  text-indent: 5px;
}
&#10;#zdofjxurjs .gt_indent_2 {
  text-indent: 10px;
}
&#10;#zdofjxurjs .gt_indent_3 {
  text-indent: 15px;
}
&#10;#zdofjxurjs .gt_indent_4 {
  text-indent: 20px;
}
&#10;#zdofjxurjs .gt_indent_5 {
  text-indent: 25px;
}
&#10;#zdofjxurjs .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#zdofjxurjs div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" style="table-layout:fixed;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <colgroup>
    <col/>
    <col/>
    <col/>
    <col/>
    <col style="width:340px;"/>
  </colgroup>
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal" style><span class='gt_from_md'><strong>Check: <code>list_names</code></strong></span></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Choice lists defined in target's choices but absent from dev's choices</td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="check">Check</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="severity">Severity</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="name">Name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="list_name">List</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="detail">Detail</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="check" class="gt_row gt_left" style="background-color: #FCE8E8;">list_names</td>
<td headers="severity" class="gt_row gt_left" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left" style="background-color: #FCE8E8;">l_required_scale</td>
<td headers="list_name" class="gt_row gt_left" style="background-color: #FCE8E8;">NA</td>
<td headers="detail" class="gt_row gt_left" style="background-color: #FCE8E8;">List 'l_required_scale' is defined in target's choices but not in dev's choices.</td></tr>
  </tbody>
  &#10;</table>
</div>

### `validate_survey_list_names()`

Checks that every choice list *referenced* in `target`’s survey
questions is also referenced in `dev`’s survey questions.

This is complementary to `validate_list_names()`: a list might be
defined in the choices sheet but never used — or, as in our example, a
question type changed from `text` to `select_one l_required_scale`
without a matching entry in dev’s survey.

``` r
result_sln <- validate_survey_list_names(target_with_issues, dev)
result_sln
#> # A tibble: 1 × 5
#>   check             severity name             list_name detail                  
#>   <chr>             <chr>    <chr>            <chr>     <chr>                   
#> 1 survey_list_names error    l_required_scale <NA>      List 'l_required_scale'…
```

<div id="ssvojvayta" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#ssvojvayta table {
  font-family: 'IBM Plex Mono', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#ssvojvayta thead, #ssvojvayta tbody, #ssvojvayta tfoot, #ssvojvayta tr, #ssvojvayta td, #ssvojvayta th {
  border-style: none;
}
&#10;#ssvojvayta p {
  margin: 0;
  padding: 0;
}
&#10;#ssvojvayta .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #004D80;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #004D80;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#ssvojvayta .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#ssvojvayta .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#ssvojvayta .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#ssvojvayta .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#ssvojvayta .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#ssvojvayta .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#ssvojvayta .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#ssvojvayta .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#ssvojvayta .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#ssvojvayta .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#ssvojvayta .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#ssvojvayta .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#ssvojvayta .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#ssvojvayta .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: middle;
}
&#10;#ssvojvayta .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#ssvojvayta .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#ssvojvayta .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: none;
  border-top-width: 1px;
  border-top-color: #89D3FE;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #89D3FE;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #89D3FE;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#ssvojvayta .gt_stub {
  color: #FFFFFF;
  background-color: #0076BA;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #0076BA;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#ssvojvayta .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#ssvojvayta .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#ssvojvayta .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#ssvojvayta .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#ssvojvayta .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #0076BA;
}
&#10;#ssvojvayta .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#ssvojvayta .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#ssvojvayta .gt_grand_summary_row {
  color: #333333;
  background-color: #89D3FE;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#ssvojvayta .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #0076BA;
}
&#10;#ssvojvayta .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #0076BA;
}
&#10;#ssvojvayta .gt_striped {
  background-color: #F4F4F4;
}
&#10;#ssvojvayta .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#ssvojvayta .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#ssvojvayta .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#ssvojvayta .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#ssvojvayta .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#ssvojvayta .gt_left {
  text-align: left;
}
&#10;#ssvojvayta .gt_center {
  text-align: center;
}
&#10;#ssvojvayta .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#ssvojvayta .gt_font_normal {
  font-weight: normal;
}
&#10;#ssvojvayta .gt_font_bold {
  font-weight: bold;
}
&#10;#ssvojvayta .gt_font_italic {
  font-style: italic;
}
&#10;#ssvojvayta .gt_super {
  font-size: 65%;
}
&#10;#ssvojvayta .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#ssvojvayta .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#ssvojvayta .gt_indent_1 {
  text-indent: 5px;
}
&#10;#ssvojvayta .gt_indent_2 {
  text-indent: 10px;
}
&#10;#ssvojvayta .gt_indent_3 {
  text-indent: 15px;
}
&#10;#ssvojvayta .gt_indent_4 {
  text-indent: 20px;
}
&#10;#ssvojvayta .gt_indent_5 {
  text-indent: 25px;
}
&#10;#ssvojvayta .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#ssvojvayta div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" style="table-layout:fixed;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <colgroup>
    <col/>
    <col/>
    <col/>
    <col/>
    <col style="width:340px;"/>
  </colgroup>
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal" style><span class='gt_from_md'><strong>Check: <code>survey_list_names</code></strong></span></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Lists referenced in target's survey but absent from dev's survey</td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="check">Check</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="severity">Severity</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="name">Name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="list_name">List</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="detail">Detail</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="check" class="gt_row gt_left" style="background-color: #FCE8E8;">survey_list_names</td>
<td headers="severity" class="gt_row gt_left" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left" style="background-color: #FCE8E8;">l_required_scale</td>
<td headers="list_name" class="gt_row gt_left" style="background-color: #FCE8E8;">NA</td>
<td headers="detail" class="gt_row gt_left" style="background-color: #FCE8E8;">List 'l_required_scale' is referenced in target's survey but not in dev's survey.</td></tr>
  </tbody>
  &#10;</table>
</div>

### `validate_choices()`

For every choice list present in *both* forms, checks that all options
in `target` also exist in `dev`.

Note: lists that exist only in `target` (caught by
`validate_list_names()`) are not reported here — this check focuses on
options within shared lists.

``` r
result_ch <- validate_choices(target_with_issues, dev)
result_ch
#> # A tibble: 1 × 5
#>   check   severity name             list_name detail                            
#>   <chr>   <chr>    <chr>            <chr>     <chr>                             
#> 1 choices error    mandatory_option l_yn      Choice 'mandatory_option' in list…
```

<div id="zqogdxjohj" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#zqogdxjohj table {
  font-family: 'IBM Plex Mono', system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#zqogdxjohj thead, #zqogdxjohj tbody, #zqogdxjohj tfoot, #zqogdxjohj tr, #zqogdxjohj td, #zqogdxjohj th {
  border-style: none;
}
&#10;#zqogdxjohj p {
  margin: 0;
  padding: 0;
}
&#10;#zqogdxjohj .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #004D80;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #004D80;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#zqogdxjohj .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#zqogdxjohj .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#zqogdxjohj .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#zqogdxjohj .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#zqogdxjohj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#zqogdxjohj .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#zqogdxjohj .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#zqogdxjohj .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#zqogdxjohj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#zqogdxjohj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#zqogdxjohj .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#zqogdxjohj .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#zqogdxjohj .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#zqogdxjohj .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
  vertical-align: middle;
}
&#10;#zqogdxjohj .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#zqogdxjohj .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#zqogdxjohj .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: none;
  border-top-width: 1px;
  border-top-color: #89D3FE;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #89D3FE;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #89D3FE;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#zqogdxjohj .gt_stub {
  color: #FFFFFF;
  background-color: #0076BA;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #0076BA;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zqogdxjohj .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#zqogdxjohj .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#zqogdxjohj .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#zqogdxjohj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zqogdxjohj .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #0076BA;
}
&#10;#zqogdxjohj .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#zqogdxjohj .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#zqogdxjohj .gt_grand_summary_row {
  color: #333333;
  background-color: #89D3FE;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zqogdxjohj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #0076BA;
}
&#10;#zqogdxjohj .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #0076BA;
}
&#10;#zqogdxjohj .gt_striped {
  background-color: #F4F4F4;
}
&#10;#zqogdxjohj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #0076BA;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #0076BA;
}
&#10;#zqogdxjohj .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#zqogdxjohj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zqogdxjohj .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#zqogdxjohj .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zqogdxjohj .gt_left {
  text-align: left;
}
&#10;#zqogdxjohj .gt_center {
  text-align: center;
}
&#10;#zqogdxjohj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#zqogdxjohj .gt_font_normal {
  font-weight: normal;
}
&#10;#zqogdxjohj .gt_font_bold {
  font-weight: bold;
}
&#10;#zqogdxjohj .gt_font_italic {
  font-style: italic;
}
&#10;#zqogdxjohj .gt_super {
  font-size: 65%;
}
&#10;#zqogdxjohj .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#zqogdxjohj .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#zqogdxjohj .gt_indent_1 {
  text-indent: 5px;
}
&#10;#zqogdxjohj .gt_indent_2 {
  text-indent: 10px;
}
&#10;#zqogdxjohj .gt_indent_3 {
  text-indent: 15px;
}
&#10;#zqogdxjohj .gt_indent_4 {
  text-indent: 20px;
}
&#10;#zqogdxjohj .gt_indent_5 {
  text-indent: 25px;
}
&#10;#zqogdxjohj .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#zqogdxjohj div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" style="table-layout:fixed;" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <colgroup>
    <col/>
    <col/>
    <col/>
    <col/>
    <col style="width:340px;"/>
  </colgroup>
  <thead>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_title gt_font_normal" style><span class='gt_from_md'><strong>Check: <code>choices</code></strong></span></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="5" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Choice options present in target but absent from dev, for shared lists</td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="check">Check</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="severity">Severity</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="name">Name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="list_name">List</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="font-weight: bold;" scope="col" id="detail">Detail</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="check" class="gt_row gt_left" style="background-color: #FCE8E8;">choices</td>
<td headers="severity" class="gt_row gt_left" style="background-color: #FCE8E8;">error</td>
<td headers="name" class="gt_row gt_left" style="background-color: #FCE8E8;">mandatory_option</td>
<td headers="list_name" class="gt_row gt_left" style="background-color: #FCE8E8;">l_yn</td>
<td headers="detail" class="gt_row gt_left" style="background-color: #FCE8E8;">Choice 'mandatory_option' in list 'l_yn' is present in target but not in dev.</td></tr>
  </tbody>
  &#10;</table>
</div>

------------------------------------------------------------------------

## Running a subset of checks

Pass a character vector to the `checks` argument to run only the checks
you need.

``` r
validate_xlsform(
  target_with_issues, dev,
  checks = c("question_names", "choices")
)
#> # A tibble: 2 × 5
#>   check          severity name               list_name detail                   
#>   <chr>          <chr>    <chr>              <chr>     <chr>                    
#> 1 question_names error    required_indicator <NA>      Question 'required_indic…
#> 2 choices        error    mandatory_option   l_yn      Choice 'mandatory_option…
```

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
