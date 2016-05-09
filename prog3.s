*----------------------------------------------------------------------
* Programmer: Chad Krauthamer
* Class Account: masc0759
* Assignment or Title: prog3
* Filename: prog3.s
* Date completed:  4/18/2016
*----------------------------------------------------------------------
* Problem statement: Sort an array using a Radix sort
* Input: datafile2.s
* Output: Sorted array in ,outfile*
* Error conditions tested: none
* Included files: datafile2.s
* Method and/or pseudocode: radix sort pseudocode
* References: TA, Programmer's Manual, Alan Riggins
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
* Register use: A0=zero bucket
*		A1=ones bucket
*		A2=array
*		A3=output
*		A4=copy of zero bucket address
*		A5=copy of ones bucket address
*		SIZE=D7,D3, $6000
*		ARRAY=SIZE+2
*		Shift Register=D6
*		D0=holds data temporarily
*		D4=zero counter
*		D5=ones counter
*
*----------------------------------------------------------------------
*
SIZE:	EQU	$6000
ARRAY:	EQU	SIZE+2

start: 
	initIO                	 		 * Initialize (required for I/O)
	setEVT				* Error handling routines
*	initF					* For floating point macros only
	lea		ARRAY,A2		*load ARRAY's address into A2
	lea		output,A3		*load output's address into A3
	move.w 	SIZE,D7
	move.w	SIZE,D3		*make a copy of size in D3 & D7
	subq.w	#1,D7	
	lineout		title
	lineout		prompt
	
print:	
	move.w	(A2)+,D0		*copy contents of A2 to D0
	andi.l		#$0000FFFF,D0	
	cvt2a		(A3),#6		*convert to ascii
	stripp		(A3),#6		*strip leading zeros
	adda.l		D0,A3		
	move.b	#',',(A3)+
	move.b	#' ',(A3)+
	dbra		D7,print		*loop to print D7 times
	clr.b		-2(A3)
	lineout 	output	
	
	moveq	#15,D7
	clr.l		D6			*Shift Register
Outer:	
	lea		ARRAY,A2	
	movea.l	A2,A0			*copy of 0&1
	move.w	SIZE,D0		*size = 10 D0=10
	asl.w		#1,D0			*multiply D0 by 2
	adda.l		D0,A0			*zero bucket A0 (size*2)+array
	movea.l	A0,A1		
	adda.l		D0,A1			*One bucket A1 ((size*2)+array)*2
	clr.l		D4			*zero bucket counter D4
	clr.l		D5			*one bucket counter D5
	move.w	SIZE,D3
	subq.w	#1,D3			*D3=Inner loop counter    
	movea.l	A0,A4			*make a copy of A0's address
	movea.l	A1,A5			*make a copy of A1's address
	
Inner:	
	move.w	(A2),D0		*copy contents of A2 to D0
	lsr.w		D6,D0			*shift by shift register
	andi.w		#1,D0			*compare to 1 
	tst.w		D0			*test nzvc
	beq		to_zero		*branch to zero if D0=0
	move.w 	(A2)+,(A1)+		*copy A2 to ones bucket
	addq.w	#1,D5			*add 1 to one counter
	bra		goTo			*branch to goTo if D0=1
	
to_zero:
	move.w 	(A2)+,(A0)+		*copy A2 to zero bucket
	addq.w	#1,D4			*add 1 to zero counter	
	
goTo:	
	dbra		D3,Inner		*loop to Inner D3 times

	movea.l	A4,A0			*reinitialize A0
	movea.l	A5,A1			*reinitialize A1
	lea		ARRAY,A2		*reinitialize A2
		
	tst.w		D4			*test D4 nzvc
	beq		One			*branch to One if zero
	subq.w	#1,D4
Zero:	
	move.w	(A0)+,(A2)+		*copy zero bucket into A2
	dbra		D4,Zero		*loop to Zero D4 times
		
One:	
	tst.w		D5			*test D4 nzvc
	beq		next			*branch if 0
	subq.w	#1,D5
cp_one:
	move.w	(A1)+,(A2)+		*copy ones bucket into A2
	dbra		D5,cp_one		*loop to One D5 times
	
next:	
	addq.l 	#1,D6			*shift register++
	dbra		D7,Outer		*loop to Outer D7 times
	
	lea		ARRAY,A2		*reinitialize A2
	lea		output,A3		*reinitialize A3
	move.w 	SIZE,D7
	subq.w	#1,D7			*reinitialize D7
	lineout		prompt2
			
print2:	
	move.w	(A2)+,D0		*same as print
	andi.l		#$0000FFFF,D0
	cvt2a		(A3),#6	
	stripp		(A3),#6
	adda.l		D0,A3
	move.b	#',',(A3)+
	move.b	#' ',(A3)+	
	dbra		D7,print2		*loop to print2
	clr.b		-2(A3)
	lineout 	output

        	break                  			 * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
title:		dc.b	'Programming Assignment #3, Chad Krauthamer, masc0759',0
prompt:	dc.b	'The unsorted array:',0
output:	ds.b	700
prompt2:	dc.b	'The sorted array:',0
	
        end
