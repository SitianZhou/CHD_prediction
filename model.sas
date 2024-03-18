
/* Creating Logistic regression model */

ods noproctitle;
ods graphics / imagemap=on;

* model 1 variables selected based on clinical findings;
proc logistic data=chd_tran plots(only)=(roc effect);
	class currentSmoker prevalentStroke prevalentHyp diabetes BPMeds 
		/ param=glm;
	model TenYearCHD(event='1')= currentSmoker prevalentStroke prevalentHyp 
		diabetes BPMeds sysBP_ln diaBP BMI cigsPerDay glucose_ln heartRate_ln 
		totChol / link=glogit selection=stepwise slentry=0.05 slstay=0.05 lackfit outroc=roc
		hierarchy=single;
	store chd_logistic;
run;
* Hosmer and Lemeshow Goodness-of-Fit Test: p-val = 0.7212 --> fit is good

* model 2 all predictors, no interaction;
proc logistic data=chd_tran plots(only)=(roc effect);
	class sex currentSmoker prevalentStroke prevalentHyp diabetes BPMeds education 
		/ param=glm;
	model TenYearCHD(event='1')=sex currentSmoker prevalentStroke prevalentHyp 
		diabetes BPMeds education age sysBP_ln diaBP BMI cigsPerDay glucose_ln heartRate_ln 
		totChol / link=glogit selection=stepwise slentry=0.05 slstay=0.05 lackfit outroc=roc
		hierarchy=single;
	store chd_logistic;
run;

* model 3 all predictors with 2-way interactions;
proc logistic data=WORK.CHD_TRAN plots(only)=(roc effect);
	class sex education currentSmoker prevalentStroke prevalentHyp diabetes BPMeds 
		/ param=glm;
	model TenYearCHD(event='1')=sex | education | currentSmoker | prevalentStroke | prevalentHyp | diabetes | BPMeds | age | sysBP | diaBP | BMI | cigsPerDay | glucose | heartRate | totChol | heartrate_ln | sysbp_ln | glucose_ln @2 
		/ link=logit selection=stepwise slentry=0.05 slstay=0.05 lackfit outroc=roc hierarchy=single 
		technique=fisher;
run;

* final model;
proc logistic data=chd_tran plots(only)=(roc effect);
	class sex 
		/ param=glm;
	model TenYearCHD(event='1')=sex age sysBP_ln 
		cigsPerDay glucose_ln totChol / link=glogit selection=stepwise slentry=0.05 slstay=0.05 lackfit outroc=roc
		hierarchy=single;
	store chd_logistic;
run;

* logit(heart disease) = -8.5684 - 0.5614*SexFemale + 0.0659*Age + 0.0175*sysBP
* + 0.0192*cigsPerDay * 0.00728*glucose + 0.00227*totChol

