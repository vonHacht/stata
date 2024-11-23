// lab0

cd "/home/ulla/Git/stata/lab0"
use stataintro_data.dta, clear
describe

destring hours, replace


generate female = (sex == "F")

count if !missing(female)
count if !missing(sex)

generate x = 1
pause
list x
