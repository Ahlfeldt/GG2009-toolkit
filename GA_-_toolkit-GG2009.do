********************************************************************************
*** This programm executes simple counterfactuals using the 				 ***
*** Glaeser and Gottlibeb (2009) framework								   	 ***
*** By Gabriel M. Ahlfeldt 													 ***
********************************************************************************

* Set parameter values
scalar lde = -0.2						// Labour demand elasticity
scalar alpha = 0.66 					// labour share
scalar beta = (-alpha+lde+1)/(lde+1)	// capital share implictly determined
scalar list beta
scalar delta = 1.5						// Height elasticity of construction cost
scalar sigma = 0.33						// expenditure share on housing

* composite parameter eta implictly determined
scalar eta = [(1-beta)*delta-alpha*(sigma+delta-sigma*delta)]^(-1)

* Define program for simple counterfactuals
capture program drop GG
program define GG // Syntax: 1 change in ln A_c 2 change in ln B_c 3 change in ln M_c
	clear
	set obs 1
	scalar dlnL = eta*(delta+sigma-sigma*delta)*`1'+eta*(1-beta)*(delta*`2'+sigma*(delta-1)*`3')
	gen dlnL = dlnL
	local dlnL = dlnL
	label var dlnL "log change in employment"
	scalar dlnw = eta*(delta-1)*`1' - eta*(1-alpha-beta)*(`2'+sigma*(delta-1)*`3')
	gen dlnw = dlnw
	local dlnw = dlnw
	label var dlnw "log change in wage"
	scalar dlnP = (delta-1)*eta*(`1' + alpha*`2' - (1-alpha-beta)*`3')
	gen dlnP = dlnP
	local dlnP = dlnw
	label var dlnP "log change in rent"
	display "log change in employment = `dlnL'"
	display "log change in wage = `dlnw'"
	display "log change in ren = `dlnP'"
	local dlnRealWage = round(dlnw - sigma*dlnP, 0.01)
	graph bar dlnL  dlnw dlnP, legend(position(12) cols(3) order(1 "Employment" 2 "Wage" 3 "Rent" )) ytitle("log change") note("Effect on real wage is `dlnRealWage' log units." "The is the result of changing:" "Fundamental productivity by `1' log units" "Quality of life by `2' log units"  "Effective land supply by `2' log units") yline(0) 
end


*** Now can play around doing counterfactuals

GG 0  0.1 0		// Increase quality of life
GG 0  0.1 0.5	// Increase quality of life and housing supply
GG 0.1 0.1 0.1  // Increase productivity, quality of life, and housing supply at same rate
 