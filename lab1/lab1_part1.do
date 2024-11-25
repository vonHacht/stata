// lab1 part 1
clear

log using "/home/ulla/Git/stata/lab1/lab1_part1.log", replace text

cd "/home/ulla/Git/stata/lab1"
use training_results.dta
describe

// 1. Summarize statistics
summarize

// good pysique could be converted to a binary value e.g. Yes = 1 and No = 0
// which we would be able to summarize
// ...

// 2. Scatter plot & correlate
twoway scatter season_score hours_trained 
correlate season_score hours_trained

// season score and hours trained have
// a small negative correlation indicating
// that more training does not always effect the
// goals scored in a positive way. 
// (Maybe more training exhausts players
// and lessen the energy to score in matches)

// 3. OLS regressor
regress season_score hours_trained

// Season score = 71.89 + -0.35*Hours trained + ui
// B0 - if hours trained is equal to 0 the season scored for a 
// player is assumed to be 71.89, the intercept
// B1 - hours trained would decrease the season scored
// by approx -0.35 * amount of hours trained, average change
// in the dependent variable

// 4. Null hypothesis
// Does training hours affect season scored
// H0 - training hours does not affect season scored 
// H1 - training hours does affect season scored

// 1. t-value: Coefficient/( Std. err(Coefficient) )
// 2. degrees of freedom: 500 observations - 2(for out case)
// 3. Look into t-distribution table

// Check H0
// 0.000 < 0.01
// => reject the null hypothesis
// Check H1
// 0.012 => 1.2 %
// 1.2% > 1%
// 1.2% < 5%, statistically significant

// => training does have a small negative effect on seasons scored

// 5. New training columns
// Heavy training 38.506 + 3.273438 (1 std dev)
// Normal training 38.506
// Little training 38.506 - 3.273438 (1 std dev)

generate training_category = .
replace training_category = 1 if hours_trained <= 35
replace training_category = 2 if hours_trained > 35 & hours_trained < 42
replace training_category = 3 if hours_trained >= 42
label define training_labels 1 "Little" 2 "Normal" 3 "Heavy"
label values training_category training_labels

regress season_score i.training_category


// Season score = 60.21 + -2.4*Normal + -3.12*Heavy + ui
// Heavy: statistically significant at 5% but not 1%
// Normal: marginally significant at 5%

// 6. Not casual estimate
// * Omitted Variable Bias
//	Omitted variables not seen in correlation with the dependent variables
//	season scored and independent variable training could violate then
//	assumption of no omitted variable bias and be a source of endogenity.
// * Reverse Causality
//	If players that score many goals are assigned to little training
//	and vice verse it could lead to a reverse causality and violate
//	the assumption of that independent variables is exogenous and 
//	thus endogenious.

// 7. Physical state

generate physical_state = .
replace physical_state = 1 if (good_pysique_post_summer == "Yes")
replace physical_state = 0 if (good_pysique_post_summer == "No")

regress season_score hours_trained physical_state

// 8. 
// There could still be omitted variables such as self-confidence measurement
// If players score many goals they could be assigned to fewer training hours_trained

// 9.

// Calculate ATE
mean season_score, over(new_method) //  58.33333 - 57.92829


// With new method
regress season_score new_method // coefficient 0.4050465


log close
