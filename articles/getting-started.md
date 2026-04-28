# Getting started with idem

``` r
library(idem)
```

## The bundled MSNA reference form

idem ships with `msna_template_required`: a pre-loaded `xlsform` object
containing the **required questions** from the MSNA template form. It is
the canonical reference against which mission-contextualized forms are
validated — you do not need to load the template separately.

``` r
msna_template_required
#> <xlsform> NA
#> • survey: 291 rows
#> • choices: 3714 rows
```

``` r
xlsform_questions(msna_template_required) |> head(10)
#>  [1] "audit"           "start"           "end"             "today"          
#>  [5] "deviceid"        "instance_name"   "introduction"    "survey_modality"
#>  [9] "enum_id"         "admin1"
```

To validate a mission form against it, pass `msna_template_required`
directly as `target`:

``` r
dev <- read_xlsform("path/to/mission_form.xlsx")
issues <- validate_xlsform(target = msna_template_required, dev = dev)
issues
```

Any row in the output flags content that the mission form is missing
relative to the MSNA standard. An empty tibble means the form is fully
compliant.

The dataset is versioned alongside the package —
`attr(msna_template_required, "version")` records which release it was
generated from, so results are always reproducible and traceable to a
specific snapshot of the template.

We use `msna_template_required` as `target` throughout this article. The
form to validate is loaded from the package’s example file:

``` r
path <- system.file("extdata/form.xlsx", package = "idem")
target <- msna_template_required
dev <- read_xlsform(path)
```

------------------------------------------------------------------------

## Exploring a form

Before running validation, the extractor functions let you inspect the
contents of any form.

### Question names

``` r
xlsform_questions(target) |> head(15)
#>  [1] "audit"           "start"           "end"             "today"          
#>  [5] "deviceid"        "instance_name"   "introduction"    "survey_modality"
#>  [9] "enum_id"         "admin1"          "admin2"          "admin3"         
#> [13] "consent"         "consent_no_note" "intro_hh"
```

### Choice lists referenced in the survey

These are the list names extracted from the `type` column — the second
token in values like `select_one l_yn`.

``` r
xlsform_referenced_list_names(target)
#>  [1] "l_survey_modality"                          
#>  [2] "l_enum_id"                                  
#>  [3] "l_admin1"                                   
#>  [4] "l_admin2"                                   
#>  [5] "l_admin3"                                   
#>  [6] "l_yn"                                       
#>  [7] "l_gender"                                   
#>  [8] "l_setting"                                  
#>  [9] "l_ind_age_under1"                           
#> [10] "l_dis_forced"                               
#> [11] "l_dis_area_origin"                          
#> [12] "l_dis_reasons"                              
#> [13] "l_cpa_preferred_modality"                   
#> [14] "l_priority_support_ngo"                     
#> [15] "l_yn_dnk_pnta"                              
#> [16] "l_aap_received_assistance_type"             
#> [17] "l_aap_relevance_assistance"                 
#> [18] "l_aap_relevance_assistance_reason"          
#> [19] "l_aap_satisfaction_assistance"              
#> [20] "l_aap_assistance_improves_living_conditions"
#> [21] "l_aap_assistance_improves_living_challenges"
#> [22] "l_edu_level_grade"                          
#> [23] "l_edu_barrier"                              
#> [24] "l_snfi_shelter_type"                        
#> [25] "l_snfi_shelter_type_individual"             
#> [26] "l_snfi_shelter_damage"                      
#> [27] "l_snfi_shelter_issue"                       
#> [28] "l_snfi_fds_cooking"                         
#> [29] "l_snfi_fds_cooking_issue"                   
#> [30] "l_snfi_fds"                                 
#> [31] "l_snfi_fds_sleeping_issue"                  
#> [32] "l_snfi_fds_storing_issue"                   
#> [33] "l_snfi_essential_items_missing"             
#> [34] "l_energy_lighting_source"                   
#> [35] "l_hlp_occupancy"                            
#> [36] "l_hlp_threat_eviction"                      
#> [37] "l_wash_drinking_water_source"               
#> [38] "l_wash_drinking_water_time_yn"              
#> [39] "l_wash_drinking_water_time_sl"              
#> [40] "l_wash_hwise"                               
#> [41] "l_wash_sanitation_facility"                 
#> [42] "l_wash_handwashing_facility"                
#> [43] "l_wash_handwashing_facility_observed_water" 
#> [44] "l_wash_handwashing_facility_reported"       
#> [45] "l_wash_soap_observed"                       
#> [46] "l_wash_soap_type"                           
#> [47] "l_fsl_hhs"                                  
#> [48] "l_fsl_lcsi"                                 
#> [49] "l_fsl_lcsi_other"                           
#> [50] "l_fsl_lcsi_en_other"                        
#> [51] "l_cm_expenditure_frequent"                  
#> [52] "l_cm_expenditure_infrequent"                
#> [53] "l_nut_ind_under5_sick_symptoms"             
#> [54] "l_prot_needs_1_services"                    
#> [55] "l_prot_needs_1_justice"                     
#> [56] "l_prot_needs_2_activities"                  
#> [57] "l_prot_needs_2_social"                      
#> [58] "l_prot_needs_3_movement"                    
#> [59] "l_prot_perceived_gbv"                       
#> [60] "l_prot_concern_freq_gbv_areas_type"         
#> [61] "l_prot_concern_impact"                      
#> [62] "l_prot_child_labour"                        
#> [63] "l_ch_pr_behaviour_change"                   
#> [64] "l_ds_plans"                                 
#> [65] "l_ds_plans_timeline"
```

### Choice lists defined in the choices sheet

``` r
xlsform_defined_list_names(target)
#>   [1] "l_survey_modality"                           
#>   [2] "l_enum_id"                                   
#>   [3] "l_gender"                                    
#>   [4] "l_admin3"                                    
#>   [5] "l_admin4"                                    
#>   [6] "l_cluster_id"                                
#>   [7] "l_yn"                                        
#>   [8] "l_yn_dnk_pnta"                               
#>   [9] "l_hoh_civil_status"                          
#>  [10] "l_setting"                                   
#>  [11] "l_ind_age_under1"                            
#>  [12] "l_edu_level_grade"                           
#>  [13] "l_edu_barrier"                               
#>  [14] "l_fsl_hhs"                                   
#>  [15] "l_fsl_source_food"                           
#>  [16] "l_fsl_lcsi"                                  
#>  [17] "l_fsl_lcsi_other"                            
#>  [18] "Pour acheter de la nourriture"               
#>  [19] "l_fsl_lcsi_en_other"                         
#>  [20] "l_cm_income_source"                          
#>  [21] "cm_income_sources_reduced_1"                 
#>  [22] "cm_income_sources_reduced_2"                 
#>  [23] "l_nut_ind_under5_sick_symptoms"              
#>  [24] "l_nut_ind_under5_sick_location"              
#>  [25] "l_aap_received_assistance_date"              
#>  [26] "l_aap_received_assistance_type"              
#>  [27] "l_snfi_shelter_type"                         
#>  [28] "l_snfi_shelter_type_collective"              
#>  [29] "l_snfi_shelter_type_individual"              
#>  [30] "l_snfi_shelter_damage"                       
#>  [31] "l_snfi_shelter_damage_when"                  
#>  [32] "l_snfi_shelter_damage_cause"                 
#>  [33] "l_snfi_shelter_damage_barriers_repairs"      
#>  [34] "l_snfi_shelter_issue"                        
#>  [35] "l_snfi_fds_cooking"                          
#>  [36] "l_snfi_fds_cooking_issue"                    
#>  [37] "l_snfi_fds"                                  
#>  [38] "l_snfi_fds_sleeping_issue"                   
#>  [39] "l_snfi_fds_storing_issue"                    
#>  [40] "l_snfi_essential_items_missing"              
#>  [41] "l_hlp_threat_eviction"                       
#>  [42] "l_wash_drinking_water_source"                
#>  [43] "l_wash_drinking_water_time_yn"               
#>  [44] "l_wash_drinking_water_time_sl"               
#>  [45] "l_wash_hwise"                                
#>  [46] "l_wash_sanitation_facility"                  
#>  [47] "l_wash_handwashing_facility"                 
#>  [48] "l_wash_handwashing_facility_observed_water"  
#>  [49] "l_wash_soap_observed"                        
#>  [50] "l_wash_handwashing_facility_reported"        
#>  [51] "l_wash_soap_type"                            
#>  [52] "l_health_ind_healthcare_needed_type"         
#>  [53] "l_prot_perceived_risk"                       
#>  [54] "l_prot_perceived_gbv"                        
#>  [55] "l_energy_lighting_source"                    
#>  [56] "l_hlp_occupancy"                             
#>  [57] "l_prot_child_sep_reason"                     
#>  [58] "l_prot_needs_1_services"                     
#>  [59] "l_prot_needs_1_justice"                      
#>  [60] "l_prot_needs_2_activities"                   
#>  [61] "l_prot_needs_2_social"                       
#>  [62] "l_prot_needs_3_movement"                     
#>  [63] "l_cm_expenditure_frequent"                   
#>  [64] "l_cm_expenditure_infrequent"                 
#>  [65] "l_prot_concern_freq_gbv_areas_type"          
#>  [66] "l_prot_concern_impact"                       
#>  [67] "l_prot_child_labour"                         
#>  [68] "l_ch_pr_behaviour_change"                    
#>  [69] "l_admin1"                                    
#>  [70] "l_admin2"                                    
#>  [71] "l_cpa_preferred_modality"                    
#>  [72] "l_priority_support_ngo"                      
#>  [73] "l_aap_relevance_assistance"                  
#>  [74] "l_aap_relevance_assistance_reason"           
#>  [75] "l_aap_satisfaction_assistance"               
#>  [76] "l_aap_assistance_improves_living_conditions" 
#>  [77] "l_aap_assistance_improves_living_challenges" 
#>  [78] "l_cm_market_time"                            
#>  [79] "l_cm_market_barriers_access"                 
#>  [80] "l_cm_market_barriers_purchase"               
#>  [81] "l_dis_forced"                                
#>  [82] "l_dis_area_origin"                           
#>  [83] "l_dis_reasons"                               
#>  [84] "l_ds_plans"                                  
#>  [85] "l_ds_plans_timeline"                         
#>  [86] "l_dis_secondary_n"                           
#>  [87] "l_wgss_difficulty"                           
#>  [88] "l_participation_yes_no"                      
#>  [89] "fsl_livestock_change"                        
#>  [90] "fsl_liv_act"                                 
#>  [91] "fsl_crop_type"                               
#>  [92] "fsl_crop_area_change"                        
#>  [93] "fsl_crop_diff"                               
#>  [94] "fsl_crop_harv_change"                        
#>  [95] "fsl_livestock_type"                          
#>  [96] "fsl_livestock_diff"                          
#>  [97] "fsl_food_storing"                            
#>  [98] "l_edu_other_yn"                              
#>  [99] "l_edu_community_modality"                    
#> [100] "l_edu_financial_barrier"                     
#> [101] "l_prot_needs_threats"                        
#> [102] "l_prot_needs_populations"                    
#> [103] "l_prot_children_reasons"                     
#> [104] "l_id_yn"                                     
#> [105] "l_prot_id_missing_reason"                    
#> [106] "l_prot_legal_yn"                             
#> [107] "l_prot_legal_barriers"                       
#> [108] "l_prot_adult_sep_reason"                     
#> [109] "l_prot_mines"                                
#> [110] "l_prot_services_availability"                
#> [111] "l_cpa_priority_support_cash"                 
#> [112] "l_aap_satisfaction_challenges"               
#> [113] "l_satisfaction"                              
#> [114] "l_aap_satisfaction_workers_behaviour_reason" 
#> [115] "l_aap_consultation_assistance_opinions"      
#> [116] "l_aap_preferred_means_feedback"              
#> [117] "l_aap_cfm_use"                               
#> [118] "l_aap_information_needs"                     
#> [119] "l_aap_preferred_source_info"                 
#> [120] "l_aap_received_channel_info_aid"             
#> [121] "l_hesper"                                    
#> [122] "l_dis_challenges"                            
#> [123] "l_responsible_chore"                         
#> [124] "l_serious_problem"                           
#> [125] "l_wash_drinking_water_quantity"              
#> [126] "l_wash_drinking_water_acceptable"            
#> [127] "l_wash_water_access_issue"                   
#> [128] "l_wash_person_fetch"                         
#> [129] "l_wash_piped_supply"                         
#> [130] "l_wash_water_availability_yn"                
#> [131] "l_wash_water_availability_issue"             
#> [132] "l_wash_drinking_water_supplied_hours"        
#> [133] "l_wash_drinking_water_store_insufficient_yn" 
#> [134] "l_wash_drinking_water_store_small_containers"
#> [135] "l_wash_drinking_water_treatment"             
#> [136] "l_wash_sanitation_sharing_public"            
#> [137] "l_wash_sanitation_access_features"           
#> [138] "l_wash_sanitation_facility_location"         
#> [139] "l_wash_sanitation_use_toilet_reason"         
#> [140] "l_wash_sanitation_toilet_risks"              
#> [141] "l_wash_sanitation_access_issue"              
#> [142] "l_wash_sanitation_emptied_yn"                
#> [143] "l_wash_sanitation_emptied_where"             
#> [144] "l_wash_sanitation_outlet_pipe"               
#> [145] "l_wash_sanitation_facility_leak"             
#> [146] "l_wash_sanitation_septic_discharge"          
#> [147] "l_wash_sanitation_emptied_who"               
#> [148] "l_wash_sanitation_excreta_released"          
#> [149] "l_wash_sanitation_adaptation"                
#> [150] "l_wash_sanitation_environment"               
#> [151] "l_wash_sanitation_dispose_garbage"           
#> [152] "l_wash_sanitation_dispose_water"             
#> [153] "l_wash_hygiene_menstrual_materials"          
#> [154] "l_wash_hygiene_menstrual_missed_activities"  
#> [155] "l_wash_hygiene_menstrual_issue"              
#> [156] "l_wash_hygiene_menstrual_preferred"          
#> [157] "l_wash_hygiene_menstrual_place"              
#> [158] "l_wash_hygiene_adaptation"                   
#> [159] "l_wash_hygiene_nfi"                          
#> [160] "l_wash_bathing_facility_issue"               
#> [161] "l_sanqol"                                    
#> [162] "l_wash_water_adaptation"                     
#> [163] "l_wash_chl_info_src"                         
#> [164] "l_wash_chl_actions_sick"                     
#> [165] "l_wash_chl_origin"                           
#> [166] "l_wash_chl_transmission"                     
#> [167] "l_wash_chl_health_actions"                   
#> [168] "l_wash_chl_health_practices"                 
#> [169] "l_wash_chl_ors_preparation"                  
#> [170] "l_wash_sanitation_outlet_pipe_where"         
#> [171] "l_health_ind_healthcare_received_location"   
#> [172] "l_health_barriers"                           
#> [173] "l_hazard_env_type"                           
#> [174] "l_hazard_sp_type"
```

### Choice options per list

``` r
xlsform_choices(target)[["l_yn"]]
#> [1] "yes" "no"
```

------------------------------------------------------------------------

## Validating forms

### The clean case — no issues

A form is always a valid subset of itself. Running
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
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
dev_extra_q <- target$survey[1L, ]
dev_extra_q$name <- "dev_only_question"
dev_with_extra_q <- xlsform(
  survey  = rbind(target$survey, dev_extra_q),
  choices = target$choices
)
# 0 issues — target is a valid subset of dev
validate_question_names(target, dev_with_extra_q)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# dev defines an extra choice list that target doesn't use — passes
l_yn <- target$choices$list_name == "l_yn" & !is.na(target$choices$list_name)
dev_extra_list <- target$choices[l_yn, ]
dev_extra_list$list_name <- "l_dev_only"
dev_with_extra_list <- xlsform(
  survey  = target$survey,
  choices = rbind(target$choices, dev_extra_list)
)
# 0 issues — target need not use every list in dev
validate_list_names(target, dev_with_extra_list)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# dev references an extra list in its survey that target doesn't — passes
dev_survey_extra <- target$survey
dev_survey_extra$type[dev_survey_extra$type == "text"][1L] <-
  "select_one l_dev_only"
dev_with_extra_ref <- xlsform(
  survey  = dev_survey_extra,
  choices = rbind(target$choices, dev_extra_list)
)
# 0 issues — target simply doesn't use that list
validate_survey_list_names(target, dev_with_extra_ref)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>

# dev has an extra choice option in a shared list that target doesn't — passes
dev_extra_opt <- target$choices[l_yn, ][1L, ]
dev_extra_opt$name <- "not_applicable"
dev_with_extra_opt <- xlsform(
  survey  = target$survey,
  choices = rbind(target$choices, dev_extra_opt)
)
# 0 issues — target uses a subset of available options
validate_choices(target, dev_with_extra_opt)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>
```

### Building a target form with issues

In practice you load both forms from disk:

``` r
target <- read_xlsform("path/to/target.xlsx")
dev    <- read_xlsform("path/to/dev.xlsx")
```

For this article we construct a `target` that has content `dev` is
missing, introducing one example of each issue type.

``` r
# 1. target requires a question dev doesn't have
extra_q <- target$survey[1L, ]
extra_q$name <- "required_indicator"
target_survey <- rbind(target$survey, extra_q)

# 2. target requires a choice option dev is missing (in the 'l_yn' list)
l_yn <- target$choices$list_name == "l_yn" & !is.na(target$choices$list_name)
extra_opt <- target$choices[l_yn, ][1L, ]
extra_opt$name <- "mandatory_option"

# 3. target defines a choice list that dev's choices sheet doesn't have
new_list <- target$choices[l_yn, ][1:2, ]
new_list$list_name <- "l_required_scale"
new_list$name <- c("low", "high")

target_choices <- rbind(target$choices, extra_opt, new_list)

# 4. target references a list in its survey that dev's survey doesn't have
target_survey$type[target_survey$type == "text"][1L] <-
  "select_one l_required_scale"

# Build a dev form that is the original (without the additions above)
dev <- xlsform(survey = target$survey, choices = target$choices)

# Re-assign target with all the additions
target_with_issues <- xlsform(survey = target_survey, choices = target_choices)
```

### Running all checks at once

[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
runs every check and returns a combined tibble.

``` r
issues <- validate_xlsform(target_with_issues, dev)
knitr::kable(issues)
```

| check             | severity | name               | list_name | detail                                                                            |
|:------------------|:---------|:-------------------|:----------|:----------------------------------------------------------------------------------|
| question_names    | error    | required_indicator | NA        | Question ‘required_indicator’ is present in target but not in dev.                |
| list_names        | error    | l_required_scale   | NA        | List ‘l_required_scale’ is defined in target’s choices but not in dev’s choices.  |
| survey_list_names | error    | l_required_scale   | NA        | List ‘l_required_scale’ is referenced in target’s survey but not in dev’s survey. |
| choices           | error    | mandatory_option   | l_yn      | Choice ‘mandatory_option’ in list ‘l_yn’ is present in target but not in dev.     |

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

| check          | severity | name               | list_name | detail                                                             |
|:---------------|:---------|:-------------------|:----------|:-------------------------------------------------------------------|
| question_names | error    | required_indicator | NA        | Question ‘required_indicator’ is present in target but not in dev. |

### `validate_list_names()`

Checks that every choice list *defined* in `target`’s choices sheet also
exists in `dev`’s choices sheet.

``` r
result_ln <- validate_list_names(target_with_issues, dev)
knitr::kable(result_ln)
```

| check      | severity | name             | list_name | detail                                                                           |
|:-----------|:---------|:-----------------|:----------|:---------------------------------------------------------------------------------|
| list_names | error    | l_required_scale | NA        | List ‘l_required_scale’ is defined in target’s choices but not in dev’s choices. |

### `validate_survey_list_names()`

Checks that every choice list *referenced* in `target`’s survey
questions is also referenced in `dev`’s survey questions.

This is complementary to
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md):
a list might be defined in the choices sheet but never used — or, as in
our example, a question type changed from `text` to
`select_one l_required_scale` without a matching entry in dev’s survey.

``` r
result_sln <- validate_survey_list_names(target_with_issues, dev)
knitr::kable(result_sln)
```

| check             | severity | name             | list_name | detail                                                                            |
|:------------------|:---------|:-----------------|:----------|:----------------------------------------------------------------------------------|
| survey_list_names | error    | l_required_scale | NA        | List ‘l_required_scale’ is referenced in target’s survey but not in dev’s survey. |

### `validate_choices()`

For every choice list present in *both* forms, checks that all options
in `target` also exist in `dev`.

Note: lists that exist only in `target` (caught by
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md))
are not reported here — this check focuses on options within shared
lists.

``` r
result_ch <- validate_choices(target_with_issues, dev)
knitr::kable(result_ch)
```

| check   | severity | name             | list_name | detail                                                                        |
|:--------|:---------|:-----------------|:----------|:------------------------------------------------------------------------------|
| choices | error    | mandatory_option | l_yn      | Choice ‘mandatory_option’ in list ‘l_yn’ is present in target but not in dev. |

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

| check          | severity | name               | list_name | detail                                                                        |
|:---------------|:---------|:-------------------|:----------|:------------------------------------------------------------------------------|
| question_names | error    | required_indicator | NA        | Question ‘required_indicator’ is present in target but not in dev.            |
| choices        | error    | mandatory_option   | l_yn      | Choice ‘mandatory_option’ in list ‘l_yn’ is present in target but not in dev. |

------------------------------------------------------------------------

## Skipping lists with `passing_lists`

Some choice lists — admin boundaries, enumerator IDs, country lists —
are expected to differ between a target and a dev form and should not be
flagged.
[`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
and
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
accept a `passing_lists` argument for this purpose. The default is
`idem_passing_lists`, a character vector you can inspect directly:

``` r
idem_passing_lists
#> [1] "l_admin1"     "l_admin2"     "l_admin3"     "l_admin4"     "l_cluster_id"
#> [6] "l_country"    "l_enum_id"
```

Any list named in `passing_lists` is excluded from the options
comparison. To extend the default with a project-specific list, pass a
combined vector:

``` r
validate_choices(
  target, dev,
  passing_lists = c(idem_passing_lists, "l_my_project_list")
)
#> # A tibble: 0 × 5
#> # ℹ 5 variables: check <chr>, severity <chr>, name <chr>, list_name <chr>,
#> #   detail <chr>
```

To disable all bypasses and force the comparison between every shared
list, pass `character(0)`:

``` r
validate_choices(target, dev, passing_lists = character(0))
```

The same argument is available on
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
and is forwarded to the `choices` check automatically.

------------------------------------------------------------------------

## Working with results

Because
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)
returns a plain tibble, standard data manipulation works directly on the
output.

``` r
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
