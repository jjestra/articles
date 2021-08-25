{smcl}
{* *! v1.0.0 Pablo Estrada 18nov2019}{...}
{cmd:help netivreg}
{hline}

{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{hi:netivreg} {hline 2}}Network Instrumental-Variables Regression{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 14 2}
{cmd:netivreg} {depvar}
[{varlist}] {cmd:(}{it:W} {cmd:=} {it:W0}{cmd:)}
{ifin}
[{cmd:,} {cmd:first second}
{cmdab:tr:ansformed}
{cmd:wx(}{it:varname}{cmd:)}
{cmdab:id(}{it:varname}{cmd:)}
{cmdab:cl:uster(}{it:varname}{cmd:)}]


{title:Description}

{pstd}{cmd:netivreg} fits a linear-in-means regression of
{it:depvar} on {it:varlist} and social interaction network {it:W},
using the exogenous network {it:W0} as instrument of the endogenous
network {it:W}. The social networks {it:W} and {it:W0} are defined by
two adjacency lists stored as Stata frames.


{title:Options}

{phang}{cmd:first} reports first-stage results of the linear projection
of {it:W} on {it:W0}.

{phang}{cmd:second} reports second-stage results of the 2SLS estimation
of the linear-in-means model.

{phang}{cmd:transformed} estimates the linear-in-means model with the
transformed variables multiplied by {it:(I - W0)}.

{phang}{cmd:wx(}{it:varname}{cmd:)} indicates the variables from {it:varlist}
to be included as contextual effects. By default, it includes all the
variables.

{phang}{cmd:id(}{it:varname}{cmd:)} identifies the variable to match
covariates with network data. Default {it:varname} is id.

{phang}{cmd:cluster(}{it:varname}{cmd:)} produces standard errors and
statistics that are robust to both arbitrary heteroskedasticity and
intragroup correlation, where {it:varname} identifies the group.


{title:Example 1: Simulation}

{pstd}Setup{p_end}
{phang2}{cmd:use} data_sim.dta{p_end}
{phang2}{cmd:frame} create edges{p_end}
{phang2}{cmd:frame} edges: use W_sim.dta{p_end}
{phang2}{cmd:frame} create edges0{p_end}
{phang2}{cmd:frame} edges0: use W0_sim.dta{p_end}

{pstd}Fit a linear-in-means regression using Bramoulle et al
estimator{p_end}
{phang2}{cmd:netivreg} y_exo x1 x2 x3 x4 (edges = edges){p_end}

{pstd}Fit a linear-in-means regression using Estrada et al
estimator{p_end}
{phang2}{cmd:netivreg} y_exo x1 x2 x3 x4 (edges = edges0){p_end}


{title:Example 2: Empirical}

{pstd}Setup{p_end}
{phang2}{cmd:use} articles.dta{p_end}
{phang2}{cmd:generate} citations = exp(lcitations){p_end}
{phang2}{cmd:frame} create edges{p_end}
{phang2}{cmd:frame} edges: use edges.dta{p_end}
{phang2}{cmd:frame} create edges0{p_end}
{phang2}{cmd:frame} edges0: use edges0.dta{p_end}
{phang2}{cmd:tabulate} journal, g(journal){p_end}
{phang2}{cmd:tabulate} c_alumni, g(alumni){p_end}
{phang2}{cmd:tabulate} year, g(year){p_end}

{pstd}Fit a linear-in-means regression{p_end}
{phang2}{cmd:netivreg} lcitations editor diff_gender n_pages n_authors n_references isolated journal1-journal3 year2-year3 alumni2-alumni48 (edges = edges0), wx(editor diff_gender) cluster(c_coauthor){p_end}


{title:Stored results}

{pstd}{cmd:netivreg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(rss)}}residual sum of squares{p_end}
{synopt:{cmd:e(mss)}}model sum of squares{p_end}
{synopt:{cmd:e(r2)}}R-squared if the equation has a constant{p_end}
{synopt:{cmd:e(r2_a)}}adjusted R-squared{p_end}
{synopt:{cmd:e(rmse)}}root mean squared error{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:netivreg}{p_end}
{synopt:{cmd:e(wx)}}contextual effects{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(exogr)}}exogenous regressor{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(first)}}first-stage regression results{p_end}
{synopt:{cmd:e(second)}}second-stage regression results{p_end}


{title:References}

{phang}Estrada et al. 2020. netivreg: Estimation of Peer Effects in
Endogenous Social Networks.
 {it:Stata Journal} {browse "http://www.stata-journal.com/article.html?article=st0173":9: 439-453}.{p_end}


{title:Authors}

{pstd}Pablo Estrada{p_end}
{pstd}Emory University{p_end}
{pstd}Atlanta, USA{p_end}
{pstd}pablo.estrada@emory.edu{p_end}

{pstd}Juan Estrada{p_end}
{pstd}Emory University{p_end}
{pstd}Atlanta, USA{p_end}
{pstd}jjestra@emory.edu{p_end}

{pstd}Kim Huynh{p_end}
{pstd}Bank of Canada{p_end}
{pstd}Ottawa, Canada{p_end}
{pstd}kim@huynh.tv{p_end}

{pstd}David Jacho-Chávez{p_end}
{pstd}Emory University{p_end}
{pstd}Atlanta, USA{p_end}
{pstd}djachocha@emory.edu{p_end}

{pstd}Leonardo Sánchez-Aragón{p_end}
{pstd}ESPOL University{p_end}
{pstd}Guayaquil, Ecuador{p_end}
{pstd}lfsanche@espol.edu.ec{p_end}


{title:Also see}

{p 7 14 2}Help:  {helpb netivreg}, {helpb est},
{helpb postest}, {helpb regress}{p_end}
