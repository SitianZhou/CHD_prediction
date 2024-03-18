* EDA;
proc contents data=chd_clean;
run;

* distribution of each variable;
title "Distribution of education levels";
	proc sgplot data=chd_clean;
	vbar education / datalabel missing;
	label education = "Education level";
run;


title "Distribution of sex";
	proc sgplot data=chd_clean;
	vbar sex / datalabel missing;
	label sex = "Sex";
run;

title "Distribution of CHD response";
	proc sgplot data=chd_clean;
	vbar tenyearchd / datalabel missing;
	label tenyearchd = "CHD";
run;

* variables against outcome;
title "CHD vs Sex";
	proc sgplot data=chd_clean pctlevel=group;
	vbar sex / group=tenyearchd stat=percent missing;
	label sex = "Sex";
run;

title "CHD vs Smoking";
	proc sgplot data=chd_clean pctlevel=group;
	vbar cigsperday / group=tenyearchd stat=percent missing;
	label cigsperday = "# cigarette per day";
run;

title "CHD vs diabete";
	proc sgplot data=chd_clean pctlevel=group;
	vbar diabetes / group=tenyearchd stat=percent missing;
	label diabetes = "Diabete";
run;

* boxplots;
proc sort data=chd_clean out=chd_std;
	by tenyearchd descending age;
run;

proc boxplot data=chd_std;
	plot Age*tenyearchd;
run;


