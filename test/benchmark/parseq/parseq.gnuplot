f1(x) = a*x
a = 0.5
fit f1(x) 'parseq_benchmark.dat' using 1:2 via a

f2(x) = b*x
b = 0.5
fit f2(x) 'parseq_benchmark.dat' using 1:3 via b

f3(x) = c*x
c = 0.5
fit f3(x) 'parseq_benchmark.dat' using 1:4 via c

plot a*x        title 'a*x (treetop)',\
     b*x        title 'b*x (anagram tt)',\
     c*x        title 'c*x (anagram gen)',\
     "parseq_benchmark.dat" using 1:2 title 'treetop', \
     "parseq_benchmark.dat" using 1:3 title 'anagram tt', \
     "parseq_benchmark.dat" using 1:4 title 'anagram gen'



     
