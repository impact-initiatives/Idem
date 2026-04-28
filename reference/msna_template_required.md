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

**`survey`** — 291 rows × 17 columns:

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

**`choices`** — 2,484 rows × 8 columns:

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
#> • survey: 291 rows
#> • choices: 2484 rows

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
#> [100] "edu"                                                       
#> [101] "edu_ind"                                                   
#> [102] "edu_ind_pos"                                               
#> [103] "edu_ind_age_schooling"                                     
#> [104] "edu_ind_name"                                              
#> [105] "edu_access"                                                
#> [106] "edu_level_grade"                                           
#> [107] "edu_disrupted_hazards"                                     
#> [108] "edu_disrupted_teacher"                                     
#> [109] "edu_disrupted_displaced"                                   
#> [110] "edu_disrupted_attack"                                      
#> [111] "edu_barrier"                                               
#> [112] "other_edu_barrier"                                         
#> [113] "edu_ind"                                                   
#> [114] "edu"                                                       
#> [115] "shelter"                                                   
#> [116] "snfi_shelter_type"                                         
#> [117] "snfi_shelter_type_individual"                              
#> [118] "other_snfi_shelter_type_individual"                        
#> [119] "snfi_shelter_damage"                                       
#> [120] "snfi_shelter_issue"                                        
#> [121] "other_snfi_shelter_issue"                                  
#> [122] "snfi_fds_cooking"                                          
#> [123] "snfi_fds_cooking_issue"                                    
#> [124] "other_snfi_fds_cooking_issue"                              
#> [125] "snfi_fds_sleeping"                                         
#> [126] "snfi_fds_sleeping_issue"                                   
#> [127] "other_snfi_fds_sleeping_issue"                             
#> [128] "snfi_fds_storing"                                          
#> [129] "snfi_fds_storing_issue"                                    
#> [130] "other_snfi_fds_storing_issue"                              
#> [131] "snfi_essential_items_missing"                              
#> [132] "other_snfi_essential_items_missing"                        
#> [133] "shelter"                                                   
#> [134] "energy"                                                    
#> [135] "energy_lighting_source"                                    
#> [136] "other_energy_lighting_source"                              
#> [137] "energy"                                                    
#> [138] "hlp"                                                       
#> [139] "hlp_occupancy"                                             
#> [140] "other_hlp_occupancy"                                       
#> [141] "hlp_risk_eviction"                                         
#> [142] "hlp_threat_eviction"                                       
#> [143] "hlp"                                                       
#> [144] "wash"                                                      
#> [145] "wash_note"                                                 
#> [146] "wash_drinking_water_source"                                
#> [147] "other_wash_drinking_water_source"                          
#> [148] "wash_drinking_water_time_yn"                               
#> [149] "wash_drinking_water_time_int"                              
#> [150] "wash_drinking_water_time_sl"                               
#> [151] "wash_hwise_drink"                                          
#> [152] "wash_hwise_hands"                                          
#> [153] "wash_hwise_worry"                                          
#> [154] "wash_hwise_plans"                                          
#> [155] "wash_sanitation_facility"                                  
#> [156] "other_wash_sanitation_facility"                            
#> [157] "wash_sanitation_facility_sharing_yn"                       
#> [158] "wash_sanitation_facility_sharing_n"                        
#> [159] "wash_handwashing_facility"                                 
#> [160] "other_wash_handwashing_facility"                           
#> [161] "wash_handwashing_facility_observed_water_yn"               
#> [162] "wash_handwashing_facility_reported"                        
#> [163] "other_wash_handwashing_facility_reported"                  
#> [164] "wash_handwashing_facility_water_reported_yn"               
#> [165] "wash_soap_observed_yn"                                     
#> [166] "wash_soap_observed_type"                                   
#> [167] "other_wash_soap_observed_type"                             
#> [168] "wash_soap_reported_yn"                                     
#> [169] "wash_soap_reported_type"                                   
#> [170] "other_wash_soap_reported_type"                             
#> [171] "wash"                                                      
#> [172] "fsl"                                                       
#> [173] "fsl_fcs_cereal"                                            
#> [174] "fsl_fcs_legumes"                                           
#> [175] "fsl_fcs_dairy"                                             
#> [176] "fsl_fcs_meat"                                              
#> [177] "fsl_fcs_veg"                                               
#> [178] "fsl_fcs_fruit"                                             
#> [179] "fsl_fcs_oil"                                               
#> [180] "fsl_fcs_sugar"                                             
#> [181] "fsl_fcs_condiments"                                        
#> [182] "fsl_rcsi_note"                                             
#> [183] "fsl_rcsi_lessquality"                                      
#> [184] "fsl_rcsi_borrow"                                           
#> [185] "fsl_rcsi_mealsize"                                         
#> [186] "fsl_rcsi_mealadult"                                        
#> [187] "fsl_rcsi_mealnb"                                           
#> [188] "fsl_hhs_nofoodhh"                                          
#> [189] "fsl_hhs_nofoodhh_freq"                                     
#> [190] "fsl_hhs_sleephungry"                                       
#> [191] "fsl_hhs_sleephungry_freq"                                  
#> [192] "fsl_hhs_alldaynight"                                       
#> [193] "fsl_hhs_alldaynight_freq"                                  
#> [194] "fsl_lcsi_note"                                             
#> [195] "fsl_lcsi_stress1"                                          
#> [196] "fsl_lcsi_stress2"                                          
#> [197] "fsl_lcsi_stress3"                                          
#> [198] "fsl_lcsi_stress4"                                          
#> [199] "fsl_lcsi_crisis1"                                          
#> [200] "fsl_lcsi_crisis2"                                          
#> [201] "fsl_lcsi_crisis3"                                          
#> [202] "fsl_lcsi_emergency1"                                       
#> [203] "fsl_lcsi_emergency2"                                       
#> [204] "fsl_lcsi_emergency3"                                       
#> [205] "fsl_lcsi_other_reason"                                     
#> [206] "other_fsl_lcsi_other_reason"                               
#> [207] "fsl_lcsi_en_stress1"                                       
#> [208] "fsl_lcsi_en_stress2"                                       
#> [209] "fsl_lcsi_en_stress3"                                       
#> [210] "fsl_lcsi_en_stress4"                                       
#> [211] "fsl_lcsi_en_crisis1"                                       
#> [212] "fsl_lcsi_en_crisis2"                                       
#> [213] "fsl_lcsi_en_crisis3"                                       
#> [214] "fsl_lcsi_en_emergency1"                                    
#> [215] "fsl_lcsi_en_emergency2"                                    
#> [216] "fsl_lcsi_en_emergency3"                                    
#> [217] "fsl_lcsi_en_other_reason"                                  
#> [218] "other_fsl_lcsi_en_other_reason"                            
#> [219] "fsl"                                                       
#> [220] "cm"                                                        
#> [221] "cm_income_total"                                           
#> [222] "cm_expenditure_frequent"                                   
#> [223] "other_cm_expenditure_frequent"                             
#> [224] "cm_expenditure_frequent_note"                              
#> [225] "cm_expenditure_frequent_food"                              
#> [226] "cm_expenditure_frequent_rent"                              
#> [227] "cm_expenditure_frequent_water"                             
#> [228] "cm_expenditure_frequent_nfi"                               
#> [229] "cm_expenditure_frequent_utilities"                         
#> [230] "cm_expenditure_frequent_fuel"                              
#> [231] "cm_expenditure_frequent_transportation"                    
#> [232] "cm_expenditure_frequent_communication"                     
#> [233] "cm_expenditure_frequent_other"                             
#> [234] "cm_expenditure_infrequent"                                 
#> [235] "other_cm_expenditure_infrequent"                           
#> [236] "cm_expenditure_infrequent_note"                            
#> [237] "cm_expenditure_infrequent_shelter"                         
#> [238] "cm_expenditure_infrequent_clothing"                        
#> [239] "cm_expenditure_infrequent_nfi"                             
#> [240] "cm_expenditure_infrequent_health"                          
#> [241] "cm_expenditure_infrequent_education"                       
#> [242] "cm_expenditure_infrequent_debt"                            
#> [243] "cm_expenditure_infrequent_other"                           
#> [244] "cm"                                                        
#> [245] "health"                                                    
#> [246] "health_ind"                                                
#> [247] "health_ind_pos"                                            
#> [248] "health_ind_name"                                           
#> [249] "health_ind_healthcare_needed"                              
#> [250] "health_ind_healthcare_needed_y"                            
#> [251] "health_ind_healthcare_received"                            
#> [252] "health_ind"                                                
#> [253] "health_ind_healthcare_needed_n"                            
#> [254] "health_facility_time"                                      
#> [255] "health"                                                    
#> [256] "nutrition"                                                 
#> [257] "nut_ind"                                                   
#> [258] "nut_ind_pos"                                               
#> [259] "nut_ind_age"                                               
#> [260] "nut_ind_gender"                                            
#> [261] "nut_ind_age_0_4"                                           
#> [262] "nut_ind_under5_sick_yn"                                    
#> [263] "nut_ind_under5_sick_symptoms"                              
#> [264] "other_nut_ind_under5_sick_symptoms"                        
#> [265] "nut_ind"                                                   
#> [266] "nut_treat_acute_malnutrition"                              
#> [267] "nutrition"                                                 
#> [268] "protection"                                                
#> [269] "prot_needs_intro"                                          
#> [270] "prot_needs_1_services"                                     
#> [271] "prot_needs_1_justice"                                      
#> [272] "prot_needs_2_activities"                                   
#> [273] "prot_needs_2_social"                                       
#> [274] "prot_needs_3_movement"                                     
#> [275] "other_prot_needs_3_movement"                               
#> [276] "prot_concern_freq_gbv_areas"                               
#> [277] "prot_concern_freq_gbv_areas_type"                          
#> [278] "prot_concern_impact"                                       
#> [279] "prot_ind"                                                  
#> [280] "prot_ind_pos"                                              
#> [281] "prot_ind_name"                                             
#> [282] "prot_child_work"                                           
#> [283] "prot_child_labour"                                         
#> [284] "prot_ind"                                                  
#> [285] "ch_pr_behaviour_change"                                    
#> [286] "durable_solutions"                                         
#> [287] "ds_plans"                                                  
#> [288] "ds_plans_timeline"                                         
#> [289] "durable_solutions"                                         
#> [290] "consented"                                                 

attr(msna_template_required, "version")
#> [1] "0.0.0.9000"
```
