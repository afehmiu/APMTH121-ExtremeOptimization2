param num_rows >= 2, integer;     # Number of rows
param num_cols >= 2, integer;     # Number of columns 
param pool_of_people integer; 
param links integer;

set PATIENT_DONOR_PAIRS    := 1 .. num_cols; 
set Cycle2  = {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS}; # set of pair combinations for Cycle2
set  Cycle3  = {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS, k in PATIENT_DONOR_PAIRS}; # set of pair combinations for Cycle3
# set L := 1 .. links;

set ROWS    := 1 .. num_rows;	  # set of rows
set COLUMNS := 1 .. num_cols;	  # set of columns
param compatibility {k in COLUMNS, j in ROWS} >= 0;


var x2 {Cycle2} binary; # binary variable equals 1 if pair in cycle 2
var x3 {Cycle3} binary; # binary variable equals 1 if pair in cycle 3
 
# var alpha_a {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 
# var alpha_b {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 

# maximize total number of cycles 
maximize NumberCycles: sum {(i,j) in Cycle2} x2[i,j] + sum {(i,j,k) in Cycle3} x3[i,j,k];

# ensures number of kidneys received by patient i in Cycle2 matches the number of kidneys donated by donor i
# subject to Compatibility {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS: i <>j}: compatibility[i,j] = 1;

# guarantee pair can only be in one of the cycles (either Cycle2 or Cycle3)
subject to CycleLimit {i in PATIENT_DONOR_PAIRS}: sum { (i,j) in Cycle2: i <> j} x2[i,j] +  sum { (i,j) in Cycle2: i<>j} x2[j,i] + sum {(i,j,k) in Cycle3: i <> j and j <> k and i <> k} x3[i,j,k] + sum { (i,j,k) in Cycle3: i <> j and j <> k and i <> k} x3[j,k,i] +sum {(i,j,k) in Cycle3: i <> j and j <> k and i <> k} x3[k,i,j] <= 1;
