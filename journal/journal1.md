
## BROADCAST (`cycler.v`)

Following the fundamental premise of cycling through and broadcasting operands/results, I wrote a module to cycle through 1-bit operands and results for basic logical/arithmetic operations.


|A | B | X(reserved) | carry1/OR | sum1/EQ | sum0/XOR | carry0/AND | LT |
|:---|:---|:---|:---|:---|:---|:---|:---|
0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |   
1 | 0 | 0 | 1 | 0 | 1 | 0 | 0 |
1 | 1 | 0 | 1 | 1 | 0 | 1 | 0 |


The A and B columns represent operands while the rest represent results. 

To reduce the cycle period, rather than make the carry_in an operand, there are different result columns for when the carry-in is 0 (`carry0`, `sum0`) and when the carry-in is 1(`carry1,sum1`). Fortunately, these results correspond with other elementary operations :)

I'm calling each line from the truth table a vector.
```
    operands = vector[7:6]
    results = vector[4:0]
```


## RECEIVER (`alu-serial-t1.v`)
The table is structured in such a way that a filter and a reduced OR operation can be used to select the results -> `result=OR(filter&vector[4:0]`). As an example, for the AND operation the filter would be `00001`.

** The `ADD` operation has a few extra steps to deal with carries.



## PERFORMANCE
😂️😂️😂️😂️😂️        😂️😂️😂️😂️😂️    😂️😂️😂️😂️😂️  
The performance is (expectedly) bad. In the worst case  it'll take 128 clock cycles to complete a single 32-bit operation. I suspect that the average case is not much better. Caching results would improve performance significantly (worst case 36 clock cycles) but at the cost of using at least 8 more registers. 



0, 83, 147, 206
48, 107, 171, 254


2 -> 2, 1, 4
3 -> 3, 5, 6
4 -> 4, 1, 2
5 -> 5, 6, 3
6 -> 6, 3, 5
7 -> 7