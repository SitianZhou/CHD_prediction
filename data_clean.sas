%let path = ~/heart_disease;

proc import datafile = "&path/chd.csv"
    dbms=csv out=chd replace;
    guessingrows=max;
run;

* data preview;
proc means data=chd;
run;

proc freq data=chd;
	tables male education currentsmoker bpmeds prevalentstroke 
	prevalenthyp diabetes tenyearchd;
run;

* convert NA to missing values using array;
data chd;
	set chd;
	array a[*] $ _character_;
	do i=1 to dim(a);
		if a[i] = "NA" then a[i] = "";
	end;
	drop i;
run;

proc contents data=chd out=vars(keep=name type) noprint;
run; 

data vars;                                                
   set vars;
   if type=2;                               
   newname=trim(left(name))||"_n"; 
run;                                                                                                                 

/* char will contain a list of each character variable separated by a blank space */
/* num will contains a list of each numeric variable separated by a blank space   */
/* rename will contain a list of each new numeric  */
/* variable and each character variable separated by an equal sign to be used in  */ 
/* the RENAME statement.                                                          */                                                        

proc sql noprint;                                         
   select trim(left(name)), trim(left(newname)),             
          trim(left(newname))||'='||trim(left(name))         
          into :char separated by ' ', :num separated by ' ',  
          :rename separated by ' '                         
          from vars;                                                
quit;                                                                                                                                                                     

/* Convert the numeric values to character using an array and the input function */
/* DROP statement is used to prevent the character variables from being written  */
/* to the output data set, and the RENAME statement is used to rename the new    */
/* numeric variable names back to the original character variable names.         */ 

data chd_clean(rename=(male = sex));                                               
   set chd;                                                 
   array char[*] $ &char;                                    
   array num[*] &num;                                      
   do i = 1 to dim(char);                                      
      num[i]=input(char[i], 32.);                                  
   end;                                                      
   drop i &char;                                           
   rename &rename;                                                                                      
run;  

* remove missing values;
data chd_clean;
    set chd_clean;
    if cmiss(of _all_) then delete;
run;

proc print data=chd_clean(obs=5); run;

* data transformation;
proc sgplot data=chd_clean;
	histogram age;
run;

proc sgplot data=chd_clean;
	histogram totchol;
run;


proc sgplot data=chd_clean;
	histogram sysbp;
run;

proc sgplot data=chd_clean;
	histogram glucose;
run;


proc sgplot data=chd_clean;
	histogram cigsperday;
run;

proc sgplot data=chd_clean;
	histogram heartrate;
run;

data chd_tran;
	set chd_clean;
	heartrate_ln = log(heartrate);
	sysbp_ln = log(sysbp);
	glucose_ln = log(glucose);
run;

proc sgplot data=chd_tran;
	histogram glucose_ln;
run;













