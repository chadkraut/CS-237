* Reduce.s:

	ORG 		$8000
GCD:	EQU		$7000

reduce:
	link		A6,#0		*save return address
	movem.l	A0/A1,-(SP)	*push adress register onto stack
	movea.l	8(A6),A0	*get contents off stack
	movea.l	12(A6),A1
	move.w	(A0),-(SP)	*push contents onto stack
	move.w	(A1),-(SP)
	jsr		GCD		*jump to GCD
	adda.l		#4,SP		*pop garbage
	
	
	move.w	(A0),D1	*move contents to data register
	ext.l		D1		*extend contents for division
	move.w	(A1),D2
	ext.l		D2
	divu		D0,D1		*num/GCD
	divu		D0,D2		*den/GCD
	move.w	D1,(A0)	*copy reduced num to (A0)
	move.w	D2,(A1)	*copy reduced den to (A1)
	
	movem.l	(SP)+,A0/A1	*pop adress registers off stack
	unlk		A6		
	rts
	end
