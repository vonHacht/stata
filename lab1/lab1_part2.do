// lab1
clear

log using "/home/ulla/Git/stata/lab1/lab1_part2.log", replace text

cd "/home/ulla/Git/stata/lab1"
use colonial_legacy.dta, clear
describe

// summarize statistics
summarize

local controls ///
    child_age_cont child_age_cont2 b4 hv007 hv025 elev LATNUM ///
    LONGNUM mean_temp mean_rain land_suit malaria_ecology tsi_grid_tsi ///
    atlantic_all_years dist_missions

// 10. OLS model    
    
regress vaccination_index times_visited `controls'

// vaccination index = -8 + -0.07*times visited + control + ui
// beta 1: ...


// 14. First & Second stage equations
// First stage: times_visited = a_0 + a_1 * relative_suitability + control + error term
// Second stage: vaccination_index = beta_0 + beta_1 * relative_suitability + control + error term

ivregress 2sls vaccination_index (times_visited = relative_suitability) ///
    `controls', robust



log close
