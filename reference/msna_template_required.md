# MSNA template XLSForm (required questions)

An `xlsform` object containing the required questions from the
Multi-Sector Needs Assessment (MSNA) template form. This dataset serves
as the reference (development) form against which collected XLSForms can
be validated with
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md).

## Usage

``` r
msna_template_required
```

## Format

An `xlsform` object — a named list of two tibbles with class
`c("xlsform", "list")`:

**`survey`** — 236 rows × 17 columns:

- type:

  XLSForm question type (e.g. `"select_one"`, `"integer"`).

- name:

  Variable name.

- `label::english (en)`:

  Question label in English.

- `label::french (fr)`:

  Question label in French.

- `hint::english (en)`:

  Enumerator hint in English.

- `hint::french (fr)`:

  Enumerator hint in French.

- calculation:

  XLSForm calculation expression.

- required:

  Whether the question is required (`TRUE`/`FALSE`/`NA`).

- relevant:

  XLSForm relevance expression.

- constraint:

  XLSForm constraint expression.

- default:

  Default value.

- repeat_count:

  Repeat count expression for repeat groups.

- `constraint_message::english (en)`:

  Constraint violation message in English.

- `constraint_message::french (fr)`:

  Constraint violation message in French.

- appearance:

  XLSForm appearance attribute.

- choice_filter:

  Choice filter expression.

- parameters:

  Additional XLSForm parameters.

**`choices`** — 3,726 rows × 8 columns:

- list_name:

  Choice list identifier referenced in `survey$type`.

- name:

  Choice option value.

- `label::english (en)`:

  Choice label in English.

- `label::french (fr)`:

  Choice label in French.

- parent_country:

  Country-level cascade filter value.

- parent_admin1:

  Admin1-level cascade filter value.

- parent_admin2:

  Admin2-level cascade filter value.

- parent_admin3:

  Admin3-level cascade filter value.

## Source

Derived from the MSNA template XLSForm bundled in
`inst/extdata/form.xlsx`. Regenerate with
`data-raw/msna_template_required.R`.

## Versioning

The dataset carries a `version` attribute recording the package version
under which it was generated. Inspect it with:

    attr(msna_template_required, "version")

The dataset is updated in lockstep with package releases, so the version
attribute ties each snapshot of the reference form to a specific
release.

## See also

[`read_xlsform()`](https://impact-initiatives.github.io/idem/reference/read_xlsform.md),
[`validate_xlsform()`](https://impact-initiatives.github.io/idem/reference/validate_xlsform.md)

## Examples

``` r
msna_template_required
#> <xlsform> NA
#> • survey: 236 rows
#> • choices: 3726 rows

xlsform_questions(msna_template_required)
#>   [1] "audit"                                                     
#>   [2] "start"                                                     
#>   [3] "end"                                                       
#>   [4] "today"                                                     
#>   [5] "deviceid"                                                  
#>   [6] "instance_name"                                             
#>   [7] "introduction"                                              
#>   [8] "survey_modality"                                           
#>   [9] "enum_id"                                                   
#>  [10] "admin1"                                                    
#>  [11] "admin2"                                                    
#>  [12] "admin3"                                                    
#>  [13] "consent"                                                   
#>  [14] "consent_no_note"                                           
#>  [15] "intro_hh"                                                  
#>  [16] "introduction"                                              
#>  [17] "consented"                                                 
#>  [18] "demographics"                                              
#>  [19] "resp_gender"                                               
#>  [20] "resp_age"                                                  
#>  [21] "resp_hoh_yn"                                               
#>  [22] "hoh_gender"                                                
#>  [23] "hoh_age"                                                   
#>  [24] "setting"                                                   
#>  [25] "hh_size"                                                   
#>  [26] "repeat_intro_hh"                                           
#>  [27] "roster"                                                    
#>  [28] "parent_instance_name"                                      
#>  [29] "person_id"                                                 
#>  [30] "ind_pos"                                                   
#>  [31] "ind_name"                                                  
#>  [32] "ind_gender"                                                
#>  [33] "ind_age"                                                   
#>  [34] "ind_age_under1"                                            
#>  [35] "ind_under5_date_know"                                      
#>  [36] "ind_under5_date"                                           
#>  [37] "ind_under5_event"                                          
#>  [38] "ind_dob_final"                                             
#>  [39] "ind_under5_age_months"                                     
#>  [40] "ind_under5_age_years"                                      
#>  [41] "note_child_age_under5"                                     
#>  [42] "check_age_under5"                                          
#>  [43] "note_child_age_under5_mismatch"                            
#>  [44] "ind_age_2_11"                                              
#>  [45] "ind_f"                                                     
#>  [46] "ind_age_5_17"                                              
#>  [47] "ind_m_age_5_17"                                            
#>  [48] "ind_f_age_5_17"                                            
#>  [49] "ind_age_0_1"                                               
#>  [50] "ind_age_0_4"                                               
#>  [51] "ind_age_0_5"                                               
#>  [52] "ind_f_age_above18"                                         
#>  [53] "ind_m_age_above18"                                         
#>  [54] "ind_woman_repr_age"                                        
#>  [55] "ind_age_schooling"                                         
#>  [56] "roster"                                                    
#>  [57] "ind_age_2_11_n"                                            
#>  [58] "ind_f_n"                                                   
#>  [59] "ind_age_5_17_n"                                            
#>  [60] "ind_m_age_5_17_n"                                          
#>  [61] "ind_f_age_5_17_n"                                          
#>  [62] "ind_age_0_1_n"                                             
#>  [63] "ind_age_0_4_n"                                             
#>  [64] "ind_age_0_5_n"                                             
#>  [65] "ind_f_age_above18_n"                                       
#>  [66] "ind_m_age_above18_n"                                       
#>  [67] "ind_age_schooling_n"                                       
#>  [68] "ind_women_repr_age_n"                                      
#>  [69] "demographics"                                              
#>  [70] "displacement"                                              
#>  [71] "note_dis_hh"                                               
#>  [72] "dis_forced"                                                
#>  [73] "dis_area_origin"                                           
#>  [74] "dis_reasons"                                               
#>  [75] "other_dis_reasons"                                         
#>  [76] "displacement"                                              
#>  [77] "aap"                                                       
#>  [78] "cpa_priority_challenge_note"                               
#>  [79] "cpa_preferred_modality_1"                                  
#>  [80] "other_cpa_preferred_modality_1"                            
#>  [81] "cpa_priority_support_ngo_1"                                
#>  [82] "other_cpa_priority_support_ngo_1"                          
#>  [83] "cpa_preferred_modality_2"                                  
#>  [84] "other_cpa_preferred_modality_2"                            
#>  [85] "cpa_priority_support_ngo_2"                                
#>  [86] "other_cpa_priority_support_ngo_2"                          
#>  [87] "aap_received_assistance_12m"                               
#>  [88] "aap_received_assistance_type"                              
#>  [89] "other_aap_received_assistance_type"                        
#>  [90] "aap_relevance_assistance"                                  
#>  [91] "aap_relevance_assistance_reason"                           
#>  [92] "other_aap_relevance_assistance_reason"                     
#>  [93] "aap_satisfaction_assistance"                               
#>  [94] "aap_assistance_improves_living_conditions"                 
#>  [95] "other_aap_assistance_improves_living_conditions"           
#>  [96] "aap_assistance_improves_living_conditions_challenges"      
#>  [97] "other_aap_assistance_improves_living_conditions_challenges"
#>  [98] "aap_assistance_coverage"                                   
#>  [99] "aap"                                                       
#> [100] "edu_ind_pos"                                               
#> [101] "edu_ind_age_schooling"                                     
#> [102] "edu_ind_name"                                              
#> [103] "edu_access"                                                
#> [104] "edu_level_grade"                                           
#> [105] "edu_disrupted_hazards"                                     
#> [106] "edu_disrupted_teacher"                                     
#> [107] "edu_disrupted_displaced"                                   
#> [108] "edu_disrupted_attack"                                      
#> [109] "edu_barrier"                                               
#> [110] "other_edu_barrier"                                         
#> [111] "snfi_shelter_type"                                         
#> [112] "snfi_shelter_type_individual"                              
#> [113] "other_snfi_shelter_type_individual"                        
#> [114] "snfi_shelter_damage"                                       
#> [115] "snfi_shelter_issue"                                        
#> [116] "other_snfi_shelter_issue"                                  
#> [117] "snfi_fds_cooking"                                          
#> [118] "snfi_fds_cooking_issue"                                    
#> [119] "other_snfi_fds_cooking_issue"                              
#> [120] "snfi_fds_sleeping"                                         
#> [121] "snfi_fds_sleeping_issue"                                   
#> [122] "other_snfi_fds_sleeping_issue"                             
#> [123] "snfi_fds_storing"                                          
#> [124] "snfi_fds_storing_issue"                                    
#> [125] "other_snfi_fds_storing_issue"                              
#> [126] "snfi_essential_items_missing"                              
#> [127] "other_snfi_essential_items_missing"                        
#> [128] "energy_lighting_source"                                    
#> [129] "other_energy_lighting_source"                              
#> [130] "hlp_occupancy"                                             
#> [131] "other_hlp_occupancy"                                       
#> [132] "hlp_risk_eviction"                                         
#> [133] "hlp_threat_eviction"                                       
#> [134] "wash_drinking_water_source"                                
#> [135] "other_wash_drinking_water_source"                          
#> [136] "wash_drinking_water_time_yn"                               
#> [137] "wash_drinking_water_time_int"                              
#> [138] "wash_drinking_water_time_sl"                               
#> [139] "wash_hwise_drink"                                          
#> [140] "wash_hwise_hands"                                          
#> [141] "wash_hwise_worry"                                          
#> [142] "wash_hwise_plans"                                          
#> [143] "wash_sanitation_facility"                                  
#> [144] "other_wash_sanitation_facility"                            
#> [145] "wash_sanitation_facility_sharing_yn"                       
#> [146] "wash_sanitation_facility_sharing_n"                        
#> [147] "wash_handwashing_facility"                                 
#> [148] "other_wash_handwashing_facility"                           
#> [149] "wash_handwashing_facility_observed_water_yn"               
#> [150] "wash_handwashing_facility_reported"                        
#> [151] "other_wash_handwashing_facility_reported"                  
#> [152] "wash_handwashing_facility_water_reported_yn"               
#> [153] "wash_soap_observed_yn"                                     
#> [154] "wash_soap_observed_type"                                   
#> [155] "other_wash_soap_observed_type"                             
#> [156] "wash_soap_reported_yn"                                     
#> [157] "wash_soap_reported_type"                                   
#> [158] "other_wash_soap_reported_type"                             
#> [159] "fsl_fcs_cereal"                                            
#> [160] "fsl_fcs_legumes"                                           
#> [161] "fsl_fcs_dairy"                                             
#> [162] "fsl_fcs_meat"                                              
#> [163] "fsl_fcs_veg"                                               
#> [164] "fsl_fcs_fruit"                                             
#> [165] "fsl_fcs_oil"                                               
#> [166] "fsl_fcs_sugar"                                             
#> [167] "fsl_fcs_condiments"                                        
#> [168] "fsl_rcsi_lessquality"                                      
#> [169] "fsl_rcsi_borrow"                                           
#> [170] "fsl_rcsi_mealsize"                                         
#> [171] "fsl_rcsi_mealadult"                                        
#> [172] "fsl_rcsi_mealnb"                                           
#> [173] "fsl_hhs_nofoodhh"                                          
#> [174] "fsl_hhs_nofoodhh_freq"                                     
#> [175] "fsl_hhs_sleephungry"                                       
#> [176] "fsl_hhs_sleephungry_freq"                                  
#> [177] "fsl_hhs_alldaynight"                                       
#> [178] "fsl_hhs_alldaynight_freq"                                  
#> [179] "fsl_lcsi_stress1"                                          
#> [180] "fsl_lcsi_stress2"                                          
#> [181] "fsl_lcsi_stress3"                                          
#> [182] "fsl_lcsi_stress4"                                          
#> [183] "fsl_lcsi_crisis1"                                          
#> [184] "fsl_lcsi_crisis2"                                          
#> [185] "fsl_lcsi_crisis3"                                          
#> [186] "fsl_lcsi_emergency1"                                       
#> [187] "fsl_lcsi_emergency2"                                       
#> [188] "fsl_lcsi_emergency3"                                       
#> [189] "fsl_lcsi_other_reason"                                     
#> [190] "other_fsl_lcsi_other_reason"                               
#> [191] "fsl_lcsi_en_stress1"                                       
#> [192] "fsl_lcsi_en_stress2"                                       
#> [193] "fsl_lcsi_en_stress3"                                       
#> [194] "fsl_lcsi_en_stress4"                                       
#> [195] "fsl_lcsi_en_crisis1"                                       
#> [196] "fsl_lcsi_en_crisis2"                                       
#> [197] "fsl_lcsi_en_crisis3"                                       
#> [198] "fsl_lcsi_en_emergency1"                                    
#> [199] "fsl_lcsi_en_emergency2"                                    
#> [200] "fsl_lcsi_en_emergency3"                                    
#> [201] "fsl_lcsi_en_other_reason"                                  
#> [202] "other_fsl_lcsi_en_other_reason"                            
#> [203] "cm_income_total"                                           
#> [204] "health_ind_pos"                                            
#> [205] "health_ind_name"                                           
#> [206] "health_ind_healthcare_needed"                              
#> [207] "health_ind_healthcare_needed_y"                            
#> [208] "health_ind_healthcare_received"                            
#> [209] "health_ind_healthcare_needed_n"                            
#> [210] "health_facility_time"                                      
#> [211] "nut_ind_pos"                                               
#> [212] "nut_ind_age"                                               
#> [213] "nut_ind_gender"                                            
#> [214] "nut_ind_age_0_4"                                           
#> [215] "nut_ind_under5_sick_yn"                                    
#> [216] "nut_ind_under5_sick_symptoms"                              
#> [217] "other_nut_ind_under5_sick_symptoms"                        
#> [218] "nut_treat_acute_malnutrition"                              
#> [219] "prot_needs_intro"                                          
#> [220] "prot_needs_1_services"                                     
#> [221] "prot_needs_1_justice"                                      
#> [222] "prot_needs_2_activities"                                   
#> [223] "prot_needs_2_social"                                       
#> [224] "prot_needs_3_movement"                                     
#> [225] "other_prot_needs_3_movement"                               
#> [226] "prot_concern_freq_gbv_areas"                               
#> [227] "prot_concern_freq_gbv_areas_type"                          
#> [228] "prot_concern_impact"                                       
#> [229] "prot_ind_pos"                                              
#> [230] "prot_ind_name"                                             
#> [231] "prot_child_work"                                           
#> [232] "prot_child_labour"                                         
#> [233] "ch_pr_behaviour_change"                                    
#> [234] "ds_plans"                                                  
#> [235] "ds_plans_timeline"                                         
#> [236] "consented"                                                 

attr(msna_template_required, "version")
#> [1] "0.0.0.9000"
```
