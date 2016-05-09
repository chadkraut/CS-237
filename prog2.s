*----------------------------------------------------------------------
* Programmer: Chad Krauthamer
* Class Account: masc0759
* Assignment or Title: Program #2
* Filename: prog2.s
* Date completed: 3/22/16 
*----------------------------------------------------------------------
* Problem statement: solve (aX2+2bX2Y3+cY2-dX2Y)/(dX2+eY2+fxb)+4Z2-2ad
* Input: datafile.s
* Output: size word
* Error conditions tested: none 
* Included files: datafile.s
* Method and/or pseudocode: n/a
* References: TA, Programmer’s manual
*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000           * Stack pointer value after a reset
        DC.L    start              * Program counter value after a reset
        ORG     $3000          * Start at location 3000 Hex
*
*----------------------------------------------------------------------
*
#minclude /home/ma/cs237/bsvc/iomacs.s
#minclude /home/ma/cs237/bsvc/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use: They change each time a data register is overwritten
* For example: x is stored in D1, then becomes x^2
*
*----------------------------------------------------------------------
*
DATA:	EQU		$6000
b:	EQU		DATA+2
c:	EQU		b+2
d:	EQU		c+2
e:	EQU		d+2
f:	EQU		e+2
x:	EQU		f+2
y:	EQU		x+2
z:	EQU		y+2		* datafile reference
start: 	initIO                  		* Initialize (required for I/O)
       	setEVT                  		* Error handling routines
*	initF				* For floating point macros only
	lineout		title		
	move.w	x,D1
	move.w	y,D2
	muls		D1,D1		*x^2
	move.w	D1,D4
	muls		DATA,D4	*ax^2		
	muls		D2,D2		*y^2
	move.w	D2,D5
	muls		y,D5		*y^3
	muls		D1,D5		*x^2y^3
	muls		b,D5		*bx^2y^3
	asl.w		#1,D5		*2bx^2y^3
	add.w		D4,D5		*ax^2+2bx^2y^3
	muls		D6,D6		*y^2
	muls		c,D6		*cy^2
	add.w		D6,D5		*ax^2+2bx^2y^3+cy^2 in D5
	muls		y,D1		*x^2y
	muls		d,D1		*dx^2y
	neg.w		D1		*-dx^2y
	add.w		D1,D5		*ax^2+2bx^2y^3+cy^2-dx^2y
	move.w	x,D1
	move.w	x,D2
	move.w	y,D3
	muls		f,D1
	muls		b,D1		*fxb	
	muls		D2,D2		*x^2
	muls		d,D2		*dx^2
	add.w		D2,D1		*dx^2+fxb
	muls		D3,D3		*y^2
	muls		e,D3		*ey^2
	add.w		D3,D1		*dx^2+ey^2+fxb
	ext.l		D5
	divs		D1,D5		*(ax^2+2bx^2y^3+cy^2-dx^2y)/(dx^2+ey^2+fxb)
	move.w	z,D2
	muls		D2,D2		*z^2
	asl.w		#2,D2		*4z^2
	move.w	d,D4
	muls		DATA,D4	*ad
	asl.w		#1,D4		*2ad
	neg.w		D4		*-2ad
	add.w		D4,D2		*4z^2-2ad
	add.w		D5,D2	*(ax^2+2bx^2y^3+cy^2-dx^2y)/(dx^2+ey^2+fxb)+4z^2-2ad
	move.w	D2,D0
	ext.l		D0		*extend to long word
	cvt2a		answer,#6 	*convert to ascii
	stripp		answer,#6	 *remove leading zeros
	lea		answer,A0
	adda.l		D0,A0
	clr.b		(A0)
	lineout 	prompt

	
				


        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
title:	dc.b	'Program #2, Chad Krauthamer, masc0759',0
prompt:	dc.b	'The answer is: '
answer:	ds.b	8
	dc.b	0


        end
