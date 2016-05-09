        ORG     $6000
SIZE:   EQU     10
count:  dc.w    SIZE      *there are 10 elements in the array
array:  dc.w    562,307,16,449,98,555,309,713,2,84
zeros:  ds.w    SIZE
ones:   ds.w    SIZE
        end
