$title Sensitivity analysis using LOOPS (SENSTRAN,SEQ=106)

$onText
This problem performs sensitivity analysis on the TRNSPORT
problem. The basic model is taken from the GAMS model
library. A separate model is solved for each variation of the
transport cost matrix. The transport cost on each link is raised
and lowered by 30 percent and the shipment patterns are either
saved in a GAMS data table or written to file for further analysis
by a statistical system.


Dantzig, G B, Chapter 3.3. In Linear Programming and Extensions.
Princeton University Press, Princeton, New Jersey, 1963.

Keywords: linear programming, sensitivity analysis, linear programming,
          transportation problem, scheduling
$offText

Set
   i 'canning plants' / seattle,  san-diego /
   j 'markets'        / new-york, chicago, topeka /;

Parameter
   a(i) 'capacity of plant i in cases'
        / seattle    350
          san-diego  600 /

   b(j) 'demand at market j in cases'
        / new-york   325
          chicago    300
          topeka     275 /;

Table d(i,j) 'distance in thousands of miles'
              new-york  chicago  topeka
   seattle         2.5      1.7     1.8
   san-diego       2.5      1.8     1.4;

Scalar f 'freight in dollars per case per thousand miles' / 90 /;

Parameter c(i,j) 'transport cost in thousands of dollars per case';
c(i,j) = f*d(i,j)/1000;

Variable
   x(i,j) 'shipment quantities in cases'
   z      'total transportation costs in thousands of dollars';

Positive Variable x;

Equation
   cost      'define objective function'
   supply(i) 'observe supply limit at plant i'
   demand(j) 'satisfy demand at market j';

cost..      z =e= sum((i,j), c(i,j)*x(i,j));

supply(i).. sum(j, x(i,j)) =l= a(i);

demand(j).. sum(i, x(i,j)) =g= b(j);

Model transport / all /;

$sTitle Sensitivity Part for trnsport
$eolCom //

Alias (i,ip), (j,jp);

Scalar
   sens    'sensitivity value'                    /  .3 /
   pors    'put or save option save = 0 put = 1'  / 0   /
   counter 'maximum number of problems'           / 4   /;

Parameter report(*,ip,jp,i,j) 'summary results';
File      repdat 'sensitivity data report file';

option limCol = 0, limRow = 0, solPrint = off;

pors    = 0;    // 'write file'
counter = 2;    // 'set to inf to run all problems'

if(pors,
   repdat.nw =  5;
   repdat.nd =  0;
   repdat.lw = 11;
   put repdat "low/high i          j                  x(i,j)" /;
);

counter = 20;
loop((ip,jp)$counter, counter = counter - 1;
   c(ip,jp) = c(ip,jp)*(1-sens);              // reduce cell
   solve transport using lp minimizing z;     // solve model
   if(pors,
      put / "low      ",ip.tl,jp.tl;          // write
      loop((i,j),                             // solution
         put x.l(i,j);                        // one solve per line
      );
   else
      report("low",ip,jp,i,j) = x.l(i,j);     // save results
   );
   c(ip,jp) = c(ip,jp)/(1 - sens)*(1 + sens); // increase cell
   solve transport using lp minimizing z;     // solve model
   c(ip,jp) = c(ip,jp)/(1 + sens);            // reset cell
   if(pors,
      put / "high     ",ip.tl,jp.tl;          // write
      loop((i,j),                             // solution
         put x.l(i,j));                       // one solve per line
   else
      report("high",ip,jp,i,j) = x.l(i,j)     // save results
   );
   if(not pors,
      option  report:3:3:2;
      display report;
   );
);
