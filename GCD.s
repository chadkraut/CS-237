* GCD.s:

	ORG		$7000
GCD:
	link		A6,#0		*save return address
	movem.l	D1-D2,-(SP)	*copy data registers
	move.w	8(A6),D1	*A
	move.w	10(A6),D2	*B
	
	tst.w		D2		*tst if (b==0)
	bne		loop		*branch if not 0
	move.w  	D1,D0		*return b
	bra		done	
loop:	
	ext.l		D1		*extend D1 for divu
	divu.w		D2,D1		*a/b
	swap		D1		*swap for a % b
	ext.l		D1		
	move.w	D1,-(SP)	*push (a % b) onto stack
	move.w	D2,-(SP)	*push b onto stack
	jsr		GCD		*recurse to GCD
	adda.l		#4,SP		*pop garbage
	
done:		
	movem.l	(SP)+,D1-D2	*pop D1-D2 off stack
	unlk		A6
	rts
	end
