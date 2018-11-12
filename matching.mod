param num_rows >= 2, integer;     # Number of rows
param num_cols >= 2, integer;     # Number of columns 
param pool_of_people integer; 

set PATIENT_DONOR_PAIRS    := 1 .. (pool_of_people)/2; 
set ROWS    := 1 .. num_rows;	  # set of rows
set COLUMNS := 1 .. num_cols;	  # set of columns

param compatibility {ROWS, COLUMNS} >= 0;

var x {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 


maximize DonorPairs: sum {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} x[i,j];

subject to DonorLimit {j in PATIENT_DONOR_PAIRS}: sum {i in PATIENT_DONOR_PAIRS} x[i,j] <= 1;
subject to RecipientLimit {i in PATIENT_DONOR_PAIRS}: sum {j in PATIENT_DONOR_PAIRS} x[i,j] <= 1;

subject to Compatibility {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS}: x[i,j] <= compatibility[i,j];

subject to MandatoryExchange {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS}: x[i,j]=x[j,i];