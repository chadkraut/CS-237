*----------------------------------------------------------------------
* Programmer: Chad Krauthamer
* Class Account: masc0759
* Assignment or Title: Program #4
* Filename: prog4.s
* Date completed:  5/05/16
*----------------------------------------------------------------------
* Problem statement: Reduce a fraction with euclidean algorithm
* Input: User
* Output: ,outfile*
* Error conditions tested: invalid fraction
* Included files: getInput.h68, reduce.s, GCD.s, prog4.s
* Method and/or pseudocode: euclidean algorithm
* References: TA
*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000           * Stack pointer value after a reset
        DC.L    start           * Program counter value after a reset
        ORG     $3000           * Start at location 3000 Hex
*
*----------------------------------------------------------------------
*
#minclude /home/ma/cs237/bsvc/iomacs.s
#minclude /home/ma/cs237/bsvc/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use:	A0 is used for printing in prog4
*		A0 is used as an address register in reduce and GCD
*		A1 is used as an address register in reduce and GCD
*		D0 is used as a data register in reduce and GCD
*		D1 is used as a data register in reduce and GCD
*		D2 is used as a data register in reduce and GCD
*
*----------------------------------------------------------------------
*
input:	EQU	$6000
reduce:	EQU	$8000
start:  initIO 				* Initialize (required for I/O)
	setEVT			* Error handling routines
*	initF				* For floating point macros only	

	lineout		prompt		*print program title
	pea		den		*push denominator onto stack
	pea		num		*push	numerator onto stack
	pea		prompt1	*push prompt onto stack
again:	jsr		input		*jump to getInput
	
	bvc		done		*branch to done if v clear
	lineout		error		*print error prompt
	bra		again		*recurse to getInput
	
done:	adda.l		#12,SP		*pop garbage
	pea		den		*push denominator onto stack
	pea 		num		*push numerator onto stack
	jsr		reduce		*jump to reduce
	adda.l		#8,SP		*pop garbage
		
	lea		frac,A0		
	move.w	num,D0		
	andi.l		#$0000FFFF,D0	
	cvt2a		(A0),#5		
	stripp		(A0),#5
	adda.l		D0,A0
	move.b		#'/',(A0)+
	move.w	den,D0
	andi.l		#$0000FFFF,D0
	cvt2a		(A0),#5
	stripp		(A0),#5
	adda.l		D0,A0
	clr.b		(A0)
	lineout		ans

        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations

prompt:	dc.b	'Program #4, Chad Krauthamer, masc0759',0
prompt1:dc.b	'Enter a fraction to reduce: ',0
error:	dc.b	'Invalid fraction, please try again',0
num:	ds.w	1
den:	ds.w	1
ans:	dc.b	'The reduced fraction is '
frac:	ds.b	15

	end
