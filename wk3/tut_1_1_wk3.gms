* Define the indeces or sets
Sets
i plants               /Manchester, Glasgow/
j distribution centres /Edinburgh, Aberdeen, Newcastle/;

* Define the data (parameters, tables, scalars)
Parameter a(i) capacity of each plant (L)
/
Manchester 20000
Glasgow 15000
/
;

Parameter b(j) Demand of L required
/
Edinburgh 10000
Aberdeen  8000
Newcastle 15000
/
;

Table c(i,j) Shipping cost
            Edinburgh  Aberdeen  Newcastle
Manchester      2          3         5
Glasgow         3          1         4
;

* Define variables
Variables
z       total cost
x(i,j)  quantity of products shipped from i to j
Positive variables x;

* Define constrains and objective function
Equations
    of              objective function for the problem
    cap_constr      capacity constraint
    dem_constr      demand constraint;

of..                z =e= sum((i,j), c(i,j)*x(i,j));
cap_constr(i)..     sum(j, x(i,j)) =l= a(i);
dem_constr(j)..     sum(i, x(i,j)) =e= b(j);

* declare model and assign equations (in this case use all of them)
Model transport1 /all/;

* Call solver
Solve transport1 using lp minimizing z;

* print final levels and marginal cost
Display x.l, x.m;
