        ORG     $6000
SIZE:   EQU     10
count:  dc.w    SIZE      *there are 10 elements in the array
array:  dc.w    6,3,9,7,10,5,8,12,15,4
zeros:  ds.w    SIZE
ones:   ds.w    SIZE
        end
