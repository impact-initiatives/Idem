# Get choice options from an XLSForm

Returns a named list of character vectors, where each name is a list
name and each element contains the choice option `name` values for that
list. Both the `choices` sheet and, when present, the `external_choices`
sheet are combined.

## Usage

``` r
xlsform_choices(x, ...)

# Default S3 method
xlsform_choices(x, ...)

# S3 method for class 'xlsform'
xlsform_choices(x, ...)
```

## Arguments

- x:

  An `xlsform` object.

- ...:

  Ignored; present for S3 method compatibility.

## Value

A named list of character vectors. Each name is a list name; each
element is the character vector of option `name` values for that list.
Rows with `NA` in either `list_name` or `name` are silently dropped.

## Details

This is useful for inspecting which options are available for a given
`select_one` or `select_multiple` question, and is used internally by
[`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
to compare option sets across two forms.

## See also

[`xlsform_defined_list_names()`](https://impact-initiatives.github.io/idem/reference/xlsform_defined_list_names.md)
for just the list names;
[`validate_choices()`](https://impact-initiatives.github.io/idem/reference/validate_choices.md)
to compare choice options across two forms.

## Examples

``` r
form <- read_xlsform(system.file("extdata/form.xlsx", package = "idem"))

# All choice options, organised by list name
xlsform_choices(form)
#> $cm_income_sources_reduced_1
#>  [1] "regular"           "casual"            "own_business"     
#>  [4] "own_production"    "social_benefits"   "rent"             
#>  [7] "remittances"       "assistance"        "donations_support"
#> [10] "loans"             "other"             "dnk"              
#> [13] "pnta"             
#> 
#> $cm_income_sources_reduced_2
#>  [1] "none"              "regular"           "casual"           
#>  [4] "own_business"      "own_production"    "social_benefits"  
#>  [7] "rent"              "remittances"       "assistance"       
#> [10] "donations_support" "loans"             "other"            
#> [13] "dnk"               "pnta"             
#> 
#> $fsl_crop_area_change
#> [1] "a_lot_more"    "slightly_more" "same"          "slightly_less"
#> [5] "a_lot_less"    "no_planting"   "dnk"           "pnta"         
#> 
#> $fsl_crop_diff
#>  [1] "no_difficulties_faced"   "no_access_to_land"      
#>  [3] "no_tools"                "lack_inputs"            
#>  [5] "crop_diseases_and_pests" "damage_to_croplands"    
#>  [7] "cropland_quality"        "flooding_or_heavy_rain" 
#>  [9] "drought_conditions"      "lack_of_workforce"      
#> [11] "illness_injury"          "fear_of_insecurity"     
#> [13] "fear_uxos"               "other"                  
#> [15] "dnk"                     "pnta"                   
#> 
#> $fsl_crop_harv_change
#> [1] "a_lot_more"    "slightly_more" "same"          "slightly_less"
#> [5] "a_lot_less"    "dnk"           "pnta"         
#> 
#> $fsl_crop_type
#>  [1] "maize"              "teff"               "wheat"             
#>  [4] "barley"             "wheat_barley_mixed" "sorghum"           
#>  [7] "pulses"             "vegetables"         "root_crops"        
#> [10] "fruit_crops"        "chat"               "coffee"            
#> [13] "other"             
#> 
#> $fsl_food_storing
#> [1] "fridge"    "container" "outside"   "other"     "dnk"       "pnta"     
#> 
#> $fsl_liv_act
#>  [1] "no"                  "yes_crop_production" "livestock"          
#>  [4] "yes_fish_production" "crop_livestock"      "crop_fish"          
#>  [7] "livestock_fish"      "yes_all_three"       "dnk"                
#> [10] "pnta"               
#> 
#> $fsl_livestock_change
#>  [1] "did_not_sell_as_many"  "many_more_were_born"   "purchased_more"       
#>  [4] "received_animals"      "livestock_disease"     "animal_death"         
#>  [7] "sold_more"             "distress_sale"         "flooding"             
#> [10] "drought"               "lack_of_water"         "lack_of_fodder"       
#> [13] "lack_vet_vaccination"  "animal_lost_or_stolen" "killed_gifted_animals"
#> [16] "payments_fines"        "bridewealth_payment"   "other"                
#> [19] "dnk"                   "pnta"                 
#> 
#> $fsl_livestock_diff
#>  [1] "diff_feed"          "pasture_access"     "water_access"      
#>  [4] "vet_inputs_access"  "liv_diseases"       "liv_markets_access"
#>  [7] "credit_access"      "labor_access"       "other"             
#> [10] "dnk"                "pnta"              
#> 
#> $fsl_livestock_type
#>  [1] "oxen"    "camel"   "cattle"  "horse"   "mule"    "donkey"  "sheep"  
#>  [8] "goat"    "poultry" "other"   "dnk"     "pnta"   
#> 
#> $l_aap_assistance_improves_living_challenges
#>  [1] "no_additional_challenges"          "increased_dependency"             
#>  [3] "tensions_within_household"         "tensions_within_local_authorities"
#>  [5] "tensions_within_community"         "reduced_opportunities"            
#>  [7] "increased_prices"                  "safety_or"                        
#>  [9] "other"                             "pnta"                             
#> 
#> $l_aap_assistance_improves_living_conditions
#>  [1] "food_consumption"            "nutrition"                  
#>  [3] "access_safe_wash"            "maintain_adequate_shelter"  
#>  [5] "pay_basic_services"          "access_health"              
#>  [7] "education"                   "livelihoods_income"         
#>  [9] "cope_shocks"                 "access_services_safely"     
#> [11] "sense_dignity"               "social_relations"           
#> [13] "other"                       "no_area_better_than_without"
#> 
#> $l_aap_cfm_use
#> [1] "no_feedbacks"          "feedbacks_no_used"     "feedbacks_satisfied"  
#> [4] "feedbacks_unsatisfied" "feedback_no_answers"   "dnk"                  
#> [7] "pnta"                 
#> 
#> $l_aap_consultation_assistance_opinions
#> [1] "very_confident"     "somewhat_confident" "not_confident"     
#> [4] "pnta"              
#> 
#> $l_aap_information_needs
#>  [1] "none"                                
#>  [2] "news"                                
#>  [3] "missing_people"                      
#>  [4] "security_situation"                  
#>  [5] "registration_aid"                    
#>  [6] "water_access"                        
#>  [7] "food_access"                         
#>  [8] "nutrition_information"               
#>  [9] "shelter_housing_access"              
#> [10] "food_livelihood_price"               
#> [11] "fuel_access"                         
#> [12] "weather"                             
#> [13] "healthcare_access"                   
#> [14] "protection_attack_harassment_support"
#> [15] "documentation_service"               
#> [16] "education_access"                    
#> [17] "work_access"                         
#> [18] "transport_access"                    
#> [19] "financial_supoprt"                   
#> [20] "relocation"                          
#> [21] "aid_beneficiaries_information"       
#> [22] "cfm"                                 
#> [23] "hlp_rights"                          
#> [24] "dnk"                                 
#> [25] "pnta"                                
#> [26] "other"                               
#> 
#> $l_aap_preferred_means_feedback
#>  [1] "face_to_face_aidworkers" "face_to_face_community" 
#>  [3] "complaint_box"           "phone_call"             
#>  [5] "sms"                     "instant_messaging"      
#>  [7] "facebook"                "letter"                 
#>  [9] "tweet"                   "radio"                  
#> [11] "other"                   "no_feedbacks"           
#> [13] "no_knowledge"            "dnk"                    
#> [15] "pnta"                   
#> 
#> $l_aap_preferred_source_info
#>  [1] "tv"                 "radio"              "printed_newspapers"
#>  [4] "online_news"        "government"         "community_leader"  
#>  [7] "religious_leader"   "neighbour"          "nngo"              
#> [10] "ingo"               "no_trust"           "no_source"         
#> [13] "dnk"                "pnta"               "other"             
#> 
#> $l_aap_received_assistance_date
#> [1] "past_30d"    "1_3_months"  "4_6_months"  "7_12_months" "dnk"        
#> [6] "pnta"       
#> 
#> $l_aap_received_assistance_type
#>  [1] "cash_unconditional"       "cash_conditional"        
#>  [3] "inkind_food"              "inkind_nfi"              
#>  [5] "service_edu"              "service_health"          
#>  [7] "service_vocational"       "service_farming_land"    
#>  [9] "service_legal"            "infrastructure_wash"     
#> [11] "infrastructure_community" "other"                   
#> [13] "pnta"                    
#> 
#> $l_aap_received_channel_info_aid
#>  [1] "phone_call"          "sms"                 "twitter_x"          
#>  [4] "facebook"            "messaging_platforms" "face_to_face"       
#>  [7] "other_platforms"     "tv"                  "newspapers"         
#> [10] "billboards"          "leaflets"            "loudspeaker"        
#> [13] "other"              
#> 
#> $l_aap_relevance_assistance
#> [1] "all"      "majority" "few"      "none"     "pnta"    
#> 
#> $l_aap_relevance_assistance_reason
#> [1] "poor_quality"       "insufficient"       "delays"            
#> [4] "not_needed_most"    "not_preferred_form" "other"             
#> [7] "pnta"              
#> 
#> $l_aap_satisfaction_assistance
#> [1] "better"          "as_expected"     "worse"           "no_expectations"
#> [5] "pnta"           
#> 
#> $l_aap_satisfaction_challenges
#>  [1] "physical_barriers"           "delays"                     
#>  [3] "lack_information_access_aid" "lack_mean_access"           
#>  [5] "lack_information_use"        "safety"                     
#>  [7] "bribe"                       "discrimination"             
#>  [9] "language_barriers"           "waiting_time"               
#> [11] "no_assistance"               "no_challenges"              
#> [13] "other"                       "pnta"                       
#> 
#> $l_aap_satisfaction_workers_behaviour_reason
#>  [1] "demand_money_service_aid" "discrimination"          
#>  [3] "lack_communication"       "feedback_unanswered"     
#>  [5] "inappropriate_behavior"   "no_information"          
#>  [7] "refusal_registration"     "aid_worker_unavailable"  
#>  [9] "pnta"                     "other"                   
#> 
#> $l_admin1
#>   [1] "AF01"   "AF02"   "AF03"   "AF04"   "AF05"   "AF06"   "AF07"   "AF08"  
#>   [9] "AF09"   "AF10"   "AF11"   "AF12"   "AF13"   "AF14"   "AF15"   "AF16"  
#>  [17] "AF17"   "AF18"   "AF19"   "AF20"   "AF21"   "AF22"   "AF23"   "AF24"  
#>  [25] "AF25"   "AF26"   "AF27"   "AF28"   "AF29"   "AF30"   "AF31"   "AF32"  
#>  [33] "AF33"   "AF34"   "CF11"   "CF12"   "CF21"   "CF22"   "CF23"   "CF31"  
#>  [41] "CF32"   "CF41"   "CF42"   "CF43"   "CF51"   "CF52"   "CF53"   "CF61"  
#>  [49] "CF62"   "CF63"   "CF71"   "CD10"   "CD20"   "CD31"   "CD32"   "CD33"  
#>  [57] "CD41"   "CD42"   "CD43"   "CD44"   "CD45"   "CD51"   "CD52"   "CD53"  
#>  [65] "CD54"   "CD61"   "CD62"   "CD63"   "CD71"   "CD72"   "CD73"   "CD74"  
#>  [73] "CD81"   "CD82"   "CD83"   "CD91"   "CD92"   "ET01"   "ET02"   "ET03"  
#>  [81] "ET04"   "ET05"   "ET06"   "ET07"   "ET08"   "ET11"   "ET12"   "ET13"  
#>  [89] "ET14"   "ET15"   "ET16"   "HT01"   "HT02"   "HT03"   "HT04"   "HT05"  
#>  [97] "HT06"   "HT07"   "HT08"   "HT09"   "HT10"   "KE001"  "KE002"  "KE003" 
#> [105] "KE004"  "KE005"  "KE006"  "KE007"  "KE008"  "KE009"  "KE010"  "KE011" 
#> [113] "KE012"  "KE013"  "KE014"  "KE015"  "KE016"  "KE017"  "KE018"  "KE019" 
#> [121] "KE020"  "KE021"  "KE022"  "KE023"  "KE024"  "KE025"  "KE026"  "KE027" 
#> [129] "KE028"  "KE029"  "KE030"  "KE031"  "KE032"  "KE033"  "KE034"  "KE035" 
#> [137] "KE036"  "KE037"  "KE038"  "KE039"  "KE040"  "KE041"  "KE042"  "KE043" 
#> [145] "KE044"  "KE045"  "KE046"  "KE047"  "LB1"    "LB2"    "LB3"    "LB4"   
#> [153] "LB5"    "LB6"    "LB7"    "LB8"    "MMR001" "MMR002" "MMR003" "MMR004"
#> [161] "MMR005" "MMR006" "MMR007" "MMR008" "MMR009" "MMR010" "MMR011" "MMR012"
#> [169] "MMR013" "MMR014" "MMR015" "MMR016" "MMR017" "MMR018" "SD01"   "SD02"  
#> [177] "SD03"   "SD04"   "SD05"   "SD06"   "SD07"   "SD08"   "SD09"   "SD10"  
#> [185] "SD11"   "SD12"   "SD13"   "SD14"   "SD15"   "SD16"   "SD17"   "SD18"  
#> [193] "SD19"   "SY01"   "SY02"   "SY03"   "SY04"   "SY05"   "SY06"   "SY07"  
#> [201] "SY08"   "SY09"   "SY10"   "SY11"   "SY12"   "SY13"   "SY14"   "UA01"  
#> [209] "UA05"   "UA07"   "UA12"   "UA14"   "UA18"   "UA21"   "UA23"   "UA26"  
#> [217] "UA32"   "UA35"   "UA44"   "UA46"   "UA48"   "UA51"   "UA53"   "UA56"  
#> [225] "UA59"   "UA61"   "UA63"   "UA65"   "UA68"   "UA71"   "UA73"   "UA74"  
#> [233] "UA80"   "UA85"  
#> 
#> $l_admin2
#>    [1] "AF0101"     "AF0102"     "AF0103"     "AF0104"     "AF0105"    
#>    [6] "AF0106"     "AF0107"     "AF0108"     "AF0109"     "AF0110"    
#>   [11] "AF0111"     "AF0112"     "AF0113"     "AF0114"     "AF0115"    
#>   [16] "AF0201"     "AF0202"     "AF0203"     "AF0204"     "AF0205"    
#>   [21] "AF0206"     "AF0207"     "AF0301"     "AF0302"     "AF0303"    
#>   [26] "AF0304"     "AF0305"     "AF0306"     "AF0307"     "AF0308"    
#>   [31] "AF0309"     "AF0310"     "AF0401"     "AF0402"     "AF0403"    
#>   [36] "AF0404"     "AF0405"     "AF0406"     "AF0407"     "AF0408"    
#>   [41] "AF0409"     "AF0501"     "AF0502"     "AF0503"     "AF0504"    
#>   [46] "AF0505"     "AF0506"     "AF0507"     "AF0601"     "AF0602"    
#>   [51] "AF0603"     "AF0604"     "AF0605"     "AF0606"     "AF0607"    
#>   [56] "AF0608"     "AF0609"     "AF0610"     "AF0611"     "AF0612"    
#>   [61] "AF0613"     "AF0614"     "AF0615"     "AF0616"     "AF0617"    
#>   [66] "AF0618"     "AF0619"     "AF0620"     "AF0621"     "AF0622"    
#>   [71] "AF0701"     "AF0702"     "AF0703"     "AF0704"     "AF0705"    
#>   [76] "AF0801"     "AF0802"     "AF0803"     "AF0804"     "AF0805"    
#>   [81] "AF0806"     "AF0807"     "AF0901"     "AF0902"     "AF0903"    
#>   [86] "AF0904"     "AF0905"     "AF0906"     "AF0907"     "AF0908"    
#>   [91] "AF0909"     "AF0910"     "AF0911"     "AF0912"     "AF0913"    
#>   [96] "AF0914"     "AF0915"     "AF1001"     "AF1002"     "AF1003"    
#>  [101] "AF1004"     "AF1005"     "AF1006"     "AF1007"     "AF1101"    
#>  [106] "AF1102"     "AF1103"     "AF1104"     "AF1105"     "AF1106"    
#>  [111] "AF1107"     "AF1108"     "AF1109"     "AF1110"     "AF1111"    
#>  [116] "AF1112"     "AF1113"     "AF1114"     "AF1115"     "AF1116"    
#>  [121] "AF1117"     "AF1118"     "AF1119"     "AF1201"     "AF1202"    
#>  [126] "AF1203"     "AF1204"     "AF1205"     "AF1206"     "AF1207"    
#>  [131] "AF1208"     "AF1209"     "AF1210"     "AF1211"     "AF1212"    
#>  [136] "AF1213"     "AF1214"     "AF1215"     "AF1216"     "AF1217"    
#>  [141] "AF1218"     "AF1219"     "AF1301"     "AF1302"     "AF1303"    
#>  [146] "AF1304"     "AF1305"     "AF1306"     "AF1307"     "AF1308"    
#>  [151] "AF1309"     "AF1310"     "AF1311"     "AF1401"     "AF1402"    
#>  [156] "AF1403"     "AF1404"     "AF1405"     "AF1406"     "AF1407"    
#>  [161] "AF1408"     "AF1409"     "AF1410"     "AF1411"     "AF1412"    
#>  [166] "AF1413"     "AF1501"     "AF1502"     "AF1503"     "AF1504"    
#>  [171] "AF1505"     "AF1506"     "AF1507"     "AF1508"     "AF1509"    
#>  [176] "AF1510"     "AF1511"     "AF1512"     "AF1513"     "AF1514"    
#>  [181] "AF1515"     "AF1601"     "AF1602"     "AF1603"     "AF1604"    
#>  [186] "AF1605"     "AF1606"     "AF1607"     "AF1608"     "AF1701"    
#>  [191] "AF1702"     "AF1703"     "AF1704"     "AF1705"     "AF1706"    
#>  [196] "AF1707"     "AF1708"     "AF1709"     "AF1710"     "AF1711"    
#>  [201] "AF1712"     "AF1713"     "AF1714"     "AF1715"     "AF1716"    
#>  [206] "AF1717"     "AF1718"     "AF1719"     "AF1720"     "AF1721"    
#>  [211] "AF1722"     "AF1723"     "AF1724"     "AF1725"     "AF1726"    
#>  [216] "AF1727"     "AF1728"     "AF1801"     "AF1802"     "AF1803"    
#>  [221] "AF1804"     "AF1805"     "AF1806"     "AF1807"     "AF1808"    
#>  [226] "AF1809"     "AF1810"     "AF1811"     "AF1812"     "AF1813"    
#>  [231] "AF1814"     "AF1815"     "AF1816"     "AF1817"     "AF1901"    
#>  [236] "AF1902"     "AF1903"     "AF1904"     "AF1905"     "AF1906"    
#>  [241] "AF1907"     "AF2001"     "AF2002"     "AF2003"     "AF2004"    
#>  [246] "AF2005"     "AF2006"     "AF2007"     "AF2101"     "AF2102"    
#>  [251] "AF2103"     "AF2104"     "AF2105"     "AF2106"     "AF2107"    
#>  [256] "AF2108"     "AF2109"     "AF2110"     "AF2111"     "AF2112"    
#>  [261] "AF2113"     "AF2114"     "AF2115"     "AF2116"     "AF2201"    
#>  [266] "AF2202"     "AF2203"     "AF2204"     "AF2205"     "AF2206"    
#>  [271] "AF2207"     "AF2301"     "AF2302"     "AF2303"     "AF2304"    
#>  [276] "AF2305"     "AF2306"     "AF2307"     "AF2308"     "AF2309"    
#>  [281] "AF2310"     "AF2401"     "AF2402"     "AF2403"     "AF2404"    
#>  [286] "AF2405"     "AF2406"     "AF2407"     "AF2408"     "AF2409"    
#>  [291] "AF2501"     "AF2502"     "AF2503"     "AF2504"     "AF2505"    
#>  [296] "AF2506"     "AF2507"     "AF2601"     "AF2602"     "AF2603"    
#>  [301] "AF2604"     "AF2605"     "AF2606"     "AF2607"     "AF2608"    
#>  [306] "AF2609"     "AF2610"     "AF2611"     "AF2701"     "AF2702"    
#>  [311] "AF2703"     "AF2704"     "AF2705"     "AF2706"     "AF2707"    
#>  [316] "AF2708"     "AF2709"     "AF2710"     "AF2711"     "AF2712"    
#>  [321] "AF2713"     "AF2714"     "AF2715"     "AF2716"     "AF2801"    
#>  [326] "AF2802"     "AF2803"     "AF2804"     "AF2805"     "AF2806"    
#>  [331] "AF2807"     "AF2808"     "AF2809"     "AF2810"     "AF2811"    
#>  [336] "AF2901"     "AF2902"     "AF2903"     "AF2904"     "AF2905"    
#>  [341] "AF2906"     "AF2907"     "AF2908"     "AF2909"     "AF2910"    
#>  [346] "AF2911"     "AF2912"     "AF2913"     "AF2914"     "AF3001"    
#>  [351] "AF3002"     "AF3003"     "AF3004"     "AF3005"     "AF3006"    
#>  [356] "AF3007"     "AF3008"     "AF3009"     "AF3010"     "AF3011"    
#>  [361] "AF3012"     "AF3013"     "AF3101"     "AF3102"     "AF3103"    
#>  [366] "AF3104"     "AF3105"     "AF3106"     "AF3107"     "AF3201"    
#>  [371] "AF3202"     "AF3203"     "AF3204"     "AF3205"     "AF3206"    
#>  [376] "AF3207"     "AF3208"     "AF3209"     "AF3210"     "AF3211"    
#>  [381] "AF3212"     "AF3213"     "AF3214"     "AF3215"     "AF3216"    
#>  [386] "AF3301"     "AF3302"     "AF3303"     "AF3304"     "AF3305"    
#>  [391] "AF3306"     "AF3307"     "AF3308"     "AF3309"     "AF3310"    
#>  [396] "AF3311"     "AF3401"     "AF3402"     "AF3403"     "AF3404"    
#>  [401] "AF3405"     "CF111"      "CF112"      "CF113"      "CF114"     
#>  [406] "CF115"      "CF116"      "CF121"      "CF122"      "CF123"     
#>  [411] "CF124"      "CF125"      "CF211"      "CF212"      "CF213"     
#>  [416] "CF214"      "CF215"      "CF216"      "CF217"      "CF221"     
#>  [421] "CF222"      "CF223"      "CF224"      "CF231"      "CF232"     
#>  [426] "CF233"      "CF311"      "CF312"      "CF313"      "CF314"     
#>  [431] "CF315"      "CF316"      "CF321"      "CF322"      "CF323"     
#>  [436] "CF324"      "CF325"      "CF326"      "CF327"      "CF411"     
#>  [441] "CF412"      "CF413"      "CF414"      "CF421"      "CF422"     
#>  [446] "CF431"      "CF432"      "CF433"      "CF434"      "CF435"     
#>  [451] "CF511"      "CF512"      "CF521"      "CF522"      "CF523"     
#>  [456] "CF531"      "CF532"      "CF611"      "CF612"      "CF613"     
#>  [461] "CF614"      "CF615"      "CF616"      "CF621"      "CF622"     
#>  [466] "CF623"      "CF624"      "CF625"      "CF631"      "CF632"     
#>  [471] "CF633"      "CF634"      "CF711"      "CD1000"     "CD2001"    
#>  [476] "CD2002"     "CD2003"     "CD2005"     "CD2007"     "CD2009"    
#>  [481] "CD2010"     "CD2011"     "CD2012"     "CD2013"     "CD2015"    
#>  [486] "CD2017"     "CD2018"     "CD2019"     "CD3102"     "CD3103"    
#>  [491] "CD3105"     "CD3107"     "CD3108"     "CD3201"     "CD3202"    
#>  [496] "CD3203"     "CD3204"     "CD3206"     "CD3208"     "CD3209"    
#>  [501] "CD3210"     "CD3212"     "CD3302"     "CD3303"     "CD3304"    
#>  [506] "CD3305"     "CD3306"     "CD3307"     "CD3308"     "CD3310"    
#>  [511] "CD3311"     "CD4101"     "CD4102"     "CD4103"     "CD4104"    
#>  [516] "CD4105"     "CD4107"     "CD4108"     "CD4109"     "CD4202"    
#>  [521] "CD4203"     "CD4204"     "CD4205"     "CD4206"     "CD4301"    
#>  [526] "CD4302"     "CD4304"     "CD4305"     "CD4306"     "CD4402"    
#>  [531] "CD4404"     "CD4405"     "CD4502"     "CD4503"     "CD4504"    
#>  [536] "CD4505"     "CD4506"     "CD4507"     "CD5101"     "CD5102"    
#>  [541] "CD5103"     "CD5105"     "CD5106"     "CD5107"     "CD5109"    
#>  [546] "CD5110"     "CD5111"     "CD5202"     "CD5204"     "CD5206"    
#>  [551] "CD5207"     "CD5208"     "CD5209"     "CD5210"     "CD5301"    
#>  [556] "CD5302"     "CD5303"     "CD5305"     "CD5306"     "CD5307"    
#>  [561] "CD5309"     "CD5311"     "CD5401"     "CD5402"     "CD5403"    
#>  [566] "CD5404"     "CD5405"     "CD5407"     "CD5409"     "CD5410"    
#>  [571] "CD5411"     "CD6101"     "CD6102"     "CD6103"     "CD6104"    
#>  [576] "CD6105"     "CD6107"     "CD6109"     "CD6110"     "CD6111"    
#>  [581] "CD6201"     "CD6202"     "CD6203"     "CD6205"     "CD6206"    
#>  [586] "CD6207"     "CD6208"     "CD6210"     "CD6211"     "CD6212"    
#>  [591] "CD6213"     "CD6301"     "CD6302"     "CD6303"     "CD6305"    
#>  [596] "CD6307"     "CD6308"     "CD6309"     "CD6310"     "CD6311"    
#>  [601] "CD6313"     "CD7101"     "CD7102"     "CD7104"     "CD7105"    
#>  [606] "CD7106"     "CD7107"     "CD7108"     "CD7109"     "CD7201"    
#>  [611] "CD7202"     "CD7203"     "CD7204"     "CD7205"     "CD7206"    
#>  [616] "CD7207"     "CD7302"     "CD7303"     "CD7304"     "CD7305"    
#>  [621] "CD7306"     "CD7402"     "CD7403"     "CD7404"     "CD7406"    
#>  [626] "CD7407"     "CD7409"     "CD7410"     "CD8102"     "CD8103"    
#>  [631] "CD8104"     "CD8105"     "CD8106"     "CD8108"     "CD8201"    
#>  [636] "CD8202"     "CD8204"     "CD8205"     "CD8207"     "CD8208"    
#>  [641] "CD8209"     "CD8302"     "CD8303"     "CD8305"     "CD8306"    
#>  [646] "CD8307"     "CD8308"     "CD8309"     "CD8311"     "CD9101"    
#>  [651] "CD9102"     "CD9103"     "CD9104"     "CD9105"     "CD9106"    
#>  [656] "CD9107"     "CD9201"     "CD9202"     "CD9204"     "CD9205"    
#>  [661] "CD9207"     "CD9208"     "ET0101"     "ET0102"     "ET0103"    
#>  [666] "ET0104"     "ET0105"     "ET0106"     "ET0107"     "ET0201"    
#>  [671] "ET0202"     "ET0203"     "ET0204"     "ET0205"     "ET0206"    
#>  [676] "ET0301"     "ET0302"     "ET0303"     "ET0304"     "ET0305"    
#>  [681] "ET0306"     "ET0307"     "ET0308"     "ET0309"     "ET0310"    
#>  [686] "ET0311"     "ET0312"     "ET0401"     "ET0402"     "ET0403"    
#>  [691] "ET0404"     "ET0405"     "ET0406"     "ET0407"     "ET0408"    
#>  [696] "ET0409"     "ET0410"     "ET0411"     "ET0412"     "ET0413"    
#>  [701] "ET0414"     "ET0415"     "ET0416"     "ET0417"     "ET0418"    
#>  [706] "ET0419"     "ET0420"     "ET0421"     "ET0422"     "ET0501"    
#>  [711] "ET0502"     "ET0503"     "ET0504"     "ET0505"     "ET0506"    
#>  [716] "ET0507"     "ET0508"     "ET0509"     "ET0510"     "ET0511"    
#>  [721] "ET0602"     "ET0603"     "ET0604"     "ET0605"     "ET0701"    
#>  [726] "ET0702"     "ET0703"     "ET0705"     "ET0706"     "ET0707"    
#>  [731] "ET0710"     "ET0712"     "ET0713"     "ET0714"     "ET0715"    
#>  [736] "ET0716"     "ET0720"     "ET0721"     "ET0722"     "ET0723"    
#>  [741] "ET0724"     "ET0801"     "ET0802"     "ET0803"     "ET0804"    
#>  [746] "ET0805"     "ET0806"     "ET0807"     "ET0808"     "ET0809"    
#>  [751] "ET0810"     "ET0811"     "ET0812"     "ET1101"     "ET1102"    
#>  [756] "ET1103"     "ET1104"     "ET1105"     "ET1106"     "ET1201"    
#>  [761] "ET1202"     "ET1203"     "ET1204"     "ET1301"     "ET1401"    
#>  [766] "ET1501"     "ET1502"     "ET1601"     "ET1602"     "ET1603"    
#>  [771] "ET1604"     "ET1605"     "HT0111"     "HT0112"     "HT0113"    
#>  [776] "HT0114"     "HT0115"     "HT0116"     "HT0117"     "HT0118"    
#>  [781] "HT0121"     "HT0122"     "HT0123"     "HT0131"     "HT0132"    
#>  [786] "HT0133"     "HT0134"     "HT0135"     "HT0141"     "HT0142"    
#>  [791] "HT0151"     "HT0152"     "HT0211"     "HT0212"     "HT0213"    
#>  [796] "HT0214"     "HT0221"     "HT0222"     "HT0231"     "HT0232"    
#>  [801] "HT0233"     "HT0234"     "HT0311"     "HT0312"     "HT0313"    
#>  [806] "HT0321"     "HT0322"     "HT0323"     "HT0331"     "HT0332"    
#>  [811] "HT0341"     "HT0342"     "HT0343"     "HT0344"     "HT0345"    
#>  [816] "HT0351"     "HT0352"     "HT0361"     "HT0362"     "HT0371"    
#>  [821] "HT0372"     "HT0411"     "HT0412"     "HT0413"     "HT0421"    
#>  [826] "HT0422"     "HT0423"     "HT0431"     "HT0432"     "HT0433"    
#>  [831] "HT0434"     "HT0441"     "HT0442"     "HT0443"     "HT0511"    
#>  [836] "HT0512"     "HT0513"     "HT0521"     "HT0522"     "HT0523"    
#>  [841] "HT0531"     "HT0532"     "HT0533"     "HT0541"     "HT0542"    
#>  [846] "HT0543"     "HT0544"     "HT0551"     "HT0552"     "HT0611"    
#>  [851] "HT0612"     "HT0613"     "HT0614"     "HT0621"     "HT0622"    
#>  [856] "HT0623"     "HT0631"     "HT0632"     "HT0633"     "HT0641"    
#>  [861] "HT0642"     "HT0711"     "HT0712"     "HT0713"     "HT0714"    
#>  [866] "HT0715"     "HT0716"     "HT0721"     "HT0722"     "HT0723"    
#>  [871] "HT0731"     "HT0732"     "HT0733"     "HT0741"     "HT0742"    
#>  [876] "HT0743"     "HT0751"     "HT0752"     "HT0753"     "HT0811"    
#>  [881] "HT0812"     "HT0813"     "HT0814"     "HT0815"     "HT0821"    
#>  [886] "HT0822"     "HT0823"     "HT0831"     "HT0832"     "HT0833"    
#>  [891] "HT0834"     "HT0911"     "HT0912"     "HT0913"     "HT0914"    
#>  [896] "HT0921"     "HT0922"     "HT0931"     "HT0932"     "HT0933"    
#>  [901] "HT0934"     "HT1011"     "HT1012"     "HT1013"     "HT1014"    
#>  [906] "HT1021"     "HT1022"     "HT1023"     "HT1024"     "HT1025"    
#>  [911] "HT1031"     "HT1032"     "KE001001"   "KE001002"   "KE001003"  
#>  [916] "KE001004"   "KE001005"   "KE001006"   "KE002007"   "KE002008"  
#>  [921] "KE002009"   "KE002010"   "KE003011"   "KE003012"   "KE003013"  
#>  [926] "KE003014"   "KE003015"   "KE003016"   "KE003017"   "KE004018"  
#>  [931] "KE004019"   "KE004020"   "KE005021"   "KE005022"   "KE006023"  
#>  [936] "KE006024"   "KE006025"   "KE006026"   "KE007027"   "KE007028"  
#>  [941] "KE007029"   "KE007030"   "KE007031"   "KE007032"   "KE008033"  
#>  [946] "KE008034"   "KE008035"   "KE008036"   "KE008037"   "KE008038"  
#>  [951] "KE009039"   "KE009040"   "KE009041"   "KE009042"   "KE009043"  
#>  [956] "KE009044"   "KE010045"   "KE010046"   "KE010047"   "KE010048"  
#>  [961] "KE011049"   "KE011050"   "KE012051"   "KE012052"   "KE012053"  
#>  [966] "KE012054"   "KE012055"   "KE012056"   "KE012057"   "KE012058"  
#>  [971] "KE012059"   "KE013060"   "KE013061"   "KE013062"   "KE014063"  
#>  [976] "KE014064"   "KE014065"   "KE014066"   "KE015067"   "KE015068"  
#>  [981] "KE015069"   "KE015070"   "KE015071"   "KE015072"   "KE015073"  
#>  [986] "KE015074"   "KE016075"   "KE016076"   "KE016077"   "KE016078"  
#>  [991] "KE016079"   "KE016080"   "KE016081"   "KE016082"   "KE017083"  
#>  [996] "KE017084"   "KE017085"   "KE017086"   "KE017087"   "KE017088"  
#> [1001] "KE018089"   "KE018090"   "KE018091"   "KE018092"   "KE018093"  
#> [1006] "KE019094"   "KE019095"   "KE019096"   "KE019097"   "KE019098"  
#> [1011] "KE019099"   "KE020100"   "KE020101"   "KE020102"   "KE020103"  
#> [1016] "KE021104"   "KE021105"   "KE021106"   "KE021107"   "KE021108"  
#> [1021] "KE021109"   "KE021110"   "KE022111"   "KE022112"   "KE022113"  
#> [1026] "KE022114"   "KE022115"   "KE022116"   "KE022117"   "KE022118"  
#> [1031] "KE022119"   "KE022120"   "KE022121"   "KE022122"   "KE023123"  
#> [1036] "KE023124"   "KE023125"   "KE023126"   "KE023127"   "KE023128"  
#> [1041] "KE024129"   "KE024130"   "KE024131"   "KE024132"   "KE025133"  
#> [1046] "KE025134"   "KE025135"   "KE026136"   "KE026137"   "KE026138"  
#> [1051] "KE026139"   "KE026140"   "KE027141"   "KE027142"   "KE027143"  
#> [1056] "KE027144"   "KE027145"   "KE027146"   "KE028147"   "KE028148"  
#> [1061] "KE028149"   "KE028150"   "KE029151"   "KE029152"   "KE029153"  
#> [1066] "KE029154"   "KE029155"   "KE029156"   "KE030157"   "KE030158"  
#> [1071] "KE030159"   "KE030160"   "KE030161"   "KE030162"   "KE031163"  
#> [1076] "KE031164"   "KE031165"   "KE032166"   "KE032167"   "KE032168"  
#> [1081] "KE032169"   "KE032170"   "KE032171"   "KE032172"   "KE032173"  
#> [1086] "KE032174"   "KE032175"   "KE032176"   "KE033177"   "KE033178"  
#> [1091] "KE033179"   "KE033180"   "KE033181"   "KE033182"   "KE034183"  
#> [1096] "KE034184"   "KE034185"   "KE034186"   "KE034187"   "KE035188"  
#> [1101] "KE035189"   "KE035190"   "KE035191"   "KE035192"   "KE035193"  
#> [1106] "KE036194"   "KE036195"   "KE036196"   "KE036197"   "KE036198"  
#> [1111] "KE037199"   "KE037200"   "KE037201"   "KE037202"   "KE037203"  
#> [1116] "KE037204"   "KE037205"   "KE037206"   "KE037207"   "KE037208"  
#> [1121] "KE037209"   "KE037210"   "KE038211"   "KE038212"   "KE038213"  
#> [1126] "KE038214"   "KE038215"   "KE039216"   "KE039217"   "KE039218"  
#> [1131] "KE039219"   "KE039220"   "KE039221"   "KE039222"   "KE039223"  
#> [1136] "KE039224"   "KE040225"   "KE040226"   "KE040227"   "KE040228"  
#> [1141] "KE040229"   "KE040230"   "KE040231"   "KE041232"   "KE041233"  
#> [1146] "KE041234"   "KE041235"   "KE041236"   "KE041237"   "KE042238"  
#> [1151] "KE042239"   "KE042240"   "KE042241"   "KE042242"   "KE042243"  
#> [1156] "KE042244"   "KE043245"   "KE043246"   "KE043247"   "KE043248"  
#> [1161] "KE043249"   "KE043250"   "KE043251"   "KE043252"   "KE044253"  
#> [1166] "KE044254"   "KE044255"   "KE044256"   "KE044257"   "KE044258"  
#> [1171] "KE044259"   "KE044260"   "KE045261"   "KE045262"   "KE045263"  
#> [1176] "KE045264"   "KE045265"   "KE045266"   "KE045267"   "KE045268"  
#> [1181] "KE045269"   "KE046270"   "KE046271"   "KE046272"   "KE046273"  
#> [1186] "KE047274"   "KE047275"   "KE047276"   "KE047277"   "KE047278"  
#> [1191] "KE047279"   "KE047280"   "KE047281"   "KE047282"   "KE047283"  
#> [1196] "KE047284"   "KE047285"   "KE047286"   "KE047287"   "KE047288"  
#> [1201] "KE047289"   "KE047290"   "LB11"       "LB21"       "LB22"      
#> [1206] "LB23"       "LB24"       "LB25"       "LB31"       "LB32"      
#> [1211] "LB33"       "LB34"       "LB35"       "LB36"       "LB41"      
#> [1216] "LB42"       "LB43"       "LB44"       "LB51"       "LB52"      
#> [1221] "LB53"       "LB54"       "LB55"       "LB56"       "LB57"      
#> [1226] "LB61"       "LB62"       "LB63"       "MMR001D001" "MMR001D002"
#> [1231] "MMR001D003" "MMR001D004" "MMR002D001" "MMR002D002" "MMR003D001"
#> [1236] "MMR003D002" "MMR003D003" "MMR003D004" "MMR004D001" "MMR004D002"
#> [1241] "MMR004D003" "MMR004D004" "MMR005D001" "MMR005D002" "MMR005D003"
#> [1246] "MMR005D004" "MMR005D005" "MMR005D006" "MMR005D007" "MMR005D008"
#> [1251] "MMR005D009" "MMR005D010" "MMR005D011" "MMR005S001" "MMR006D001"
#> [1256] "MMR006D002" "MMR006D003" "MMR007D001" "MMR007D002" "MMR008D001"
#> [1261] "MMR008D002" "MMR009D001" "MMR009D002" "MMR009D003" "MMR009D004"
#> [1266] "MMR009D005" "MMR010D001" "MMR010D002" "MMR010D003" "MMR010D004"
#> [1271] "MMR010D005" "MMR010D006" "MMR010D007" "MMR011D001" "MMR011D002"
#> [1276] "MMR012D001" "MMR012D002" "MMR012D003" "MMR012D004" "MMR012D005"
#> [1281] "MMR013D001" "MMR013D002" "MMR013D003" "MMR013D004" "MMR014D001"
#> [1286] "MMR014D002" "MMR014D003" "MMR014S001" "MMR014S002" "MMR015D001"
#> [1291] "MMR015D002" "MMR015D003" "MMR015D006" "MMR015D007" "MMR015D008"
#> [1296] "MMR015S001" "MMR015S002" "MMR016D001" "MMR016D002" "MMR016D003"
#> [1301] "MMR017D001" "MMR017D002" "MMR017D003" "MMR017D004" "MMR017D005"
#> [1306] "MMR017D006" "MMR018D001" "MMR018D002" "SD01001"    "SD01002"   
#> [1311] "SD01003"    "SD01004"    "SD01005"    "SD01006"    "SD01007"   
#> [1316] "SD02113"    "SD02114"    "SD02116"    "SD02117"    "SD02118"   
#> [1321] "SD02119"    "SD02120"    "SD02124"    "SD02126"    "SD02128"   
#> [1326] "SD02129"    "SD02133"    "SD02136"    "SD02168"    "SD02169"   
#> [1331] "SD02170"    "SD02171"    "SD03141"    "SD03143"    "SD03144"   
#> [1336] "SD03145"    "SD03146"    "SD03147"    "SD03149"    "SD03150"   
#> [1341] "SD03151"    "SD03153"    "SD03154"    "SD03156"    "SD03157"   
#> [1346] "SD03158"    "SD03159"    "SD03161"    "SD03162"    "SD03164"   
#> [1351] "SD03166"    "SD03167"    "SD03172"    "SD04111"    "SD04115"   
#> [1356] "SD04121"    "SD04122"    "SD04123"    "SD04125"    "SD04127"   
#> [1361] "SD04134"    "SD05139"    "SD05140"    "SD05142"    "SD05148"   
#> [1366] "SD05152"    "SD05155"    "SD05160"    "SD05163"    "SD05165"   
#> [1371] "SD06110"    "SD06112"    "SD06130"    "SD06131"    "SD06132"   
#> [1376] "SD06135"    "SD06137"    "SD06138"    "SD06139"    "SD07088"   
#> [1381] "SD07089"    "SD07090"    "SD07091"    "SD07093"    "SD07094"   
#> [1386] "SD07095"    "SD07096"    "SD07097"    "SD07098"    "SD07099"   
#> [1391] "SD07103"    "SD07104"    "SD07105"    "SD07106"    "SD07107"   
#> [1396] "SD07108"    "SD08104"    "SD08105"    "SD08106"    "SD08107"   
#> [1401] "SD08108"    "SD08109"    "SD08110"    "SD09044"    "SD09045"   
#> [1406] "SD09046"    "SD09047"    "SD09048"    "SD09049"    "SD09050"   
#> [1411] "SD09051"    "SD09052"    "SD10063"    "SD10064"    "SD10065"   
#> [1416] "SD10066"    "SD10067"    "SD10068"    "SD10069"    "SD10070"   
#> [1421] "SD10071"    "SD10072"    "SD11052"    "SD11053"    "SD11054"   
#> [1426] "SD11055"    "SD11056"    "SD11057"    "SD11058"    "SD11059"   
#> [1431] "SD11060"    "SD11061"    "SD11062"    "SD12073"    "SD12074"   
#> [1436] "SD12075"    "SD12076"    "SD12077"    "SD12078"    "SD12079"   
#> [1441] "SD12080"    "SD12081"    "SD12082"    "SD12083"    "SD12084"   
#> [1446] "SD13023"    "SD13024"    "SD13025"    "SD13026"    "SD13027"   
#> [1451] "SD13028"    "SD13029"    "SD13030"    "SD14037"    "SD14038"   
#> [1456] "SD14039"    "SD14040"    "SD14041"    "SD14042"    "SD14043"   
#> [1461] "SD15030"    "SD15031"    "SD15032"    "SD15033"    "SD15034"   
#> [1466] "SD15035"    "SD15036"    "SD15037"    "SD16008"    "SD16009"   
#> [1471] "SD16010"    "SD16011"    "SD16012"    "SD16013"    "SD16014"   
#> [1476] "SD17014"    "SD17015"    "SD17016"    "SD17017"    "SD17018"   
#> [1481] "SD17019"    "SD17020"    "SD18021"    "SD18022"    "SD18028"   
#> [1486] "SD18029"    "SD18085"    "SD18086"    "SD18087"    "SD18092"   
#> [1491] "SD18100"    "SD18102"    "SD18103"    "SD18104"    "SD18105"   
#> [1496] "SD18106"    "SD19001"    "SY0100"     "SY0200"     "SY0202"    
#> [1501] "SY0203"     "SY0204"     "SY0205"     "SY0206"     "SY0207"    
#> [1506] "SY0208"     "SY0301"     "SY0302"     "SY0303"     "SY0304"    
#> [1511] "SY0305"     "SY0306"     "SY0307"     "SY0308"     "SY0309"    
#> [1516] "SY0401"     "SY0402"     "SY0403"     "SY0404"     "SY0405"    
#> [1521] "SY0406"     "SY0501"     "SY0502"     "SY0503"     "SY0504"    
#> [1526] "SY0505"     "SY0600"     "SY0602"     "SY0603"     "SY0604"    
#> [1531] "SY0700"     "SY0702"     "SY0703"     "SY0704"     "SY0705"    
#> [1536] "SY0800"     "SY0802"     "SY0803"     "SY0804"     "SY0901"    
#> [1541] "SY0902"     "SY0903"     "SY1000"     "SY1002"     "SY1003"    
#> [1546] "SY1004"     "SY1005"     "SY1006"     "SY1101"     "SY1102"    
#> [1551] "SY1103"     "SY1200"     "SY1202"     "SY1203"     "SY1300"    
#> [1556] "SY1302"     "SY1303"     "SY1400"     "SY1402"     "UA0102"    
#> [1561] "UA0104"     "UA0106"     "UA0108"     "UA0110"     "UA0112"    
#> [1566] "UA0114"     "UA0116"     "UA0118"     "UA0120"     "UA0502"    
#> [1571] "UA0504"     "UA0506"     "UA0508"     "UA0510"     "UA0512"    
#> [1576] "UA0702"     "UA0704"     "UA0706"     "UA0708"     "UA1202"    
#> [1581] "UA1204"     "UA1206"     "UA1208"     "UA1210"     "UA1212"    
#> [1586] "UA1214"     "UA1402"     "UA1404"     "UA1406"     "UA1408"    
#> [1591] "UA1410"     "UA1412"     "UA1414"     "UA1416"     "UA1802"    
#> [1596] "UA1804"     "UA1806"     "UA1808"     "UA2102"     "UA2104"    
#> [1601] "UA2106"     "UA2108"     "UA2110"     "UA2112"     "UA2302"    
#> [1606] "UA2304"     "UA2306"     "UA2308"     "UA2310"     "UA2602"    
#> [1611] "UA2604"     "UA2606"     "UA2608"     "UA2610"     "UA2612"    
#> [1616] "UA3200"     "UA3202"     "UA3204"     "UA3206"     "UA3208"    
#> [1621] "UA3210"     "UA3212"     "UA3214"     "UA3502"     "UA3504"    
#> [1626] "UA3506"     "UA3508"     "UA4402"     "UA4404"     "UA4406"    
#> [1631] "UA4408"     "UA4410"     "UA4412"     "UA4414"     "UA4416"    
#> [1636] "UA4602"     "UA4604"     "UA4606"     "UA4608"     "UA4610"    
#> [1641] "UA4612"     "UA4614"     "UA4802"     "UA4804"     "UA4806"    
#> [1646] "UA4808"     "UA5102"     "UA5104"     "UA5106"     "UA5108"    
#> [1651] "UA5110"     "UA5112"     "UA5114"     "UA5302"     "UA5304"    
#> [1656] "UA5306"     "UA5308"     "UA5602"     "UA5604"     "UA5606"    
#> [1661] "UA5608"     "UA5902"     "UA5904"     "UA5906"     "UA5908"    
#> [1666] "UA5910"     "UA6102"     "UA6104"     "UA6106"     "UA6302"    
#> [1671] "UA6304"     "UA6306"     "UA6308"     "UA6310"     "UA6312"    
#> [1676] "UA6314"     "UA6502"     "UA6504"     "UA6506"     "UA6508"    
#> [1681] "UA6510"     "UA6802"     "UA6804"     "UA6806"     "UA7102"    
#> [1686] "UA7104"     "UA7106"     "UA7108"     "UA7302"     "UA7304"    
#> [1691] "UA7306"     "UA7402"     "UA7404"     "UA7406"     "UA7408"    
#> [1696] "UA7410"     "UA8000"     "UA8500"    
#> 
#> $l_admin3
#> [1] "PCODE111" "PCODE121" "PCODE211" "PCODE212"
#> 
#> $l_admin4
#> [1] "PCODE1111" "PCODE1211" "PCODE2111" "PCODE2121"
#> 
#> $l_ch_pr_behaviour_change
#>  [1] "no_behavior_changes"          "angry_aggressive"            
#>  [3] "appetite_changes"             "headaches"                   
#>  [5] "bedwetting"                   "nightmares_sleep_issues"     
#>  [7] "stomach_pain"                 "new_or_recurring_fears"      
#>  [9] "clinging_behavior"            "excessive_crying"            
#> [11] "regression_younger_behaviors" "easily_startled"             
#> [13] "substance_use"                "sad_or_withdrawn"            
#> [15] "dnk"                          "other"                       
#> [17] "pnta"                        
#> 
#> $l_cluster_id
#> [1] "cluster_1" "cluster_2" "cluster_3" "cluster_4"
#> 
#> $l_cm_expenditure_frequent
#>  [1] "food"           "rent"           "water"          "nfi"           
#>  [5] "utilities"      "fuel"           "transportation" "communications"
#>  [9] "other"          "no_expenditure" "dnk"            "pnta"          
#> 
#> $l_cm_expenditure_infrequent
#>  [1] "shelter"        "clothing"       "nfi"            "health"        
#>  [5] "education"      "debt"           "other"          "no_expenditure"
#>  [9] "dnk"            "pnta"          
#> 
#> $l_cm_income_source
#>  [1] "salaried"        "casual"          "own_business"    "own_production" 
#>  [5] "social_benefits" "rent"            "remittances"     "assistance"     
#>  [9] "support_friends" "donation"        "other"           "none"           
#> [13] "dnk"             "pnta"           
#> 
#> $l_cm_market_barriers_access
#>  [1] "no_barriers"                 "market_too_far"             
#>  [3] "transport_limited_expensive" "market_insecurity"          
#>  [5] "unsafe_market_buildings"     "insecure_travel_market"     
#>  [7] "road_damage_to_market"       "curfew_movement_restrict"   
#>  [9] "market_limited_hours"        "market_not_accessible_pwd"  
#> [11] "no_child_elderly_care"       "authority_restrict_access"  
#> [13] "hh_members_restrict_access"  "discrimination_market"      
#> [15] "other"                       "dnk"                        
#> [17] "pnta"                       
#> 
#> $l_cm_market_barriers_purchase
#> [1] "no_barriers"         "items_too_expensive" "items_not_available"
#> [4] "no_means_of_payment" "other"               "dnk"                
#> [7] "pnta"               
#> 
#> $l_cm_market_time
#> [1] "less_15_min"       "15_29_min"         "30_59_min"        
#> [4] "1_2_hours"         "more_than_2_hours" "dnk"              
#> [7] "pnta"             
#> 
#> $l_cpa_preferred_modality
#>  [1] "cash_unconditional"       "cash_conditional"        
#>  [3] "inkind_food"              "inkind_nfi"              
#>  [5] "service_edu"              "service_health"          
#>  [7] "service_vocational"       "service_farming_land"    
#>  [9] "service_legal"            "infrastructure_wash"     
#> [11] "infrastructure_community" "other"                   
#> [13] "do_not_want_assistance"   "no_preference"           
#> [15] "pnta"                    
#> 
#> $l_cpa_priority_support_cash
#> [1] "physical_cash" "bank_transfer" "prepaid_cards" "mobile_money" 
#> [5] "voucher"       "none"          "dnk"           "pnta"         
#> 
#> $l_dis_area_origin
#> [1] "in_this_area"              "somewhere_else_in_country"
#> [3] "another_country"           "pnta"                     
#> 
#> $l_dis_challenges
#> [1] "never"     "rarely"    "sometimes" "often"     "always"    "dnk"      
#> [7] "pnta"     
#> 
#> $l_dis_forced
#> [1] "yes_but_back"        "yes_still_displaced" "no_never"           
#> [4] "dnk"                 "pnta"               
#> 
#> $l_dis_reasons
#>  [1] "natural_disaster"              "manmade_disaster"             
#>  [3] "armed_conflict"                "intercommunal_violence"       
#>  [5] "persecution"                   "general_insecurity"           
#>  [7] "social_tension"                "econ_reason_conflict_related" 
#>  [9] "limited_services_conflict"     "econ_reason_non_conflict"     
#> [11] "limited_services_non_conflict" "other"                        
#> [13] "dnk"                           "pnta"                         
#> 
#> $l_dis_secondary_n
#> [1] "once"                 "twice"                "three_times"         
#> [4] "four_times"           "five_times"           "more_than_five_times"
#> [7] "dnk"                  "pnta"                
#> 
#> $l_ds_plans
#> [1] "stay_current_location"  "move_elsewhere_country" "return_to_origin"      
#> [4] "move_abroad"            "no_concrete_plan"       "dnk"                   
#> [7] "pnta"                  
#> 
#> $l_ds_plans_timeline
#> [1] "within_3_months"     "between_3_6_months"  "between_6_12_months"
#> [4] "after_one_year"      "dnk"                 "pnta"               
#> 
#> $l_edu_barrier
#>  [1] "costs"                     "child_work_home"          
#>  [3] "child_work_outside"        "child_too_young"          
#>  [5] "child_graduated"           "lack_interest"            
#>  [7] "not_priority"              "protection_at_school"     
#>  [9] "protection_travel_school"  "child_armed_group"        
#> [11] "child_marriage"            "child_pregnancy"          
#> [13] "child_health"              "lack_accessible_school"   
#> [15] "curriculum_not_useful"     "lack_classrooms"          
#> [17] "lack_wash_facilities"      "school_closed"            
#> [19] "lack_teacher"              "language"                 
#> [21] "ban"                       "enroll_lack_documentation"
#> [23] "enroll_displacement"       "discrimination"           
#> [25] "other"                     "dnk"                      
#> [27] "pnta"                     
#> 
#> $l_edu_community_modality
#>  [1] "none"                          "open_more_schools"            
#>  [3] "improve_infra"                 "improve_wash"                 
#>  [5] "improve_security_way"          "training"                     
#>  [7] "improve_salary"                "qualified_teachers"           
#>  [9] "modify_curriculum_certificate" "provide_technical"            
#> [11] "provide_accelerated_pg"        "provide_mhpss"                
#> [13] "provide_learningmaterial"      "cash_for_edu"                 
#> [15] "transportation"                "improve_cwd"                  
#> [17] "awaress_activities"            "provide_enrolment"            
#> [19] "dnk"                           "pnta"                         
#> 
#> $l_edu_financial_barrier
#>  [1] "cost_transportation" "cost_tuition"        "cost_materials"     
#>  [4] "cost_salaries"       "cost_uniform"        "cost_schoolfeeding" 
#>  [7] "cost_admin"          "cost_childlabor"     "cost_childmarriage" 
#> [10] "cost_admin2"         "other_specify"       "dnk"                
#> [13] "pnta"               
#> 
#> $l_edu_level_grade
#> [1] "level1_grade1"  "level1_grade2"  "level2_grade_1" "level2_grade_2"
#> [5] "level2_grade_3"
#> 
#> $l_edu_other_yn
#> [1] "nonformal_school1" "nonformal_school2" "nonformal_school3"
#> [4] "nonformal_school4" "nonformal_school5"
#> 
#> $l_energy_lighting_source
#>  [1] "electricity"             "solar_flashlight"       
#>  [3] "rechargeable_flashlight" "battery_flashlight"     
#>  [5] "biogas"                  "gasoline"               
#>  [7] "candle"                  "open_fire"              
#>  [9] "none"                    "other"                  
#> [11] "dnk"                     "pnta"                   
#> 
#> $l_enum_id
#> [1] "id_1" "id_2" "id_3"
#> 
#> $l_fsl_hhs
#> [1] "rarely"    "sometimes" "often"    
#> 
#> $l_fsl_lcsi
#> [1] "yes"            "no_had_no_need" "no_exhausted"   "not_applicable"
#> 
#> $l_fsl_lcsi_en_other
#> [1] "food"              "rent_shelter"      "education"        
#> [4] "health"            "nfis"              "wash"             
#> [7] "dwelling_services" "debts"             "other"            
#> 
#> $l_fsl_lcsi_other
#> [1] "none"              "rent_shelter"      "education"        
#> [4] "health"            "nfis"              "wash"             
#> [7] "dwelling_services" "debts"             "other"            
#> 
#> $l_fsl_source_food
#>  [1] "own_production"     "purchase_cash"      "purchase_credit"   
#>  [4] "hunting"            "gathering"          "exchange"          
#>  [7] "borrow"             "gift"               "begging"           
#> [10] "assistance_in_kind" "assistance_cva"     "other"             
#> [13] "dnk"                "pnta"              
#> 
#> $l_gender
#> [1] "male"   "female" "other"  "pnta"  
#> 
#> $l_hazard_env_type
#>  [1] "none"                  "flood"                 "drought"              
#>  [4] "wildfire"              "water_scarcity"        "cyclone"              
#>  [7] "dnk"                   "pnta"                  "landslide"            
#> [10] "earthquake"            "tsunami"               "volcanic_activity"    
#> [13] "disease_human_vector"  "disease_animal_vector" "insect_infestation"   
#> [16] "technological_hazards" "air_pollution"         "mine_contamination"   
#> [19] "land_degradation"      "conflict_violence"     "financial_shock"      
#> 
#> $l_hazard_sp_type
#>  [1] "none"                    "mine_contamination"     
#>  [3] "conflict_violence"       "financial_shock"        
#>  [5] "population_displacement" "eviction"               
#>  [7] "protection_crisis"       "dnk"                    
#>  [9] "pnta"                    "technological_hazards"  
#> 
#> $l_health_barriers
#>  [1] "none"                      "no_facility_nearby"       
#>  [3] "service_unavailable"       "long_wait_time"           
#>  [5] "cant_afford_consult"       "cant_afford_treatment"    
#>  [7] "cant_afford_transport"     "facility_too_far"         
#>  [9] "disability_access_barrier" "no_transport_means"       
#> [11] "unsafe_at_facility"        "unsafe_during_travel"     
#> [13] "wrong_medication"          "staff_not_trained"        
#> [15] "staff_shortage"            "wait_and_see"             
#> [17] "fear_distrust_healthcare"  "no_time_work_or_care"     
#> [19] "language_barrier"          "no_female_staff"          
#> [21] "other"                     "dnk"                      
#> [23] "pnta"                     
#> 
#> $l_health_ind_healthcare_needed_type
#>  [1] "preventative_consultation"  "consultation_acute"        
#>  [3] "consultation_chronic"       "trauma"                    
#>  [5] "elective_surgery"           "emergency_surgery"         
#>  [7] "natal_services"             "safe_delivery"             
#>  [9] "other_specialized_services" "other"                     
#> [11] "dnk"                        "pnta"                      
#> 
#> $l_health_ind_healthcare_received_location
#>  [1] "did_not_seek_care"      "gov_hospital"           "gov_health_center"     
#>  [4] "gov_health_post"        "private_hospital"       "private_clinic"        
#>  [7] "private_other_facility" "ngo_hospital"           "ngo_clinic"            
#> [10] "traditional_healer"     "pharmacy"               "other"                 
#> [13] "dnk"                    "pnta"                  
#> 
#> $l_hesper
#> [1] "no_problem" "problem"    "dnk"        "na"         "pnta"      
#> 
#> $l_hlp_occupancy
#> [1] "ownership"    "rented"       "hosted_free"  "no_agreement" "other"       
#> [6] "dnk"          "pnta"        
#> 
#> $l_hlp_threat_eviction
#> [1] "yes_official_order"    "yes_unofficial_threat" "at_risk"              
#> [4] "no"                    "dnk"                   "pnta"                 
#> 
#> $l_hoh_civil_status
#> [1] "single"   "married"  "divorced" "widowed"  "other"    "dnk"      "pnta"    
#> 
#> $l_id_yn
#> [1] "yes_id"       "member_hh_id" "no_id"        "dnk"          "pnta"        
#> 
#> $l_ind_age_under1
#>  [1] "0"   "1"   "2"   "3"   "4"   "5"   "6"   "7"   "8"   "9"   "10"  "11" 
#> [13] "dnk"
#> 
#> $l_nut_ind_under5_sick_location
#>  [1] "none"             "gov_hospital"     "gov_center"       "gov_post"        
#>  [5] "gov_other"        "private_hospital" "private_clinic"   "private_other"   
#>  [9] "ngo_hospital"     "ngo_clinic"       "ngo_other"        "other"           
#> [13] "dnk"              "pnta"            
#> 
#> $l_nut_ind_under5_sick_symptoms
#> [1] "fever"          "diarrhoea"      "cough"          "vomiting"      
#> [5] "skin_infection" "ear_infection"  "other"          "dnk"           
#> [9] "pnta"          
#> 
#> $l_participation_yes_no
#> [1] "yes"                  "yes_with_interpreter" "no"                  
#> 
#> $l_priority_support_ngo
#>  [1] "lack_access_drinking_water"    "lack_access_food"             
#>  [3] "inadequate_energy"             "lack_income"                  
#>  [5] "inadequate_shelter"            "lack_access_toilet"           
#>  [7] "lack_soap_water_laundry"       "lack_access_clothing"         
#>  [9] "lack_access_healthcare"        "emotional_distress"           
#> [11] "lack_safety"                   "children_not_attending_school"
#> [13] "lack_communication"            "separation_family"            
#> [15] "none"                          "other"                        
#> [17] "dnk"                           "pnta"                         
#> 
#> $l_prot_adult_sep_reason
#>  [1] "original_place_work"              "original_place_farming"          
#>  [3] "original_place_property"          "original_place_lack_money"       
#>  [5] "original_place_journey_unsafe"    "original_place_mobility_barriers"
#>  [7] "original_place_other"             "displaced_other_loc_choice"      
#>  [9] "displaced_other_loc_forced"       "recruited_armed_forced"          
#> [11] "other"                            "dnk"                             
#> [13] "pnta"                            
#> 
#> $l_prot_child_labour
#>  [1] "carry_heavy_loads"         "operate_heavy_machinery"  
#>  [3] "use_dangerous_tools"       "work_dangerous_places"    
#>  [5] "work_at_heights"           "work_in_mines"            
#>  [7] "work_at_night"             "exposed_to_chemicals"     
#>  [9] "long_hours_or_night_shift" "other_health_safety_risks"
#> [11] "none"                      "dnk"                      
#> [13] "pnta"                     
#> 
#> $l_prot_child_sep_reason
#>  [1] "left_married"           "left_employment"        "left_study"            
#>  [4] "left_armed_groups"      "stayed_in_origin"       "separated_displacement"
#>  [7] "kidnapped"              "missing"                "detained"              
#> [10] "other"                  "dnk"                    "pnta"                  
#> 
#> $l_prot_children_reasons
#>  [1] "marriage"      "employment"    "study"         "armed_groups" 
#>  [5] "stayed_behind" "separated"     "kidnapping"    "missing"      
#>  [9] "detained"      "other"         "dnk"           "pnta"         
#> 
#> $l_prot_concern_freq_gbv_areas_type
#>  [1] "no_unsafe_areas"            "latrines_bathing"          
#>  [3] "markets"                    "distribution_areas"        
#>  [5] "water_points"               "social_comm_religious"     
#>  [7] "route_to_school"            "route_to_health_centers"   
#>  [9] "route_to_fields"            "route_from_religious_place"
#> [11] "in_home"                    "public_transport"          
#> [13] "collecting_firewood"        "crossing_checkpoints"      
#> [15] "dont_know"                  "prefer_not_answer"         
#> 
#> $l_prot_concern_impact
#>  [1] "no_impact"                   "self_restrict_movement"     
#>  [3] "avoid_night_movement"        "no_access_fields"           
#>  [5] "no_access_food"              "no_access_drinking_water"   
#>  [7] "stay_at_home"                "avoid_social_interaction"   
#>  [9] "move_in_groups"              "men_accompany_women_night"  
#> [11] "avoid_communal_services"     "night_vigilance_less_sleep" 
#> [13] "avoid_health_services"       "avoid_education_services"   
#> [15] "avoid_livelihood_activities" "other"                      
#> [17] "dnk"                         "pnta"                       
#> 
#> $l_prot_id_missing_reason
#>  [1] "left_behind"          "no_need"              "no_collected"        
#>  [4] "no_office"            "no_knowledge_process" "no_money"            
#>  [7] "lost_destroyed"       "confiscated"          "denied_rights"       
#> [10] "no_time"              "other"                "dnk"                 
#> [13] "pnta"                
#> 
#> $l_prot_legal_barriers
#>  [1] "no_barriers"                    "no_services"                   
#>  [3] "lack_money"                     "distance_transport"            
#>  [5] "lack_civil_documentation"       "lack_access_individual_support"
#>  [7] "discrimination"                 "no_access_authorities"         
#>  [9] "other"                          "dnk"                           
#> [11] "pnta"                          
#> 
#> $l_prot_legal_yn
#>  [1] "no"                     "yes_identity_documents" "yes_civil_documents"   
#>  [4] "yes_documentation"      "yes_compensation"       "yes_pension"           
#>  [7] "yes_benefits"           "yes_subsidies"          "yes_other"             
#> [10] "dnk"                    "pnta"                  
#> 
#> $l_prot_mines
#>  [1] "not_affected"          "yes_livelihood"        "yes_education"        
#>  [4] "yes_market"            "yes_health"            "yes_freedome_movement"
#>  [7] "yes_injured_killed"    "other"                 "dnk"                  
#> [10] "pnta"                 
#> 
#> $l_prot_needs_1_justice
#> [1] "yes_identity_documents" "yes_counselling_legal"  "yes_property_docs"     
#> [4] "yes_gov_services"       "yes_birth_certificates" "yes_other_services"    
#> [7] "no"                     "dnk"                    "pnta"                  
#> 
#> $l_prot_needs_1_services
#>  [1] "yes_healthcare"           "yes_schools"             
#>  [3] "yes_gov_services"         "yes_therapeutic_services"
#>  [5] "yes_edu_facilities"       "yes_social_services"     
#>  [7] "yes_other_services"       "none"                    
#>  [9] "dnk"                      "pnta"                    
#> 
#> $l_prot_needs_2_activities
#>  [1] "yes_work"             "yes_livelihood"       "yes_safety"          
#>  [4] "yes_farm"             "yes_water"            "yes_other_activities"
#>  [7] "yes_free_choices"     "no"                   "dnk"                 
#> [10] "pnta"                
#> 
#> $l_prot_needs_2_social
#>  [1] "yes_visiting_family"  "yes_visiting_friends" "yes_community_events"
#>  [4] "yes_joining_groups"   "yes_other_social"     "yes_child_recreation"
#>  [7] "yes_decision_making"  "no"                   "dnk"                 
#> [10] "pnta"                
#> 
#> $l_prot_needs_3_movement
#>  [1] "no_changes_feel_unsafe"          "no_safety_concerns"             
#>  [3] "women_girls_avoid_places"        "men_avoid_places"               
#>  [5] "boys_avoid_places"               "women_girls_avoid_night"        
#>  [7] "men_avoid_night"                 "boys_avoid_night"               
#>  [9] "girls_boys_avoid_school"         "women_girls_boys_avoid_firewood"
#> [11] "women_girls_boys_avoid_places"   "different_routes"               
#> [13] "avoid_markets"                   "avoid_public_offices"           
#> [15] "avoid_fields"                    "other_safety_measures"          
#> [17] "dnk"                             "pnta"                           
#> 
#> $l_prot_needs_populations
#> [1] "men"   "women" "boys"  "girls" "pnta" 
#> 
#> $l_prot_needs_threats
#> [1] "violence_community"   "explosive_ordnance"   "kidnapping_abduction"
#> [4] "forced_recruitment"   "discrimination"       "no"                  
#> [7] "dnk"                  "pnta"                
#> 
#> $l_prot_perceived_gbv
#> [1] "never"        "once_twice"   "several_time" "always"       "dnk"         
#> [6] "pnta"        
#> 
#> $l_prot_perceived_risk
#> [1] "never"                "a_little_concerned"   "moderately_concerned"
#> [4] "very_concerned"       "pnta"                
#> 
#> $l_prot_services_availability
#>  [1] "children_safe_space"                          
#>  [2] "children_separation_services"                 
#>  [3] "ftr"                                          
#>  [4] "psychosocial_support"                         
#>  [5] "legal_aid"                                    
#>  [6] "birth_registration"                           
#>  [7] "mine_risk_education"                          
#>  [8] "referral"                                     
#>  [9] "psychosocial_support_women_girls"             
#> [10] "recreational_activities_organized_women_girls"
#> [11] "reproductive_health_services_women_girls"     
#> [12] "women_girls_violences_services"               
#> [13] "none"                                         
#> [14] "dnk"                                          
#> [15] "pnta"                                         
#> 
#> $l_responsible_chore
#> [1] "elderly_women" "elderly_men"   "adult_women"   "adult_men"    
#> [5] "girls"         "boys"          "pnta"         
#> 
#> $l_sanqol
#> [1] "never"     "sometimes" "always"   
#> 
#> $l_satisfaction
#> [1] "completely_satisfied"    "mostly_satisfied"       
#> [3] "somewhat_satisfied"      "mostly_dissatisfied"    
#> [5] "completely_dissatisfied" "dnk"                    
#> [7] "pnta"                   
#> 
#> $l_serious_problem
#>  [1] "hesper_drinking_water"    "hesper_food"             
#>  [3] "hesper_shelter"           "hesper_toilet"           
#>  [5] "hesper_clean"             "hesper_clean_women"      
#>  [7] "hesper_clothes_etc"       "hesper_income_livelihood"
#>  [9] "hesper_health"            "hesper_health_care_men"  
#> [11] "hesper_health_care_women" "hesper_distress"         
#> [13] "hesper_safety"            "hesper_education"        
#> [15] "hesper_care"              "hesper_support"          
#> [17] "hesper_separation"        "hesper_displaced"        
#> [19] "hesper_information"       "hesper_aid"              
#> [21] "hesper_respect"           "hesper_movement"         
#> [23] "hesper_time"              "hesper_law"              
#> [25] "hesper_gbv"               "hesper_drug"             
#> [27] "hesper_mental_health"     "hesper_care_community"   
#> [29] "hesper_other"             "dnk"                     
#> [31] "pnta"                    
#> 
#> $l_setting
#> [1] "rural"         "urban"         "camp_formal"   "camp_informal"
#> 
#> $l_snfi_essential_items_missing
#> [1] "none"          "mosquite_nets" "shoes"         "tools_repair" 
#> [5] "other"         "dnk"           "pnta"         
#> 
#> $l_snfi_fds
#> [1] "yes"  "no"   "pnta"
#> 
#> $l_snfi_fds_cooking
#> [1] "yes"     "no"      "no_need" "pnta"   
#> 
#> $l_snfi_fds_cooking_issue
#> [1] "lack_materials"         "lack_access_facilities" "unsafe"                
#> [4] "inadequate_space"       "lack_space"             "lack_fuel"             
#> [7] "lack_water"             "other"                  "pnta"                  
#> 
#> $l_snfi_fds_sleeping_issue
#> [1] "lack_materials"        "lack_space"            "unsafe_infrastructure"
#> [4] "safety_concern"        "inadequate_space"      "other"                
#> [7] "pnta"                 
#> 
#> $l_snfi_fds_storing_issue
#> [1] "lack_containers_water" "lack_containers_food"  "lack_space_water"     
#> [4] "lack_space_food"       "cannot_store_safely"   "lack_water_tanks"     
#> [7] "other"                 "pnta"                 
#> 
#> $l_snfi_shelter_damage
#>  [1] "none"           "minor_roof"     "major_roof"     "windows_doors" 
#>  [5] "floors"         "walls"          "total_collapse" "other"         
#>  [9] "dnk"            "pnta"          
#> 
#> $l_snfi_shelter_damage_barriers_repairs
#> [1] "cannot_afford_labor"      "cannot_afford_materials" 
#> [3] "materials_unavailable"    "shelter_too_damaged"     
#> [5] "skills_labor_unavailable"
#> 
#> $l_snfi_shelter_damage_cause
#> [1] "earthquake"                          
#> [2] "flood"                               
#> [3] "other_disasters"                     
#> [4] "degradation"                         
#> [5] "lack of maintenance"                 
#> [6] "damaged_accidentally_during_conflict"
#> [7] "burnt_intentionally"                 
#> [8] "other"                               
#> 
#> $l_snfi_shelter_damage_when
#> [1] "last_week"          "last_month"         "1_to_6_months"     
#> [4] "6_months_to_1_year" "more_than_1_year"   "dnk"               
#> [7] "pnta"              
#> 
#> $l_snfi_shelter_issue
#>  [1] "none"               "lack_privacy"       "lack_space"        
#>  [4] "temperature"        "ventilation"        "vectors"           
#>  [7] "no_natural_light"   "leak"               "lock"              
#> [10] "lack_lighting"      "difficulty_move"    "lack_space_laundry"
#> [13] "other"              "dnk"                "pnta"              
#> 
#> $l_snfi_shelter_type
#> [1] "collective_center"  "individual_shelter" "hosted"            
#> [4] "hosting"            "none"               "pnta"              
#> 
#> $l_snfi_shelter_type_collective
#> [1] "public_building"         "religious_building"     
#> [3] "warehouse_other_private" "other"                  
#> 
#> $l_snfi_shelter_type_individual
#> [1] "house"               "apartment"           "unfinished_building"
#> [4] "tent"                "makeshift"           "other"              
#> [7] "dnk"                 "pnta"               
#> 
#> $l_survey_modality
#> [1] "remote"    "in_person"
#> 
#> $l_wash_bathing_facility_issue
#>  [1] "no_issue"                        "lack_bathing_facilities_crowded"
#>  [3] "bathing_not_functioning"         "bathing_unclean_unhygienic"     
#>  [5] "bathing_not_private"             "bathing_not_segregated_gender"  
#>  [7] "bathing_too_far"                 "bathing_difficult_access"       
#>  [9] "bathing_dangerous_access"        "groups_no_access_bathing"       
#> [11] "disabilities_no_access_bathing"  "other"                          
#> [13] "dnk"                             "pnta"                           
#> 
#> $l_wash_chl_actions_sick
#>  [1] "self_medication_traditional" "self_medication_modern"     
#>  [3] "go_health_centre"            "go_cholera_treatment_unit"  
#>  [5] "use_ors"                     "use_homemade_sss"           
#>  [7] "home_remedy_specify"         "do_not_treat"               
#>  [9] "go_traditional_healer"       "go_religious_healer"        
#> [11] "go_pharmacy"                 "other"                      
#> [13] "dnk"                         "pnta"                       
#> 
#> $l_wash_chl_health_actions
#> [1] "nothing_dont_know"       "nothing_cant"           
#> [3] "give_water"              "give_ors"               
#> [5] "go_health_centre"        "call_traditional_healer"
#> [7] "go_orp"                  "dnk"                    
#> [9] "other"                  
#> 
#> $l_wash_chl_health_practices
#>  [1] "store_water_safely"          "boil_treat_water"           
#>  [3] "wash_hands_soap"             "wash_fruits_vegetables"     
#>  [5] "cook_food_well"              "cover_food"                 
#>  [7] "breastfeed_babies"           "clean_utensils"             
#>  [9] "clean_home_broom_water"      "clean_home_disinfectant"    
#> [11] "use_toilet"                  "dispose_child_faeces_toilet"
#> [13] "bury_faeces"                 "receive_vaccine"            
#> [15] "prayers"                     "dnk"                        
#> [17] "other"                      
#> 
#> $l_wash_chl_info_src
#> [1] "radio"                       "clinician_healthcare_worker"
#> [3] "family_member"               "community_health_worker"    
#> [5] "tv"                          "neighbour_friend"           
#> [7] "community_meeting"           "religious_leader"           
#> [9] "other"                      
#> 
#> $l_wash_chl_origin
#> [1] "foreigners_dumping_rubbish" "god_decides"               
#> [3] "comes_with_rain"            "stool"                     
#> [5] "from_sea"                   "other"                     
#> [7] "dnk"                        "pnta"                      
#> 
#> $l_wash_chl_ors_preparation
#> [1] "water"              "safe_water"         "sugar"             
#> [4] "salt"               "teaspoons_6_sugar"  "half_teaspoon_salt"
#> [7] "other"             
#> 
#> $l_wash_chl_transmission
#>  [1] "contact_cholera_patient" "contact_deceased"       
#>  [3] "contact_faeces"          "dirty_hands"            
#>  [5] "air"                     "flies"                  
#>  [7] "mosquitoes"              "contaminated_water"     
#>  [9] "contaminated_food"       "touching_surfaces"      
#> [11] "open_defecation"         "dust_powder"            
#> [13] "same_cup"                "same_plate"             
#> [15] "shaking_hands"           "witchcraft"             
#> [17] "other"                   "dnk"                    
#> [19] "pnta"                   
#> 
#> $l_wash_drinking_water_acceptable
#> [1] "yes_acceptable"         "no_unacceptable_taste"  "no_unacceptable_colour"
#> [4] "no_unacceptable_smell"  "no_contains_materials"  "no_other_specify"      
#> [7] "dnk"                   
#> 
#> $l_wash_drinking_water_quantity
#> [1] "yes_once"  "no_always" "dnk"      
#> 
#> $l_wash_drinking_water_source
#>  [1] "piped_dwelling"       "piped_compound"       "piped_neighbour"     
#>  [4] "tap"                  "borehole"             "protected_well"      
#>  [7] "unprotected_well"     "well_spring"          "unprotected_spring"  
#> [10] "rainwater_collection" "tank_truck"           "cart_tank"           
#> [13] "kiosk"                "bottled_water"        "sachet_water"        
#> [16] "surface_water"        "other"                "dnk"                 
#> [19] "pnta"                
#> 
#> $l_wash_drinking_water_store_insufficient_yn
#> [1] "yes_at_least_once" "no"                "dnk"              
#> 
#> $l_wash_drinking_water_store_small_containers
#> [1] "water_not_stored_small_containers" "water_stored_covered_containers"  
#> [3] "water_stored_uncovered_containers" "unable_to_observe"                
#> 
#> $l_wash_drinking_water_supplied_hours
#> [1] "hours_24_per_day"          "hours_18_24_per_day"      
#> [3] "hours_12_17_per_day"       "hours_6_11_per_day"       
#> [5] "less_than_6_hours_per_day" "dnk"                      
#> 
#> $l_wash_drinking_water_time_sl
#> [1] "5min_or_less"  "5min_15min"    "15min_30min"   "30min_1hr"    
#> [5] "more_than_1hr" "dnk"           "pnta"         
#> 
#> $l_wash_drinking_water_time_yn
#> [1] "water_in_dwelling" "water_in_plot"     "number_minutes"   
#> [4] "dnk"               "pnta"             
#> 
#> $l_wash_drinking_water_treatment
#>  [1] "boil"      "bleach"    "aqua_taps" "strain"    "filter"    "solar"    
#>  [7] "settle"    "other"     "dnk"       "pnta"     
#> 
#> $l_wash_handwashing_facility
#> [1] "available_fixed_in_dwelling" "available_fixed_in_plot"    
#> [3] "available_mobile"            "none"                       
#> [5] "no_permission"               "other"                      
#> 
#> $l_wash_handwashing_facility_observed_water
#> [1] "water_available"     "water_not_available"
#> 
#> $l_wash_handwashing_facility_reported
#> [1] "fixed_dwelling" "fixed_yard"     "mobile"         "none"          
#> [5] "other"          "dnk"            "pnta"          
#> 
#> $l_wash_hwise
#> [1] "never"     "rarely"    "sometimes" "often"     "always"    "dnk"      
#> [7] "pnta"     
#> 
#> $l_wash_hygiene_adaptation
#>  [1] "no_issue"            "less_preferred_nfi"  "soap_substitutes"   
#>  [4] "buy_nfi_further"     "buy_nfi_dangerous"   "borrow_nfi"         
#>  [7] "spend_on_nfi_divert" "reduce_nfi_hygiene"  "reduce_nfi_other"   
#> [10] "other"               "dnk"                 "pnta"               
#> 
#> $l_wash_hygiene_menstrual_issue
#>  [1] "no_problem"                     "materials_too_expensive"       
#>  [3] "materials_not_available_market" "market_too_far"                
#>  [5] "market_dangerous"               "market_difficult_access"       
#>  [7] "groups_no_access_market"        "poor_quality_materials"        
#>  [9] "other"                          "dnk"                           
#> [11] "pnta"                          
#> 
#> $l_wash_hygiene_menstrual_materials
#> [1] "cloth_reusable_pads" "disposable_pads"     "tampons"            
#> [4] "menstrual_cup"       "toilet_paper"        "underwear_alone"    
#> [7] "other"              
#> 
#> $l_wash_hygiene_menstrual_missed_activities
#> [1] "attending_school"                "paid_work"                      
#> [3] "participating_social_activities" "cooking_food"                   
#> [5] "eating_with_others"              "bathing_regular_place"          
#> [7] "no_activity_missed"             
#> 
#> $l_wash_hygiene_menstrual_place
#> [1] "clean"          "private"        "safe"           "supplied_water"
#> [5] "supplied_soap"  "dnk"           
#> 
#> $l_wash_hygiene_menstrual_preferred
#>  [1] "no_preference"    "disposable_pad"   "reusable_pad"     "reusable_cloth"  
#>  [5] "tampon"           "cotton"           "menstrual_cup"    "layers_underwear"
#>  [9] "other"            "dnk"              "pnta"            
#> 
#> $l_wash_hygiene_nfi
#>  [1] "no_hygiene_items_needed" "broom"                  
#>  [3] "bucket"                  "detergent_bleach"       
#>  [5] "drinking_plastic_jug"    "gloves"                 
#>  [7] "hair_comb"               "jerrycan_10l"           
#>  [9] "jerrycan_20l"            "laundry_powder"         
#> [11] "lice_shampoo"            "mop"                    
#> [13] "nail_cutter"             "nose_mask"              
#> [15] "plastic_jar_1l"          "plastic_shovel"         
#> [17] "powder_soap"             "razor"                  
#> [19] "sanitary_pads"           "shampoo_adult"          
#> [21] "soap"                    "tooth_brush"            
#> [23] "tooth_paste"             "towel"                  
#> [25] "waste_bin"               "other"                  
#> [27] "dnk"                     "pnta"                   
#> 
#> $l_wash_person_fetch
#> [1] "adult_woman" "adult_man"   "girl"        "boy"        
#> 
#> $l_wash_piped_supply
#> [1] "large_piped_network_utility"    "small_piped_network_community" 
#> [3] "small_piped_network_households"
#> 
#> $l_wash_sanitation_access_features
#>  [1] "door"                       "walls_protect_privacy"     
#>  [3] "lock_close_door"            "inside_light"              
#>  [5] "outside_light"              "separate_facilities_gender"
#>  [7] "close_to_dwelling"          "none_of_the_above"         
#>  [9] "dnk"                        "pnta"                      
#> 
#> $l_wash_sanitation_access_issue
#>  [1] "no_problem"                         "lack_sanitation_facilities_crowded"
#>  [3] "sanitation_not_functioning_full"    "sanitation_unclean_unhygienic"     
#>  [5] "sanitation_not_private"             "sanitation_not_segregated_gender"  
#>  [7] "sanitation_too_far"                 "sanitation_difficult_access"       
#>  [9] "sanitation_dangerous_access"        "groups_no_access_sanitation"       
#> [11] "disabilities_no_access_sanitation"  "other"                             
#> [13] "dnk"                                "pnta"                              
#> 
#> $l_wash_sanitation_adaptation
#>  [1] "no_issue"                      "less_preferred_sanitation"    
#>  [3] "communal_sanitation"           "defecate_plastic_bag"         
#>  [5] "defecate_open"                 "sanitation_further_than_usual"
#>  [7] "sanitation_dangerous_place"    "sanitation_night"             
#>  [9] "other"                         "dnk"                          
#> [11] "pnta"                         
#> 
#> $l_wash_sanitation_dispose_garbage
#> [1] "collected_formal_service"   "collected_informal_service"
#> [3] "disposed_designated_area"   "disposed_household_yard"   
#> [5] "buried_burned"              "disposed_elsewhere"        
#> [7] "dnk"                       
#> 
#> $l_wash_sanitation_dispose_water
#> [1] "sink_sewer"                 "sink_septic_tank"          
#> [3] "sink_pit"                   "sink_soak_pit"             
#> [5] "sink_open_drain_ground"     "disposed_open_ground_water"
#> [7] "na_away_from_household"     "dnk"                       
#> 
#> $l_wash_sanitation_emptied_where
#> [1] "removed_offsite"               "removed_waterbody_open_ground"
#> [3] "buried_covered_pit_in_situ"    "buried_covered_pit_offsite"   
#> [5] "buried_uncovered_pit"          "other"                        
#> [7] "dnk"                           "pnta"                         
#> 
#> $l_wash_sanitation_emptied_who
#> [1] "public_municipality_government" "private_company_ngo"           
#> [3] "informal_emptier"               "self_emptied"                  
#> [5] "neighbour_family_friend"        "other"                         
#> [7] "dnk"                            "pnta"                          
#> 
#> $l_wash_sanitation_emptied_yn
#> [1] "yes"                      "never"                   
#> [3] "not_emptied_covered_full" "dnk"                     
#> [5] "pnta"                    
#> 
#> $l_wash_sanitation_environment
#> [1] "never_visible"      "sometimes_visible"  "frequently_visible"
#> [4] "dnk"                "pnta"              
#> 
#> $l_wash_sanitation_excreta_released
#> [1] "overflowed"                  "flooded"                    
#> [3] "containment_collapsed"       "other_event_excreta_release"
#> [5] "none_of_the_above"           "other"                      
#> [7] "dnk"                        
#> 
#> $l_wash_sanitation_facility
#>  [1] "flush_piped_sewer"        "flush_septic_tank"       
#>  [3] "flush_pit_latrine"        "flush_open_drain"        
#>  [5] "flush_dnk_where"          "pit_latrine_slab"        
#>  [7] "pit_latrine_wo_slab"      "twin_pit_latrine_slab"   
#>  [9] "twin_pit_latrine_wo_slab" "compost"                 
#> [11] "bucket"                   "other_container"         
#> [13] "hanging_toilet"           "none"                    
#> [15] "other"                   
#> 
#> $l_wash_sanitation_facility_leak
#> [1] "no_never"       "yes_sometimes"  "yes_frequently" "dnk"           
#> 
#> $l_wash_sanitation_facility_location
#> [1] "own_dwelling"  "own_yard_plot" "elsewhere"    
#> 
#> $l_wash_sanitation_outlet_pipe
#> [1] "yes"                         "no_infiltrating_underground"
#> [3] "dnk"                         "pnta"                       
#> 
#> $l_wash_sanitation_outlet_pipe_where
#> [1] "to_leach_field_soak_pit" "to_sewer_wwtp"          
#> [3] "to_sewer_waterbody"      "to_sewer_unknown"       
#> [5] "to_open_drain"           "to_waterbody_surface"   
#> [7] "other"                   "dnk"                    
#> [9] "pnta"                   
#> 
#> $l_wash_sanitation_septic_discharge
#> [1] "to_leach_field_soak_pit"    "to_sewer"                  
#> [3] "to_open_drain"              "to_open_ground_watercourse"
#> [5] "other"                     
#> 
#> $l_wash_sanitation_sharing_public
#> [1] "shared_known_households" "shared_general_public"  
#> 
#> $l_wash_sanitation_toilet_risks
#> [1] "no_risks"        "risk_health"     "risk_harassment" "other"          
#> 
#> $l_wash_sanitation_use_toilet_reason
#> [1] "limited_mobility_prevents_use"    "distance_barriers_prevent_access"
#> [3] "toilet_not_always_available"      "toilet_not_always_safe"          
#> [5] "other"                           
#> 
#> $l_wash_soap_observed
#> [1] "soap_available"     "soap_not_available"
#> 
#> $l_wash_soap_type
#> [1] "soap"         "detergent"    "ash_mud_sand" "other"        "dnk"         
#> [6] "pnta"        
#> 
#> $l_wash_water_access_issue
#>  [1] "no_problem_access_water"              
#>  [2] "waterpoints_too_far"                  
#>  [3] "water_source_not_functional"          
#>  [4] "waterpoints_difficult_use"            
#>  [5] "intermittent_infrequent_service"      
#>  [6] "disability_no_access_waterpoints"     
#>  [7] "safety_concerns_waterpoints"          
#>  [8] "safety_concerns_travel_waterpoints"   
#>  [9] "groups_no_access_waterpoints"         
#> [10] "excessive_waiting_time_waterpoints"   
#> [11] "waterpoints_not_functioning_closed"   
#> [12] "water_not_available_market"           
#> [13] "water_too_expensive"                  
#> [14] "not_enough_containers"                
#> [15] "poor_water_quality_taste_colour_odour"
#> [16] "other"                                
#> [17] "dnk"                                  
#> [18] "pnta"                                 
#> 
#> $l_wash_water_adaptation
#>  [1] "no_issue"                "less_preferred_drinking"
#>  [3] "surface_water_drinking"  "less_preferred_other"   
#>  [5] "surface_water_other"     "fetch_water_further"    
#>  [7] "children_fetch_water"    "dangerous_water_source" 
#>  [9] "spend_on_water_divert"   "reduce_drinking_water"  
#> [11] "reduce_water_other"      "other"                  
#> [13] "dnk"                     "pnta"                   
#> 
#> $l_wash_water_availability_issue
#> [1] "water_not_available_source" "water_too_expensive"       
#> [3] "source_not_accessible"      "other"                     
#> 
#> $l_wash_water_availability_yn
#> [1] "yes_always_available" "no_most_of_time"      "no_some_of_time"     
#> [4] "no_rarely_available"  "dnk"                 
#> 
#> $l_wgss_difficulty
#> [1] "no_difficulty"       "some_difficulty"     "a_lot_of_difficulty"
#> [4] "cannot_do_at_all"    "pnta"                "dnk"                
#> 
#> $l_yn
#> [1] "yes" "no" 
#> 
#> $l_yn_dnk_pnta
#> [1] "yes"  "no"   "dnk"  "pnta"
#> 

# Options for a specific list
xlsform_choices(form)[["yn"]]
#> NULL
```
