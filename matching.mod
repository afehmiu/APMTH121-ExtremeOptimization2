param num_rows >= 2, integer;     # Number of rows in data file
param num_cols >= 2, integer;     # Number of columns in data file
param pool_of_people integer; 

set PATIENT_DONOR_PAIRS    := 1 .. num_rows; # set of patient-donor pairs
set ROWS    := 1 .. num_rows;	  # set of rows
set COLUMNS := 1 .. num_cols;	  # set of columns

param compatibility {ROWS, COLUMNS} binary; # compatibility is binary

# binary variable for whether a donation occurs or not
var x {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 

# the objective function we want to maximize
maximize DonorPairs: sum {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} x[i,j];

# every pair can donate one kidney at most
subject to DonorLimit {j in PATIENT_DONOR_PAIRS}: sum {i in PATIENT_DONOR_PAIRS} x[i,j] <= 1;

# every pair can receive one kidney at most
subject to RecipientLimit {i in PATIENT_DONOR_PAIRS}: sum {j in PATIENT_DONOR_PAIRS} x[i,j] <= 1;

# pairs must be compatible for a kidney donation to occur
subject to Compatibility {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS}: x[i,j] <= compatibility[i,j];

# both pairs must exchange kidneys for a donation to occur
subject to MandatoryExchange {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS}: x[i,j]=x[j,i];