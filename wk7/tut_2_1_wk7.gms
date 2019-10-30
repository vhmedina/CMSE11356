* Define the indeces or sets
Sets
i variables     /x1, x2, x3/
j constr        /c1, c2, c3, c4/;

* Define the data (parameters, tables, scalars)
Parameter c(i) 
/
x1 3
x2 5
x3 6
/
;

Parameter b(j) 
/
c1 4
c2 4
c3 4
c4 3
/
;

* Read from external file
Table data(j,i) 
$ondelim
$include table_const.csv
$offdelim
;

* Define variables
Variables
z           total
x(i)        decision variables
Positive variables x;

* Define constraints and objective function
Equations
    of              objective function for the problem
    constr(j)       constraints;

of..                z =e= sum(i, c(i)*x(i));
constr(j)..         sum(i,data(j, i)*x(i)) =l= b(j);

* declare model and assign equations (in this case use all of them)
Model prob_1 /all /;

* Call solver
Solve prob_1 using lp maximizing z;

* print final levels and marginal cost
Display x.l, x.m;

* Write to external file
File results / results.txt /;
results.pc = 5 ; 
put results;
put "Model status",  prob_1.modelstat /;
put "Solver status", prob_1.solvestat /;
put "Objective", z.l /;
put "Variables" /;
loop(i,
  put i.tl, x.l(i) /
);
putclose;