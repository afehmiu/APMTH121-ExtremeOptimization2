param num_rows >= 2, integer;     # Number of rows
param num_cols >= 2, integer;     # Number of columns 
param pool_of_people integer; 
param links integer;


set ROWS    := 1 .. num_rows;	  # set of rows
set COLUMNS := 1 .. num_cols;	  # set of columns
param compatibility {k in COLUMNS, j in ROWS} >= 0;

set PATIENT_DONOR_PAIRS    := 1 .. num_cols; 
set Cycle2  = {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS: compatibility[i,j] == compatibility[j,i] == 1 && i <>j}; # set of pair combinations for Cycle2
set  Cycle3  = {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS, k in PATIENT_DONOR_PAIRS: compatibility[i,j] == compatibility[j,k] == compatibility[k,i] == 1 && i <> j <> k}; # set of pair combinations for Cycle3
# set L := 1 .. links;



var x2 {Cycle2} binary; # binary variable equals 1 if cyc;e 2 is used 
var x3 {Cycle3} binary; # binary variable equals 1 if pair in cycle 3
 
# var alpha_a {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 
# var alpha_b {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 

# maximize total number of cycles 
maximize NumberCycles: 2*sum {(i,j) in Cycle2} x2[i,j] + 3*sum {(i,j,k) in Cycle3} x3[i,j,k];

# ensures number of kidneys received by patient i in Cycle2 matches the number of kidneys donated by donor i
# subject to Compatibility {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS: i <>j}: compatibility[i,j] = 1;


# subject to 2CycleCompatibility {(i,j) in Cycle2}: x2[i,j] <= compatibility[i,j]*compatibility[j,i];

# subject to 3CycleCompatibility {(i,j,k) in Cycle3}: x3[i,j,k] <= compatibility[i,j]*compatibility[j,k]*compatibility[k,i];

# guarantee pair can only be in one of the cycles (either Cycle2 or Cycle3)
#subject to CycleLimit {(i,j) in Cycle2, (i,j,k) in Cycle3: i <> j and j <> k and i <> k}: x2[i,j]+x3[i,j,k] <= 1;

# guarantee pair can only be in one of the cycles (either Cycle2 or Cycle3)
subject to CycleLimit {i in PATIENT_DONOR_PAIRS}: sum { (i,j) in Cycle2: i <> j} x2[i,j] +  sum { (i,j) in Cycle2: i<>j} x2[j,i] + sum {(i,j,k) in Cycle3: i <> j and j <> k and i <> k} x3[i,j,k] + sum { (i,j,k) in Cycle3: i <> j and j <> k and i <> k} x3[j,k,i] +sum {(i,j,k) in Cycle3: i <> j and j <> k and i <> k} x3[k,i,j] <= 1;

