* Define the indeces or sets
Sets
i manufacturers               /Arnold, Supershelf/
j industries /Zeron_N, Zeron_S/
m customers /Zrox, Hewes, Rockrite/;

* Define the data (parameters, tables, scalars)
Parameter a(i) max supply for each manufacturer
/
Arnold 75
Supershelf 75
/
;

Parameter b(m) demand for each customer
/
Zrox 50
Hewes  60
Rockrite 40
/
;

Table c(i,j, m) Shipping cost
                    Zrox    Hewes   Rockrite
Arnold.Zeron_N       6       10      13
Arnold.Zeron_S      11       12      12
Supershelf.Zeron_N   8       12      15
Supershelf.Zeron_S   7        8       8
;

* Define variables
Variables
z       total cost
x(i,j, m)  quantity of products shipped from i, distrib from j to m
Positive variables x;

* Define constrains and objective function
Equations
    of              objective function for the problem
    cap_constr      supply constraint
    dem_constr      demand constraint;

of..                z =e= sum((i,j, m), c(i,j, m)*x(i,j,m));
cap_constr(i)..     sum((j, m), x(i,j, m)) =l= a(i);
dem_constr(m)..     sum((i,j), x(i,j,m)) =e= b(m);

* declare model and assign equations (in this case use all of them)
Model transport2 /all/;

* Call solver
Solve transport2 using lp minimizing z;

* print final levels and marginal cost
Display x.l, x.m;
