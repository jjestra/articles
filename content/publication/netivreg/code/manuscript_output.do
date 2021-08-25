clear all
set more off, permanently

cd "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\dta"

*-- Load Nodes Simulated Data
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT1", replace
use data_sim.dta
format y_endo y_exo x1 x2 x3 x4 %9.3f
list in 1/5, table 
sjlog close, replace

clear

*-- Load W Simulated Data
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT2", replace
use W_sim.dta
list in 113/117, table 
sjlog close, replace

clear

*-- Load W0 Simulated Data
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT3", replace
use W0_sim.dta
list in 113/117, table 
sjlog close, replace

*-- netivreg: Exogenous (G2SLS)
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT4", replace
use data_sim.dta
frame create edges
frame edges: use W_sim.dta
cd "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg"
netivreg y_exo x1 x2 x3 x4 (edges = edges) 
sjlog close, replace

cd "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\dta"

*-- netivreg: Exogenous (G3SLS)
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT5", replace
frame create edges0
frame edges0: use W0_sim.dta
cd "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg"
netivreg y_exo x1 x2 x3 x4 (edges = edges0) 
sjlog close, replace

*-- netivreg: Endogenous (G3SLS)
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT6", replace
netivreg y_endo x1 x2 x3 x4 (edges = edges0)
sjlog close, replace

sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT7", replace
netivreg y_endo x1 x2 x3 x4 (edges = edges0), first
sjlog close, replace

sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT8", replace
netivreg y_endo x1 x2 x3 x4 (edges = edges0), second
sjlog close, replace

cd "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\dta"

*-- Data description
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT9", replace
use articles.dta
describe
sjlog close, replace

*-- Summary Statistics I
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT10", replace
gen citations = exp(lcitations)
tabulate journal year, summarize(citations)
sjlog close, replace

*-- Summary Statistics II
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT11", replace
summarize editor diff_gender isolated n_pages n_authors n_references
sjlog close, replace

clear
frame reset

cd "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\dta"

*-- Frame edges & edges0
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT12", replace
frame create edges
frame edges: use edges.dta
frame edges: list in 1/5, table 
frame create edges0
frame edges0: use edges0.dta
frame edges0: list in 1/5, table
sjlog close, replace

cd "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\dta"
use articles.dta

*-- Estimation
sjlog using "C:\Users\djachoc\OneDrive - Emory University\Research\netivreg\output\netivregOUT13", replace
tabulate journal, g(journal)
tabulate c_alumni, g(alumni)
tabulate year, g(year)

cd "C:/Users/djachoc/OneDrive - Emory University/Research/netivreg/"
capture program drop netivreg

netivreg lcitations diff_gender editor n_pages n_authors n_references isolated journal1-journal3 year2-year3 alumni2-alumni48  (edges = edges0), wx(diff_gender editor) cluster(c_coauthor)
sjlog close, replace