* Define the indeces or sets
Sets
i variables     /x1, x2/
j constr        /c1, c2/;

* Define the data (parameters, tables, scalars)
Parameter c(i) 
/
x1 3
x2 1
/
;

Parameter b(j) 
/
c1 -1
c2 10
/
;

Table data(j,i)
    x1      x2
c1  -1       -1
c2  2       4 
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
Model prob_2 /all /;

* Call solver
Solve prob_2 using lp maximizing z;

* print final levels and marginal cost
Display x.l, x.m;