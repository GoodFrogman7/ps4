* ECON 306 Problem Set 4
* AI used: Muse, for all sections (variable creation, replication, measurement
* error, logarithms, and both F-tests). Each AI-assisted section is marked below.
* Data: CAschool_PS4_AI.dta (420 districts)

log using PS4, replace

use CAschool_PS4_AI.dta, clear

* Section 1: Creating Variables
*AI helped
rename income income_original
gen income_str = income_original
replace income_str = subinstr(income_str, ",", "", .)
replace income_str = subinstr(income_str, " dollars USD", "", .)
replace income_str = subinstr(income_str, " dollars", "", .)
destring income_str, replace
gen income = income_str / 1000
drop income_str
gen income2 = income^2
gen income3 = income^3
gen ln_income = ln(income)
gen math_lower = (math_scr < read_scr)
* students is not stored directly. str is the student-teacher ratio, students
* per teacher, so students = teachers x str.
destring teachers, replace
gen students = teachers * str
gen ln_testscore = ln(testscore)
gen HiSTR = (str >= 20)
gen HiEL = (el_pct >= 10)
*AI helped

* Section 2: Replication
*AI helped
twoway scatter testscore income || lfit testscore income || qfit testscore income
*AI helped
regress testscore income income2, robust
display e(r2)
display e(r2_a)
* 8.2: 607.3017 + 3.8510 income - 0.0423 income2, R2 = 0.5562
*AI helped
regress testscore income income2 income3, robust
display e(r2)
display e(r2_a)
* 8.11: 600.0790 + 5.0187 income - 0.0958 income2 + 0.000685 income3, R2 = 0.5584
*AI helped
regress testscore ln_income, robust
display e(r2)
display e(r2_a)
* 8.18: 557.8323 + 36.4197 ln_income, R2 = 0.5625
*AI helped
regress ln_testscore ln_income, robust
display e(r2)
display e(r2_a)
* 8.23: 6.3363 + 0.0554 ln_income, R2 = 0.5578
*AI helped
gen HiSTR_HiEL = HiSTR * HiEL
regress testscore HiSTR HiEL HiSTR_HiEL, robust
display e(r2)
display e(r2_a)
* 8.30: 664.1433 - 1.9078 HiSTR - 18.1629 HiEL - 3.4943 HiSTR_HiEL, R2 = 0.2956
*AI helped

* Section 3: Measurement Error
*AI helped
regress testscore students income, robust
display e(r2)
display e(r2_a)
* 3a: 627.4154 - 0.000849 students + 1.8916 income, R2 = 0.5379
*AI helped
regress testscore noisy_students income, robust
display e(r2)
display e(r2_a)
* 3b: 627.3538 - 0.000782 noisy_students + 1.8886 income, R2 = 0.5346
*AI helped
regress noisy_testscore noisy_students income, robust
display e(r2)
display e(r2_a)
* 3c: 630.1885 - 0.000375 noisy_students + 1.5853 income, R2 = 0.1173
*AI helped

* Section 4: Logarithms
*AI helped
regress testscore students ln_income, robust
display e(r2)
display e(r2_a)
* 4a: 558.6545 - 0.001005 students + 37.1080 ln_income, R2 = 0.6049
*AI helped
gen ln_students = ln(students)
regress ln_testscore ln_students ln_income, robust
display e(r2)
display e(r2_a)
* 4b: 6.3647 - 0.005053 ln_students + 0.0581 ln_income, R2 = 0.6135
*AI helped

* Section 5: F test in Stata
*AI helped
* Classical standard errors here so the Stata F matches the by-hand F in section 6.
regress testscore students income income2 income3 math_lower teachers expn_stu comp_stu el_pct
test students income2 income3 teachers expn_stu
* F(5, 410) = 6.9344, p = 0.000003: reject. The 5 variables are jointly significant.
*AI helped

* Section 6: F test by hand, alpha = 0.01
*AI helped
regress testscore math_lower income comp_stu el_pct
scalar rss_r = e(rss)
regress testscore students income income2 income3 math_lower teachers expn_stu comp_stu el_pct
scalar rss_u = e(rss)
scalar F = ((rss_r - rss_u) / 5) / (rss_u / 410)
display "RSS unrestricted = " rss_u
display "RSS restricted = " rss_r
display "F statistic = " F
display "Critical value at 1% = " invF(5, 410, 0.99)
* RSSu = 39439.51, RSSr = 42774.73, F = 6.9344, critical value = 3.0621: reject.
*AI helped

log close
translate PS4.smcl PS4.pdf
