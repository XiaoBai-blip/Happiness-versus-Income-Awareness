set more off
clear *

********************************************************************
*********     PREPARE NORWEGIAN MONITOR SURVEY DATA      ***********
********************************************************************

use "Raw Norwegian Monitor Survey Data", clear

** Impute HH Income
gen z1=.
gen z2=.
replace z1=0 if q291==1
replace z2=100000 if q291==1
replace z1=100000 if q291==2
replace z2=200000 if q291==2
replace z1=200000 if q291==3
replace z2=300000 if q291==3
replace z1=300000 if q291==4
replace z2=400000 if q291==4
replace z1=400000 if q291==5
replace z2=500000 if q291==5
replace z1=500000 if q291==6
replace z2=600000 if q291==6
replace z1=600000 if q291==7
replace z2=800000 if q291==7
replace z1=800000 if q291==8
replace z2=1000000 if q291==8
replace z1=1000000 if q291==9
replace z2=. if q291==9

replace z1=0 if h95_97==1
replace z2=100000 if h95_97==1
replace z1=100000 if h95_97==2
replace z2=200000 if h95_97==2
replace z1=200000 if h95_97==3
replace z2=300000 if h95_97==3
replace z1=300000 if h95_97==4
replace z2=400000 if h95_97==4
replace z1=400000 if h95_97==5
replace z2=500000 if h95_97==5
replace z1=500000 if h95_97==6
replace z2=600000 if h95_97==6
replace z1=600000 if h95_97==7
replace z2=800000 if h95_97==7
replace z1=800000 if h95_97==8
replace z2=. if h95_97==8

replace z1=0 if h85_93==1
replace z2=60000 if h85_93==1
replace z1=60000 if h85_93==2
replace z2=100000 if h85_93==2
replace z1=100000 if h85_93==3
replace z2=160000 if h85_93==3
replace z1=160000 if h85_93==4
replace z2=200000 if h85_93==4
replace z1=200000 if h85_93==5
replace z2=300000 if h85_93==5
replace z1=300000 if h85_93==6
replace z2=400000 if h85_93==6
replace z1=400000 if h85_93==7
replace z2=500000 if h85_93==7
replace z1=500000 if h85_93==8
replace z2=. if h85_93==8
replace z1=log(z1)
replace z2=log(z2)
gen raw_hh_income=.
forvalues year=1985(2)2013 {
intreg z1 z2 if year==`year'
predict aux_hh_income if year==`year', e(z1, z2)
replace aux_hh_income=. if q291==. & h85_93==. & h95_97==.
replace raw_hh_income=exp(aux_hh_income) if year==`year' 
drop aux_hh_income 
}

gen imp_hh_income=.
forvalues year=1985(2)2013 {
intreg z1 z2 i.education i.marital i.age i.hh_size i.region female if year==`year'
predict aux_hh_income if year==`year', e(z1, z2)
replace aux_hh_income=. if q291==. & h85_93==. & h95_97==.
replace imp_hh_income=exp(aux_hh_income) if year==`year' 
drop aux_hh_income 
}

drop z1 z2

** Alternative Imputation for Robustness check: ignoring top income category
gen z1=.
gen z2=.
replace z1=0 if q291==1
replace z2=100000 if q291==1
replace z1=100000 if q291==2
replace z2=200000 if q291==2
replace z1=200000 if q291==3
replace z2=300000 if q291==3
replace z1=300000 if q291==4
replace z2=400000 if q291==4
replace z1=400000 if q291==5
replace z2=500000 if q291==5
replace z1=500000 if q291==6
replace z2=600000 if q291==6
replace z1=600000 if q291==7
replace z2=800000 if q291==7
replace z1=800000 if q291==8 | q291==9
replace z2=. if q291==8 | q291==9

replace z1=0 if h95_97==1
replace z2=100000 if h95_97==1
replace z1=100000 if h95_97==2
replace z2=200000 if h95_97==2
replace z1=200000 if h95_97==3
replace z2=300000 if h95_97==3
replace z1=300000 if h95_97==4
replace z2=400000 if h95_97==4
replace z1=400000 if h95_97==5
replace z2=500000 if h95_97==5
replace z1=500000 if h95_97==6
replace z2=600000 if h95_97==6
replace z1=600000 if h95_97==7
replace z2=800000 if h95_97==7
replace z1=800000 if h95_97==8
replace z2=. if h95_97==8

replace z1=0 if h85_93==1
replace z2=60000 if h85_93==1
replace z1=60000 if h85_93==2
replace z2=100000 if h85_93==2
replace z1=100000 if h85_93==3
replace z2=160000 if h85_93==3
replace z1=160000 if h85_93==4
replace z2=200000 if h85_93==4
replace z1=200000 if h85_93==5
replace z2=300000 if h85_93==5
replace z1=300000 if h85_93==6
replace z2=400000 if h85_93==6
replace z1=400000 if h85_93==7
replace z2=500000 if h85_93==7
replace z1=500000 if h85_93==8
replace z2=. if h85_93==8
replace z1=log(z1)
replace z2=log(z2)
gen alt_imp_hh_income=.
forvalues year=1985(2)2013 {
intreg z1 z2 i.education i.marital i.age i.hh_size i.region female if year==`year'
predict aux_hh_income if year==`year', e(z1, z2)
replace aux_hh_income=. if q291==. & h85_93==. & h95_97==.
replace alt_imp_hh_income=exp(aux_hh_income) if year==`year' 
drop aux_hh_income 
}
drop z1 z2
 

foreach var in imp_hh_income {
gen adj_`var'=.
replace adj_`var'=`var'* 134.9/62.6 if  year==1985
replace adj_`var'=`var'* 134.9/68 if  year==1986
replace adj_`var'=`var'* 134.9/73.3 if  year==1987
replace adj_`var'=`var'* 134.9/78 if  year==1988
replace adj_`var'=`var'* 134.9/81.2 if  year==1989
replace adj_`var'=`var'* 134.9/84.4 if  year==1990
replace adj_`var'=`var'* 134.9/87.3 if  year==1991
replace adj_`var'=`var'* 134.9/89.1 if  year==1992
replace adj_`var'=`var'* 134.9/91 if  year==1993
replace adj_`var'=`var'* 134.9/92.5 if  year==1994
replace adj_`var'=`var'* 134.9/94.7 if  year==1995
replace adj_`var'=`var'* 134.9/95.9 if  year==1996
replace adj_`var'=`var'* 134.9/98.1 if  year==1997
replace adj_`var'=`var'* 134.9/100.5 if  year==1998
replace adj_`var'=`var'* 134.9/102.6 if  year==1999
replace adj_`var'=`var'* 134.9/106.2 if  year==2000
replace adj_`var'=`var'* 134.9/108.7 if  year==2001
replace adj_`var'=`var'* 134.9/110.2 if  year==2002
replace adj_`var'=`var'* 134.9/112.5 if  year==2003
replace adj_`var'=`var'* 134.9/113.7 if  year==2004
replace adj_`var'=`var'* 134.9/116 if  year==2005
replace adj_`var'=`var'* 134.9/119 if  year==2006
replace adj_`var'=`var'* 134.9/118.6 if  year==2007
replace adj_`var'=`var'* 134.9/124.9 if  year==2008
replace adj_`var'=`var'* 134.9/126.4 if  year==2009
replace adj_`var'=`var'* 134.9/128.6 if  year==2010
replace adj_`var'=`var'* 134.9/130.6 if  year==2011
replace adj_`var'=`var'* 134.9/131.2 if  year==2012
replace adj_`var'=`var'* 134.9/134.9 if  year==2013
}

bysort year: egen aux_hh_rank=rank(raw_hh_income)
bysort year: egen max_hh_rank=max(aux_hh_rank)
gen raw_hh_rank=aux_hh_rank/max_hh_rank
drop aux_hh_rank max_hh_rank

bysort year: egen aux_hh_rank=rank(imp_hh_income)
bysort year: egen max_hh_rank=max(aux_hh_rank)
gen imp_hh_rank=aux_hh_rank/max_hh_rank
drop aux_hh_rank max_hh_rank

bysort year: egen aux_hh_rank=rank(alt_imp_hh_income)
bysort year: egen max_hh_rank=max(aux_hh_rank)
gen alt_imp_hh_rank=aux_hh_rank/max_hh_rank
drop aux_hh_rank max_hh_rank

* region-level rankings
bysort year region: egen aux_hh_rank=rank(imp_hh_income)
bysort year region: egen max_hh_rank=max(aux_hh_rank)
gen region_imp_hh_rank=aux_hh_rank/max_hh_rank
drop aux_hh_rank max_hh_rank

gen alt_inc_comparison=.
replace alt_inc_comparison=1 if inc_comparison<3 & inc_comparison!=.
replace alt_inc_comparison=2 if inc_comparison==3 & inc_comparison!=.
replace alt_inc_comparison=3 if inc_comparison>3 & inc_comparison!=.

* Transform subjective scores with POLS model
foreach var in happy life_sat inc_comp financial_sat {
sum `var'
local J1=`r(min)'
local J2=`r(min)'+1
local J3=`r(max)'-1
local J4=`r(max)'
forvalues j=`J1'(1)`J3' {
count if `var'<=`j'
local a=`r(N)'
count if `var'!=.
local b=`r(N)'
global u_`var'`j'=invnormal(`a'/`b')
}
gen po_`var'=.
replace po_`var'=-normalden(${u_`var'1})/normal(${u_`var'1}) if `var'==`J1'
forvalues j=`J2'(1)`J3' {
local j1=`j'-1
replace po_`var'=(normalden(${u_`var'`j1'})-normalden(${u_`var'`j'}))/(normal(${u_`var'`j'})-normal(${u_`var'`j1'})) if `var'==`j'
}
display "U4=${u_`var'4}"
replace po_`var'=normalden(${u_`var'`J3'})/(1-normal(${u_`var'`J3'})) if `var'==`J4'
}

** Standardize PO_ variables
foreach var of varlist po_* {
sum `var'
replace `var'=(`var'-`r(mean)')/`r(sd)'
}
sum year if happy!=.
gen pre_2001=(year==1997 | year==1999)
gen post_2001=(year>=2001)

* Higher Internet
set matsize 3000
reg internet_home i.marital i.education i.hh_size i.hh_workers female age age_sq if year==2001, robust
predict pred_internet, xb
bysort year: egen aux_rank_internet=rank(pred_internet)
bysort year: egen max_rank_internet=max(aux_rank_internet)
gen rank_internet=aux_rank_internet/max_rank_internet
gen lower_internet=(rank_internet<0.5) if rank_internet!=.
gen higher_internet=1-lower_internet
drop aux_rank_internet max_rank_internet

* Alternative definitions of Higher Internet
centile pred_internet
gen alt3_higher_internet=(pred_internet>=`r(c_1)') if pred_internet!=.
reg internet_home i.marital i.education i.hh_size i.hh_workers female age age_sq if year==1999, robust
predict alt1_pred_internet, xb
centile alt1_pred_internet
bysort year: egen aux_rank_internet=rank(alt1_pred_internet)
bysort year: egen max_rank_internet=max(aux_rank_internet)
gen alt1_rank_internet=aux_rank_internet/max_rank_internet
gen alt1_lower_internet=(alt1_rank_internet<0.5) if alt1_rank_internet!=.
gen alt1_higher_internet=1-alt1_lower_internet
drop alt1_lower_internet alt1_rank_internet alt1_pred_internet aux_rank_internet max_rank_internet
reg internet_home i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
predict alt2_pred_internet, xb
centile alt2_pred_internet
bysort year: egen aux_rank_internet=rank(alt2_pred_internet)
bysort year: egen max_rank_internet=max(aux_rank_internet)
gen alt2_rank_internet=aux_rank_internet/max_rank_internet
gen alt2_lower_internet=(alt2_rank_internet<0.5) if alt2_rank_internet!=.
gen alt2_higher_internet=1-alt2_lower_internet
drop alt2_rank_internet alt2_lower_internet alt2_pred_internet aux_rank_internet max_rank_internet
probit internet_home i.marital i.education i.hh_size i.hh_workers female age age_sq if year==2001, asis
predict alt4_pred_internet, pr
centile alt4_pred_internet
bysort year: egen aux_rank_internet=rank(alt4_pred_internet)
bysort year: egen max_rank_internet=max(aux_rank_internet)
gen alt4_rank_internet=aux_rank_internet/max_rank_internet
gen alt4_lower_internet=(alt4_rank_internet<0.5) if alt4_rank_internet!=.
gen alt4_higher_internet=1-alt4_lower_internet
drop alt4_lower_internet alt4_rank_internet alt4_pred_internet aux_rank_internet max_rank_internet

* Generate linear trend variable:
gen trend=year-1985

* Some labels:
label var imp_hh_rank "Income Rank"
label var higher_internet "I\{Higher Internet\}"
cap: gen po_happy=.
cap: label var po_happy "Happiness"
label var po_life_sat "Life Satisf."
cap: label var happy "Happiness"
label var life_sat "Life Satisf."
cap: label var po_inc_comp "Perc. Rank"
cap: label var po_financial_sat "Income Adequacy"
label var female "Female"
label var age "Age"
label var age_sq "Age Squared"
save norway_data_ready_to_be_analyzed, replace

********************************************************************
*********   PREPARE GERMAN SOCIE-ECONOMIC PANEL DATA     ***********
********************************************************************

use "Raw GSOEP Data", clear

ren syear year 
ren x11104ll sample
keep if sample<=22

gen aux_employed=(pgemplst==1 | pgemplst==2 | pgemplst==3)
bysort year hid: egen hh_workers=total(aux_employed)

ren l11102 region

gen years_education=d11109
replace years_education=. if years_education<0
egen education=group(years_education)
* Impute missing values
replace education=0 if education==.

gen life_sat=plh0182
replace life_sat=. if life_sat<0

gen hhinc=i11102
replace hhinc=. if hhinc<0

gen hh_size=d11106
replace hh_size=. if hh_size<1

ren hlf0169 internet_home
replace internet_home=. if internet_home==-8
replace internet_home=(internet_home==1) if internet_home!=.

gen age=d11101
replace age=48 if age<=0
gen age_sq=age^2

gen hh_head=(d11105==1)

gen female=(d11102ll==2)
replace female=. if female<0

gen marital=d11104
replace marital=. if marital<=0
replace marital=0 if marital==.

keep sample hh_head region pid hid year life_sat hhinc year marital education hh_size hh_workers female age age_sq internet_home

keep if region==1
keep if hh_head==1
drop if hhinc==. | life_sat==.

* Adjust POLS
foreach var in life_sat  {
sum `var'
local J1=`r(min)'
local J2=`r(min)'+1
local J3=`r(max)'-1
local J4=`r(max)'
forvalues j=`J1'(1)`J3' {
count if `var'<=`j'
local a=`r(N)'
count if `var'!=.
local b=`r(N)'
global u_`var'`j'=invnormal(`a'/`b')
}
gen po_`var'=.
replace po_`var'=-normalden(${u_`var'1})/normal(${u_`var'1}) if `var'==`J1'
forvalues j=`J2'(1)`J3' {
local j1=`j'-1
replace po_`var'=(normalden(${u_`var'`j1'})-normalden(${u_`var'`j'}))/(normal(${u_`var'`j'})-normal(${u_`var'`j1'})) if `var'==`j'
}
display "U4=${u_`var'4}"
replace po_`var'=normalden(${u_`var'`J3'})/(1-normal(${u_`var'`J3'})) if `var'==`J4'
}
** Standardize PO_ variables
foreach var of varlist po_* {
sum `var'
replace `var'=(`var'-`r(mean)')/`r(sd)'
}

* Income rank
bysort year: egen aux_hh_rank=rank(hhinc)
bysort year: egen max_hh_rank=max(aux_hh_rank)
gen imp_hh_rank=aux_hh_rank/max_hh_rank
drop aux_hh_rank max_hh_rank

* Gen treatment variables
gen pre_2001=(year>=1997 & year<=2000)
gen post_2001=(year>=2001)

sum po_life_sat marital education hh_workers hh_size

* Standardize categories w.r.t. Norwegian Monitor Survey
replace hh_size=5 if hh_size>5 & hh_size!=.

* Internet Variable
set matsize 3000
reg internet_home i.marital i.education i.hh_size i.hh_workers female age age_sq if year==2002, robust
predict pred_internet, xb
bysort year: egen aux_rank_internet=rank(pred_internet)
bysort year: egen max_rank_internet=max(aux_rank_internet)
gen rank_internet=aux_rank_internet/max_rank_internet
gen lower_internet=(rank_internet<0.5) if rank_internet!=.
gen higher_internet=1-lower_internet
drop aux_rank_internet max_rank_internet

drop if year<1985 | year>2013 | year==.

label var imp_hh_rank "Income Rank"
label var higher_internet "I\{Higher Internet\}"
label var po_life_sat "Life Satisf."
cap: gen po_happy=.
cap: label var po_happy "Happiness"
cap: label var po_inc_comp "Perc. Rank"
cap: label var po_financial_sat "Income Adequacy"
label var female "Female"
label var age "Age"
label var age_sq "Age Squared"
save germany_data_ready_to_be_analyzed, replace


********************************************************************
*********  PRODUCE FIGURES AND TABLES FOR BODY OF PAPER  ***********
********************************************************************

***************************************************************
** FIGURE 4
* Figure 4.a:
use google_searches_by_country, clear
graph bar google, over(keyword, label(angle(45))) over(country) scheme(s1mono) ytitle("Google Searches (relative to Youtube)", size(medium) height(5)) ylab(0 "0%" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%" 60 "60%" 70 "70%" 80 "80%" 90 "90%" 100 "100%", angle(0) nogrid)
graph export google_searches_by_country.pdf, replace
* Figure 4.b:
use google_searches_over_time, clear
egen total=rowtotal(tax weather skattelister youtube)
sum total if year==2010 &	month==1 & day==3
local normalize=`r(mean)'
foreach var in tax weather skattelister youtube {
replace `var'=`var'/`normalize'
}
tsline skattelister tax weather youtube, scheme(s1mono) /*lcolor(red green purple blue)*/ lpattern(solid dash shortdash longdash) lwidth(medthick medthick medthick medthick) tlabel(18265(28)18620, angle(45)) xtitle("Week (start date)", size(medium) height(5)) ytitle("Google Search Index", size(medium) height(5)) legend(lab(1 "Skattelister") lab(2 "Tax") lab(3 "Weather") lab(4 "Youtube") pos(12) ring(0) col(5) region(color(none))) ylab(0(0.1)1, format(%9.1f) nogrid angle(0))
graph export google_searches_over_time.pdf, replace
**
***************************************************************


***************************************************************
** FIGURE 5
* Figure 5.a:
use names_browsing_skattelister, clear
keep if date>=date("jan012010","MD20Y") & date<=date("dec312010","MD20Y")
bysort profile: gen N_profile=_N
bysort profile: gen n_profile=_n
sum N_profile if n_profile==1, det
gen trunc_N_profile=N_profile if N_profile!=.
replace trunc_N_profile=12 if N_profile>=11 & N_profile<=100
replace trunc_N_profile=14 if N_profile>=101
label define trunc_N_profile 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 12 "11-100" 14 "101+" 
label values trunc_N_profile trunc_N_profile 
hist trunc_N_profile, discrete percent scheme(s1mono)  xla(1/10 12 14, valuelabel) ylabel(0 "0%" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%" 60 "60%", angle(0)) xtitle("Number of Visits to Profile", size(medium) height(5)) ytitle("Share of All Visits", size(medium) height(5))
graph export distribution_share_profiles.pdf, replace
* Figure 5.b:
use names_browsing_skattelister, clear
keep if date==date("oct202010","MD20Y")
bysort sessionid: gen N_sessionid=_N
bysort sessionid: gen n_sessionid=_n
sum N_sessionid if n_sessionid==1, det
gen trunc_N_sessionid=N_sessionid if n_sessionid==1
replace trunc_N_sessionid=21 if N_sessionid>=20 & n_sessionid==1
label define trunc_N_sessionid 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10" 11 "11" 12 "12" 13 "13" 14 "14" 15 "15" 16 "16" 17 "17" 18 "18" 19 "19" 21 "20+" 
label values trunc_N_sessionid trunc_N_sessionid
hist trunc_N_sessionid, discrete percent scheme(s1mono) xla(1/19 21, valuelabel) ylabel(0 "0%" 5 "5%" 10 "10%" 15 "15%" 20 "20%", angle(0)) xtitle("Number of Profiles Visited per Session", size(medium) height(5)) ytitle("Share of All Sessions", size(medium) height(5))
graph export searches_by_session.pdf, replace
**
***************************************************************


***************************************************************
** FIGURE 6
use norway_data_ready_to_be_analyzed, clear
gen biennial=floor((year-1985)/4)+1
replace biennial=7 if biennial==8
reg po_happy ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estimates store all_internet
reg po_happy ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==0, robust
estimates store high_internet
reg po_happy ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==1, robust
estimates store low_internet
coefplot all_internet, vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) lcolor(purple) recast(rcap)) mcolor(purple) msymbol(O) graphregion(color(white)) plotregion(color(white)) ylabel(-0.2(.1).2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85&87" 2.biennial#c.imp_hh_rank  = "89&91" 3.biennial#c.imp_hh_rank = "93&95" 4.biennial#c.imp_hh_rank = "97&99" 5.biennial#c.imp_hh_rank = "01&03" 6.biennial#c.imp_hh_rank ="05&07" 7.biennial#c.imp_hh_rank = "09&11&13") legend(order(2 1) lab(2 "Average Effect") lab(1 "90% CI") pos(11) ring(0) col(1) region(color(none))) xline(4.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Happiness-Income Gradient", size(medium) height(5))  recast(connected) lcolor(purple) scheme(s1mono)
* Figure 6.a:
graph export event_study.pdf, replace
coefplot (low_internet,  recast(connected) lpattern(dash) lcolor(blue) ciopts(lpattern(dash) lcolor(blue)   recast(rcap)) mcolor(blue) msymbol(O)) (high_internet, recast(connected) lpattern(solid) lcolor(red)  ciopts(lpattern(dash) lcolor(red) recast(rcap)) mcolor(red) msymbol(O)), recast(connected) vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) recast(rcap)) graphregion(color(white)) plotregion(color(white)) ylabel(-.3(.1).4, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85&87" 2.biennial#c.imp_hh_rank  = "89&91" 3.biennial#c.imp_hh_rank = "93&95" 4.biennial#c.imp_hh_rank = "97&99" 5.biennial#c.imp_hh_rank = "01&03" 6.biennial#c.imp_hh_rank ="05&07" 7.biennial#c.imp_hh_rank = "09&11&13") xline(4.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Happiness-Income Gradient", size(medium) height(5)) legend(order(4 2) lab(4 "Higher Internet") lab(2 "Lower Internet") pos(11) ring(0) col(1) region(color(none))) scheme(s1mono)
* Figure 6.b:
graph export event_study_by_internet.pdf, replace
use germany_data_ready_to_be_analyzed, clear
gen biennial=floor((year-1985)/4)+1
replace biennial=7 if biennial==8
reg po_life_sat ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estimates store all_internet
reg po_life_sat ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==0, robust
estimates store high_internet
reg po_life_sat ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==1, robust
estimates store low_internet
coefplot all_internet, vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) lcolor(purple) recast(rcap)) mcolor(purple) msymbol(O) graphregion(color(white)) plotregion(color(white)) ylabel(-0.2(.1).2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85-88" 2.biennial#c.imp_hh_rank  = "89-92" 3.biennial#c.imp_hh_rank = "93-96" 4.biennial#c.imp_hh_rank = "97-00" 5.biennial#c.imp_hh_rank = "01-04" 6.biennial#c.imp_hh_rank ="05-08" 7.biennial#c.imp_hh_rank = "09-13") legend(order(2 1) lab(2 "Average Effect") lab(1 "90% CI") pos(11) ring(0) col(1) region(color(none))) xline(4.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Life Sat.-Income Gradient", size(medium) height(5))  recast(connected) lcolor(purple) scheme(s1mono)
* Figure 6.c:
graph export germany_event_study.pdf, replace
coefplot (low_internet,  recast(connected) lpattern(dash) lcolor(blue) ciopts(lpattern(dash) lcolor(blue) recast(rcap)) mcolor(blue) msymbol(O)) (high_internet, recast(connected) lpattern(solid) lcolor(red) ciopts(lpattern(dash) lcolor(red) recast(rcap)) mcolor(red) msymbol(O)), recast(connected) vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) recast(rcap)) graphregion(color(white)) plotregion(color(white)) ylabel(-.3(.1).4, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85-88" 2.biennial#c.imp_hh_rank  = "89-92" 3.biennial#c.imp_hh_rank = "93-96" 4.biennial#c.imp_hh_rank = "97-00" 5.biennial#c.imp_hh_rank = "01-04" 6.biennial#c.imp_hh_rank ="05-08" 7.biennial#c.imp_hh_rank = "09-13") xline(4.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Life Sat.-Income Gradient", size(medium) height(5))  recast(connected) lcolor(blue) legend(order(4 2) lab(4 "Higher Internet") lab(2 "Lower Internet") pos(11) ring(0) col(1) region(color(none))) scheme(s1mono)
* Figure 6.d:
graph export germany_event_study_by_internet.pdf, replace
** 
***************************************************************


***************************************************************
** TABLE 3
use norway_data_ready_to_be_analyzed, clear
eststo clear
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
local aux_period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local period "`aux_period'"
estadd local country "Norway"
estadd local test ""
eststo: quietly: reg po_happy imp_hh_rank post_2001 post_2001#c.imp_hh_rank c.trend#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank pre_2001 i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
estadd local test ""
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
use germany_data_ready_to_be_analyzed, clear
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
local aux_period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local period "`aux_period'"
estadd local country "Germany"
estadd local test ""
nlcom (bla: _b[1.post_2001#c.imp_]/_b[imp_hh_rank])
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Germany"
esttab using "main_regression_table.tex", replace booktabs se eqlabels(, none) nonotes label gap compress keep(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet c.trend#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank) order(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet c.trend#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank) stats(test country period N, fmt(%3s %3s %3s %9.0fc) labels("P-value (i)=(ii)" "\midrule Country" "Period" "Observations" )) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) varlabel(1.post_2001#c.imp_hh_rank "Income Rank * I\{2001-2013\}\$^{(i)}\$" c.trend#c.imp_hh_rank "Income Rank * (Year-1985)" 1.pre_2001#c.imp_hh_rank "Income Rank * I\{1997-2000\}\$^{(ii)}\$" 1.post_2001#c.imp_hh_rank#c.higher_internet "Income Rank * I\{2001-2013\} * I\{Higher Internet\}")
**
***************************************************************


***************************************************************
** Table 4
use norway_data_ready_to_be_analyzed, clear
eststo clear
eststo: quietly: reg po_inc_comp imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
local aux_period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local period "`aux_period'"
estadd local country "Norway"
estadd local test ""
eststo: quietly: reg po_inc_comp imp_hh_rank post_2001 post_2001#c.imp_hh_rank c.trend#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
eststo: quietly: reg po_inc_comp imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank pre_2001 i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_inc_comp imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
eststo: quietly: reg po_financial_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
local aux_period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local period "`aux_period'"
estadd local country "Norway"
estadd local test ""
eststo: quietly: reg po_financial_sat imp_hh_rank post_2001 post_2001#c.imp_hh_rank c.trend#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
eststo: quietly: reg po_financial_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank pre_2001 i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_financial_sat imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local country "Norway"
esttab using "secondary_regression_table.tex", replace booktabs se eqlabels(, none) nonotes label gap compress keep(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet c.trend#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank) order(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet c.trend#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank) stats(test country period N, fmt(%3s %3s %3s %9.0fc) labels("P-value (i)=(ii)" "\midrule Country" "Period" "Observations" )) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) varlabel(1.post_2001#c.imp_hh_rank "Income Rank * I\{2001-2013\}\$^{(i)}\$" c.trend#c.imp_hh_rank "Income Rank * (Year-1985)" 1.pre_2001#c.imp_hh_rank "Income Rank * I\{1997-2000\}\$^{(ii)}\$" 1.post_2001#c.imp_hh_rank#c.higher_internet "Income Rank * I\{2001-2013\} * I\{Higher Internet\}")
**
***************************************************************


********************************************************************
********* PRODUCE FIGURES AND TABLES FOR ONLINE APPENDIX ***********
********************************************************************


***************************************************************
** Figure A.2
use norway_data_ready_to_be_analyzed, clear
* Figure A.2.a:
hist happy, xlabel(1 "Not at all happy" 2 "Not particularly happy" 3 "Quite happy" 4 "Very happy", angle(45)) xtitle("Will you mostly describe yourself as?", size(med)) disc scheme(s1mono) percent note(" N=48,570" " Period=1985-2013", ring(0) position(11) size(medsmall))
graph export histogram_happy.pdf, replace
* Figure A.2.b:
hist life_sat, xlabel(1 "Very dissatisfied" 2 "Slightly dissatisfied" 3 "Neither..." 4 "Somewhat Satisfied" 5 "Very satisfied", angle(45)) xtitle("How satisfied are you with your life?", size(medsmall)) disc scheme(s1mono) percent note(" N=29,655" " Period=1999-2013", ring(0) position(11) size(medsmall))
graph export histogram_life_sat.pdf, replace
* Figure A.2.c:
hist inc_comp, xlabel(1 "Much worse than average" 2 "Slightly worse than average" 3 "Average" 4 "Slightly better than average" 5 "Much better than average", angle(45)) xtitle("In comparison to other Norwegians," "would you say that your economic situation is...?", size(medsmall)) disc scheme(s1mono) percent note(" N=38,938" " Period=1993-2013", ring(0) position(11) size(medsmall))
graph export histogram_inc_comp.pdf, replace
* Figure A.2.d:
hist financial_sat, xlabel(1 "I need more money" 2 "I manage with what I have" 3 "I could cope with less", angle(45)) xtitle("How do you feel about your economic situation?" "Do you really need more money than you have to be able to live a satisfying life," "do you manage your current income or" "would you be able to cope with it less if you had to?", size(medsmall)) disc scheme(s1mono) percent note(" N=38,950" " Period=1993-2013", ring(0) position(11) size(medsmall))
graph export histogram_financial_sat.pdf, replace
** 
****************************************************************


***************************************************************
** Figure A.3
use norway_data_ready_to_be_analyzed, clear
gen annual=(year-1985)/2+1
replace annual=7 if annual==8
replace annual=annual-1 if annual>8
reg po_happy ib(7).annual##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==0, robust
estimates store high_internet
reg po_happy ib(7).annual##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==1, robust
estimates store low_internet
coefplot (low_internet,  recast(connected) lpattern(dash) lcolor(blue) ciopts(lpattern(dash) lcolor(blue) recast(rcap)) mcolor(blue) msymbol(O)) (high_internet, recast(connected) lpattern(solid) lcolor(red) ciopts(lpattern(dash) lcolor(red) recast(rcap)) mcolor(red) msymbol(O)), recast(connected) vertical keep(*.annual#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) recast(rcap)) graphregion(color(white)) plotregion(color(white)) ylabel(-.3(.1).5, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0)  xline(7.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Happiness-Income Gradient", size(medium) height(5)) legend(order(4 2) lab(4 "Higher Internet") lab(2 "Lower Internet") pos(11) ring(0) col(1) region(color(none))) scheme(s1mono) coeflabels(1.annual#c.imp_hh_rank = "85" 2.annual#c.imp_hh_rank =  "87" 3.annual#c.imp_hh_rank =  "89" 4.annual#c.imp_hh_rank =  "91" 5.annual#c.imp_hh_rank =  "93" 6.annual#c.imp_hh_rank =  "95" 7.annual#c.imp_hh_rank =  "97&99" 8.annual#c.imp_hh_rank =  "01" 9.annual#c.imp_hh_rank =  "03" 10.annual#c.imp_hh_rank =  "05" 11.annual#c.imp_hh_rank =  "07" 12.annual#c.imp_hh_rank =  "09" 13.annual#c.imp_hh_rank =  "11" 14.annual#c.imp_hh_rank =  "13") xlabel(, angle(45))
* Figure A.3.a:
graph export annual_event_study_by_internet.pdf, replace
reg po_happy ib(7).annual##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estimates store all_internet
coefplot all_internet, vertical keep(*.annual#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) lcolor(purple) recast(rcap)) mcolor(purple) msymbol(O) graphregion(color(white)) plotregion(color(white)) ylabel(-0.2(.1).2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0)  legend(order(2 1) lab(2 "Average Effect") lab(1 "90% CI") pos(11) ring(0) col(1) region(color(none))) xline(7.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Happiness-Income Gradient", size(medium) height(5))  recast(connected) lcolor(purple) scheme(s1mono) coeflabels(1.annual#c.imp_hh_rank = "85" 2.annual#c.imp_hh_rank =  "87" 3.annual#c.imp_hh_rank =  "89" 4.annual#c.imp_hh_rank =  "91" 5.annual#c.imp_hh_rank =  "93" 6.annual#c.imp_hh_rank =  "95" 7.annual#c.imp_hh_rank =  "97&99" 8.annual#c.imp_hh_rank =  "01" 9.annual#c.imp_hh_rank =  "03" 10.annual#c.imp_hh_rank =  "05" 11.annual#c.imp_hh_rank =  "07" 12.annual#c.imp_hh_rank =  "09" 13.annual#c.imp_hh_rank =  "11" 14.annual#c.imp_hh_rank =  "13")  xlabel(, angle(45))
* Figure A.3.c:
graph export annual_event_study.pdf, replace
use germany_data_ready_to_be_analyzed, clear
gen biennial=floor((year-1985)/4)+1
replace biennial=7 if biennial==8
keep if mod(year,2)==1
reg po_life_sat ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estimates store all_internet
coefplot all_internet, vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) lcolor(purple) recast(rcap)) mcolor(purple) msymbol(O) graphregion(color(white)) plotregion(color(white)) ylabel(-0.2(.1).2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank =  "85&87" 2.biennial#c.imp_hh_rank  = "89&91" 3.biennial#c.imp_hh_rank = "93&95" 4.biennial#c.imp_hh_rank = "97&99" 5.biennial#c.imp_hh_rank = "01&03" 6.biennial#c.imp_hh_rank ="05&07" 7.biennial#c.imp_hh_rank = "09&11&13") legend(order(2 1) lab(2 "Average Effect") lab(1 "90% CI") pos(11) ring(0) col(1) region(color(none))) xline(4.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Life Sat.-Income Gradient", size(medium) height(5))  recast(connected) lcolor(purple) scheme(s1mono)
* Figure A.3.b:
graph export alternative_germany_event_study.pdf, replace
**
***************************************************************


***************************************************************
** Figure A.4
use norway_data_ready_to_be_analyzed, clear
gen biennial=floor((year-1985)/4)+1
replace biennial=7 if biennial==8
reg po_inc_comp ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==0, robust
estimates store high_internet
reg po_inc_comp ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==1, robust
estimates store low_internet
reg po_inc_comp ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estimates store all_internet
coefplot (low_internet,  recast(connected) lpattern(dash) lcolor(blue) ciopts(lpattern(dash) lcolor(blue) recast(rcap)) mcolor(blue) msymbol(O)) (high_internet, recast(connected) lpattern(solid) lcolor(red) ciopts(lpattern(dash) lcolor(red) recast(rcap)) mcolor(red) msymbol(O)), recast(connected) vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) recast(rcap)) graphregion(color(white)) plotregion(color(white)) ylabel(-.3(.1).4, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85&87" 2.biennial#c.imp_hh_rank  = "89&91" 3.biennial#c.imp_hh_rank = "93&95" 4.biennial#c.imp_hh_rank = "97&99" 5.biennial#c.imp_hh_rank = "01&03" 6.biennial#c.imp_hh_rank ="05&07" 7.biennial#c.imp_hh_rank = "09&11&13") xline(2.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Perc. Rank-Income Gradient", size(medium) height(5)) legend(order(4 2) lab(4 "Higher Internet") lab(2 "Lower Internet") pos(11) ring(0) col(1) region(color(none))) scheme(s1mono)
* Figure A.4.a:
graph export inc_comp_event_study_by_internet.pdf, replace
coefplot all_internet, vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) lcolor(purple) recast(rcap)) mcolor(purple) msymbol(O) graphregion(color(white)) plotregion(color(white)) ylabel(-0.2(.1).2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85&87" 2.biennial#c.imp_hh_rank  = "89&91" 3.biennial#c.imp_hh_rank = "93&95" 4.biennial#c.imp_hh_rank = "97&99" 5.biennial#c.imp_hh_rank = "01&03" 6.biennial#c.imp_hh_rank ="05&07" 7.biennial#c.imp_hh_rank = "09&11&13") legend(order(2 1) lab(2 "Average Effect") lab(1 "90% CI") pos(11) ring(0) col(1) region(color(none))) xline(2.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Happiness-Income Gradient", size(medium) height(5))  recast(connected) lcolor(purple) scheme(s1mono)
* Figure A.4.c:
graph export inc_comp_event_study.pdf, replace
reg po_financial_sat ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==0, robust
estimates store high_internet
reg po_financial_sat ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq if lower_internet==1, robust
estimates store low_internet
coefplot (low_internet,  recast(connected) lpattern(dash) lcolor(blue) ciopts(lpattern(dash) lcolor(blue) recast(rcap)) mcolor(blue) msymbol(O)) (high_internet, recast(connected) lpattern(solid) lcolor(red) ciopts(lpattern(dash) lcolor(red) recast(rcap)) mcolor(red) msymbol(O)), recast(connected) vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) recast(rcap)) graphregion(color(white)) plotregion(color(white)) ylabel(-.3(.1).2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85&87" 2.biennial#c.imp_hh_rank  = "89&91" 3.biennial#c.imp_hh_rank = "93&95" 4.biennial#c.imp_hh_rank = "97&99" 5.biennial#c.imp_hh_rank = "01&03" 6.biennial#c.imp_hh_rank ="05&07" 7.biennial#c.imp_hh_rank = "09&11&13") xline(2.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Inc. Satisf.-Income Gradient", size(medium) height(5)) legend(order(4 2) lab(4 "Higher Internet") lab(2 "Lower Internet") pos(11) ring(0) col(1) region(color(none))) scheme(s1mono)
* Figure A.4.b:
graph export inc_sat_event_study_by_internet.pdf, replace
reg po_financial_sat ib(4).biennial##c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estimates store all_internet
coefplot all_internet, vertical keep(*.biennial#c.imp_hh_rank) omitted baselevels level(90) ciopts(lpattern(dash) lcolor(purple) recast(rcap)) mcolor(purple) msymbol(O) graphregion(color(white)) plotregion(color(white)) ylabel(-0.2(.1).2, labsize(medlarge)) yline(0, lcolor(black) lwidth(medthick))  offset(0) coeflabels(1.biennial#c.imp_hh_rank = "85&87" 2.biennial#c.imp_hh_rank  = "89&91" 3.biennial#c.imp_hh_rank = "93&95" 4.biennial#c.imp_hh_rank = "97&99" 5.biennial#c.imp_hh_rank = "01&03" 6.biennial#c.imp_hh_rank ="05&07" 7.biennial#c.imp_hh_rank = "09&11&13") legend(order(2 1) lab(2 "Average Effect") lab(1 "90% CI") pos(11) ring(0) col(1) region(color(none))) xline(2.5, lcolor(green) lwidth(medthick) lpattern(solid)) xtitle("Year", size(medium) height(7)) ytitle("Change in Happiness-Income Gradient", size(medium) height(5))  recast(connected) lcolor(purple) scheme(s1mono)
* Figure A.4.d:
graph export inc_sat_event_study.pdf, replace
** 
***************************************************************


***************************************************************
** Figure A.5
use norway_data_ready_to_be_analyzed, clear
set more off
** Figures A.5.a, A.5.b, A.5.c and A.5.d:
foreach type in po_happy po_life_sat po_inc po_financial_sat {
global maxq=9
global middle=5
global depvar `type'
gen scatter_x=_n-$middle if _n<=$maxq
xtile q_imp_hh_rank= imp_hh_rank, nq($maxq)
foreach var in post_2001 {
gen opp_`var'=1-`var' if `var'!=.
gen `var'_q_imp_hh_rank=`var'*q_imp_hh_rank
gen opp_`var'_q_imp_hh_rank=opp_`var'*q_imp_hh_rank
}
local prepos="post_2001"
reg $depvar `prepos' ib($middle).`prepos'_q_imp_hh_rank ib($middle).opp_`prepos'_q_imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
foreach var in `prepos' opp_`prepos' {
gen `var'_pred=0 if _n==$middle
forvalues k=1(1)$maxq {
replace `var'_pred=_b[`k'.`var'_q_imp_hh_rank] if _n==`k' & _n!=$middle
}
}
reg `prepos'_pred scatter_x, nocons
predict `prepos'_pred_line, xb
gen slope1="Slope="+string(_b[scatter_x]*9,"%9.2f") if _n==8
reg opp_`prepos'_pred scatter_x, nocons
predict opp_`prepos'_pred_line, xb
gen slope2="Slope="+string(_b[scatter_x]*9,"%9.2f") if _n==8
if ("$depvar"=="po_happy") {
local ytitle="Happiness"
local ylabel="-0.3(0.1)0.3"
local pre_period="1985-2000"
}
else if ("$depvar"=="po_life_sat") {
local ytitle="Life Satisfaction"
local ylabel="-0.4(0.2)0.4"
local pre_period="1999-2000"
}
else if ("$depvar"=="po_financial_sat") {
local ytitle="Income Adequacy"
local ylabel="-0.6(0.2)0.6"
local pre_period="1993-2000"
}
else if ("$depvar"=="po_inc") {
local ytitle="Perceived Rank"
local ylabel="-1.25(0.5)1.25"
local pre_period="1993-2000"
}
two scatter opp_`prepos'_pred `prepos'_pred scatter_x, mcolor(blue red) msymbol(O X) mlabel(slope2 slope1) msize(medium large) mlabcolor(blue red) mlabposition(6 12) mlabgap(3 3) || line `prepos'_pred_line scatter_x, sort lcolor(red) || line opp_`prepos'_pred_line scatter_x, sort lcolor(blue) graphregion(color(white)) plotregion(color(white)) ylabel(`ylabel', labsize(medlarge)) ytitle(`ytitle', suffix size(medium) height(5)) xtitle("Income Rank", size(medium) height(5)) xlabel(-4 "0-11%" -3 "11-22%" -2 "22-33%" -1 "33-44%" 0 "44-56%" 1 "56-67%" 2 "67-78%" 3 "78-89%" 4 "89-100%", angle(45)) legend(order(1 2) lab(1 "`pre_period'") lab(2 "2001-2013") pos(11) ring(0) col(1) region(color(none))) scheme(s1mono)
graph export binscatter_`type'.pdf, replace
drop scatter_x *_pred q_* opp_* *_q_* *_line slope1 slope2
}
**
***************************************************************


***************************************************************
** Table A.1
use norway_data_ready_to_be_analyzed, clear
eststo clear
eststo: quietly: reg po_happy higher_internet post_2001 post_2001#c.higher_internet imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
eststo: quietly: reg po_happy higher_internet post_2001 post_2001#c.higher_internet pre_2001 pre_2001#c.higher_internet imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
test 1.post_2001#c.higher_internet==1.pre_2001#c.higher_internet
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_life higher_internet post_2001 post_2001#c.higher_internet imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
eststo: quietly: reg po_inc higher_internet post_2001 post_2001#c.higher_internet imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
eststo: quietly: reg po_inc higher_internet post_2001 post_2001#c.higher_internet pre_2001 pre_2001#c.higher_internet imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
test 1.post_2001#c.higher_internet==1.pre_2001#c.higher_internet
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_financial_sat higher_internet post_2001 post_2001#c.higher_internet imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
eststo: quietly: reg po_financial_sat higher_internet post_2001 post_2001#c.higher_internet pre_2001 pre_2001#c.higher_internet imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
test 1.post_2001#c.higher_internet==1.pre_2001#c.higher_internet
estadd local test=string(`r(p)',"%9.3f")
esttab using "average_effects.tex", replace booktabs se eqlabels(, none) nonotes label gap compress keep(higher_internet 1.post_2001#c.higher_internet 1.pre_2001#c.higher_internet ) order(higher_internet 1.post_2001#c.higher_internet 1.pre_2001#c.higher_internet) stats(test period N, fmt(%3s %3s %9.0fc) labels("P-value (i)=(ii)" "\midrule Period" "Observations")) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) varlabel(higher_internet "I\{Higher Internet\}" 1.post_2001#c.higher_internet "I\{Higher Internet\} * I\{2001-2013\}\$^{(i)}\$" 1.pre_2001#c.higher_internet "I\{Higher Internet\} * I\{1997-2000\}\$^{(ii)}\$")
**
***************************************************************


***************************************************************
** Table A.2
use norway_data_ready_to_be_analyzed, clear
eststo clear
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local type="OLS"
estadd local coding="Yes"
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local type="OLS"
estadd local coding="Yes"
eststo: quietly: reg happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local type="OLS"
estadd local coding="No"
eststo: quietly: reg life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local type="OLS"
estadd local ranking="Nation"
estadd local coding="No"
eststo: quietly: oprobit happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local type="O-Probit"
estadd local coding="No"
eststo: quietly: oprobit life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local type="O-Probit"
estadd local coding="No"
esttab using "table_robustness_2.tex", replace booktabs se eqlabels(, none) nonotes label gap compress keep(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank ) order(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank ) stats(test type coding period N, fmt(%3s %3s %3s %3s %9.0fc) labels("P-value (i)=(ii)" "\midrule Model" "POLS Transformation" "Period" "Observations" )) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) varlabel(1.post_2001#c.imp_hh_rank "Income Rank * I\{2001-2013\}\$^{(i)}\$" 1.pre_2001#c.imp_hh_rank "Income Rank * I\{1997-2000\}\$^{(ii)}\$")
***************************************************************


***************************************************************
** Table A.3
use norway_data_ready_to_be_analyzed, clear
eststo clear
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local ranking="Nation"
estadd local weights="No"
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local ranking="Nation"
estadd local weights="No"
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq [aw=vekt], robust
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local ranking="Nation"
estadd local weights="Yes"
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq [aw=vekt], robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local ranking="Nation"
estadd local weights="Yes"
ren imp_hh_rank aux_imp_hh_rank
gen imp_hh_rank=region_imp_hh_rank 
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local ranking="County"
estadd local weights="No"
eststo: quietly: reg po_life_sat imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
sum year if e(sample)
estadd local period=substr("`r(min)'",3,2) +"-"+substr("`r(max)'",3,2)
estadd local ranking="County"
estadd local weights="No"
drop imp_hh_rank 
ren aux_imp_hh_rank imp_hh_rank
esttab using "table_robustness_1.tex", replace booktabs se eqlabels(, none) nonotes label gap compress keep(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank ) order(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.pre_2001#c.imp_hh_rank ) stats(test weights ranking period N, fmt(%3s %3s %3s %3s %9.0fc) labels("P-value (i)=(ii)" "\midrule Weights" "Income Rank" "Period" "Observations" )) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) varlabel(1.post_2001#c.imp_hh_rank "Income Rank * I\{2001-2013\}\$^{(i)}\$" 1.pre_2001#c.imp_hh_rank "Income Rank * I\{1997-2000\}\$^{(ii)}\$")
***************************************************************


***************************************************************
** Table A.4
use norway_data_ready_to_be_analyzed, clear
eststo clear
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="I"
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank pre_2001 i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="I"
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="I"
use norway_data_ready_to_be_analyzed, clear
replace imp_hh_rank=alt_imp_hh_rank
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="II"
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank pre_2001 i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="II"
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="II"
use norway_data_ready_to_be_analyzed, clear
replace raw_hh_rank=. if imp_hh_rank==.
replace imp_hh_rank=raw_hh_rank
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank  i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="III"
eststo: quietly: reg po_happy imp_hh_rank post_2001 i.post_2001#c.imp_hh_rank pre_2001 i.pre_2001#c.imp_hh_rank i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="III"
test 1.post_2001#c.imp_==1.pre_2001#c.imp_
estadd local test=string(`r(p)',"%9.3f")
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="III"
esttab using "appendix_table_alternative_income_definitions", replace booktabs se eqlabels(, none) nonotes label gap compress keep(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet 1.pre_2001#c.imp_hh_rank) order(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet 1.pre_2001#c.imp_hh_rank) stats(test type N, fmt(%3s %3s %9.0fc) labels("P-value (i)=(ii)" "\midrule Income Rank Definition" "Observations" )) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) varlabel(1.post_2001#c.imp_hh_rank "Income Rank * I\{2001-2013\}\$^{(i)}\$" 1.pre_2001#c.imp_hh_rank "Income Rank * I\{1997-2000\}\$^{(ii)}\$" 1.post_2001#c.imp_hh_rank#c.higher_internet "Income Rank * I\{2001-2013\} * I\{Higher Internet\}")
**
***************************************************************


***************************************************************
** Table A.5
use norway_data_ready_to_be_analyzed, clear
eststo clear
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="I"
replace higher_internet=alt1_higher_internet
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="II"
replace higher_internet=alt2_higher_internet
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="III"
replace higher_internet=alt3_higher_internet
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="IV"
replace higher_internet=alt4_higher_internet
eststo: quietly: reg po_happy imp_hh_rank post_2001 higher_internet c.imp_hh_rank#c.higher_internet post_2001#c.higher_internet post_2001#c.imp_hh_rank post_2001#c.imp_hh_rank#c.higher_internet i.year i.marital i.education i.hh_size i.hh_workers female age age_sq, robust
estadd local type="V"
esttab using "appendix_table_alternative_internet_definitions", replace booktabs  se eqlabels(, none) nonotes label gap compress keep(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet) order(imp_hh_rank 1.post_2001#c.imp_hh_rank 1.post_2001#c.imp_hh_rank#c.higher_internet) stats(type N, fmt(%3s %9.0fc) labels("I\{Higher Internet\} Definition" "Observations" )) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) varlabel(1.post_2001#c.imp_hh_rank "Income Rank * I\{2001-2013\}\$^{(i)}\$" 1.post_2001#c.imp_hh_rank#c.higher_internet "Income Rank * I\{2001-2013\} * I\{Higher Internet\}")
**
***************************************************************


***************************************************************
** Table A.6
use norway_data_ready_to_be_analyzed, clear
gen density_region=.
replace density_region=65.7 if region==1
replace density_region=110.9 if region==2
replace density_region=1319.8 if region==3
replace density_region=6.9 if region==4
replace density_region=7.3 if region==5
replace density_region=17.4 if region==6
replace density_region=105.4 if region==7
replace density_region=11 if region==8
replace density_region=11.9 if region==9
replace density_region=23.6 if region==10
replace density_region=46.7 if region==11
replace density_region=30.9 if region==12
replace density_region=5.7 if region==13
replace density_region=16.8 if region==14
replace density_region=15.6 if region==15
replace density_region=5.9 if region==16
replace density_region=6.1 if region==17
replace density_region=6 if region==18
replace density_region=1.5 if region==19
gen college_grad=(education>=4) if education!=.
gen married=marital_status==1 if marital_status!=.
gen oslo=region==3 if region!=.
eststo clear
foreach var in female age married college_grad oslo density_region {
eststo: quietly: reg `var' ibn.year, robust nocons
}
label var married "Married" 
label var college_grad "College" 
label var oslo "Oslo" 
label var density_region "Density"
esttab using "appendix_evolution_descriptive_stats.tex", replace booktabs se nonotes gap compress b(%9.3f) se(%9.3f) nostar label noobs nonumber
** 
***************************************************************


***************************************************************
** Table A.7 (this is just the part of the Table for the NMS)
use norway_data_ready_to_be_analyzed, clear
replace adj_imp_hh_income=adj_imp_hh_income/100000
table year if po_happy!=., c(mean adj_imp_hh_income sd adj_imp_hh_income) format(%9.3f)
table year if po_happy!=., c(mean imp_hh_rank sd imp_hh_rank mean higher_internet sd higher_internet) format(%9.3f)
**
***************************************************************


************************************************************
** Table A.8
use norway_data_ready_to_be_analyzed, clear
gen perc_internet=internet_home*100
label var perc_internet "Has Internet (\%)"
replace hh_size=5 if hh_size>=5
replace hh_workers=3 if hh_workers>=3
cap: label drop education hh_size hh_workers marital_status
label define education 1 "Primary School" 2 "Middle School" 3 "High School" 4 "College"
label values education education 
label define hh_size 1 "1" 2 "2" 3 "3" 4 "4" 5 "5+"
label values hh_size hh_size 
label define hh_workers 1 "1" 2 "2" 3 "3+"
label values hh_workers hh_workers 
label define marital_status 1 "Married" 2 "Cohabitant" 3 "Single" 4 "Separated/Divorced" 5 "Widowed"
label values marital_status marital_status 
eststo clear
eststo: quietly: reg perc_internet female age age_sq i.education i.marital i.hh_size i.hh_workers if year==2001, robust
sum perc_internet  if year==2001
estadd local meandep=string(`r(mean)',"%9.2f")
esttab using "regression_predict_internet.tex", drop(1.education 1.hh_size 0.hh_workers 1.marital_status) refcat(2.education "Education (omitted: Primary School)" 2.marital_status "Marital Status (omitted: Married)" 2.hh_size "Number of HH Members (omitted: 1)" 1.hh_workers "Number of HH Workers (omitted: 0)", nolabel) replace booktabs se eqlabels(, none) nonotes label gap compress stats(meandep pseudo_r2 N, fmt(%3s %9.0fc) labels("Mean Outcome" "Observations" )) b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01)
***************************************************************
