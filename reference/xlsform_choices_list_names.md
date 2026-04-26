# Get list names defined in the choices sheets of an XLSForm

Extracts unique list names from the `list_name` column of all available
in-workbook choices sheets. Two sheets are recognised:

## Usage

``` r
xlsform_choices_list_names(x, ...)

# Default S3 method
xlsform_choices_list_names(x, ...)

# S3 method for class 'xlsform'
xlsform_choices_list_names(x, ...)
```

## Arguments

- x:

  An `xlsform` object.

- ...:

  Ignored; present for S3 method compatibility.

## Value

A character vector of unique list names drawn from all available
in-workbook choices sheets.

## Details

- `choices` — the standard sheet used by `select_one`,
  `select_multiple`, and `rank`.

- `external_choices` — the optional sheet used by `select_one_external`
  and `select_multiple_external`. Included automatically when present in
  the loaded form.

### Note on file-based question types

`select_one_from_file` and `select_multiple_from_file` reference
external CSV/XML/GeoJSON files rather than any in-workbook sheet. This
function cannot resolve those references and emits a warning for each
such type it encounters.

### Difference from [`xlsform_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_list_names.md)

[`xlsform_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_list_names.md)
returns lists *referenced* by survey questions;
`xlsform_choices_list_names()` returns lists *defined* in the choices
sheets. The two sets should match for a well-formed form, but can
diverge when a question type is changed without updating the choices
sheet (or vice versa).

## See also

[`xlsform_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_list_names.md)
for list names referenced in the survey sheet;
[`xlsform_choices()`](https://impact-initiatives.github.io/idem/reference/xlsform_choices.md)
for the full choice options per list;
[`validate_list_names()`](https://impact-initiatives.github.io/idem/reference/validate_list_names.md)
to compare defined lists across two forms.

## Examples

``` r
form <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))

# All list names defined in the choices sheet
xlsform_choices_list_names(form)
#>   [1] "l_survey_modality"                           
#>   [2] "l_enum_id"                                   
#>   [3] "l_gender"                                    
#>   [4] "l_country"                                   
#>   [5] "l_admin3"                                    
#>   [6] "l_admin4"                                    
#>   [7] "l_cluster_id"                                
#>   [8] "l_yn"                                        
#>   [9] "l_yn_dnk_pnta"                               
#>  [10] "l_hoh_civil_status"                          
#>  [11] "l_setting"                                   
#>  [12] "l_ind_age_under1"                            
#>  [13] "l_edu_level_grade"                           
#>  [14] "l_edu_barrier"                               
#>  [15] "l_fsl_hhs"                                   
#>  [16] "l_fsl_source_food"                           
#>  [17] "l_fsl_lcsi"                                  
#>  [18] "l_fsl_lcsi_other"                            
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

# Cross-check: lists defined in choices vs. lists used in survey
# (both should be identical for a well-formed form)
all.equal(
  sort(xlsform_choices_list_names(form)),
  sort(xlsform_list_names(form))
)
#> [1] "Lengths (174, 171) differ (string compare on first 171)"
#> [2] "137 string mismatches"                                  
```
