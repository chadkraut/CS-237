*----------------------------------------------------------------------
* Programmer: Chad Krauthamer 
* Class Account: masc0759
* Assignment or Title: Program 1
* Filename: prog1.s
* Date completed: 3/8/16 
*----------------------------------------------------------------------
* Problem statement: Write a program that takes user input and 
* converts it to latin
* Input: user 
* Output: latin
* Error conditions tested: none
* Included files: none
* Method and/or pseudocode: none
* References: none
*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000        * Stack pointer value after a
			      * reset
        DC.L    start           * Program counter value after a 
			     * reset
        ORG     $3000           * Start at location 3000 Hex
*
*----------------------------------------------------------------------
*
#minclude /home/ma/cs237/bsvc/iomacs.s
#minclude /home/ma/cs237/bsvc/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use
*
*----------------------------------------------------------------------
*	
start:  initIO          				* Initialize (required for I/O)
	setEVT				* Error handling routines
*	initF					* For floating point macros only

	lea		words,A1		*moves words values into A1 register
	lineout		title		
	lineout		prompt
	linein		buffer
	cvta2		buffer,D0		*convert from ascii to 2's comp
	move.l		D0,D1		
	sub.l		#1,D1			*subtracts 1 from user inputed value
	mulu		#16,D1		*multiplies D1 by 16 
	adda.l		D1,A1			*adds the D1 value to the address A1 
							*finds where the input value is
	move.l		(A1),number		*gets contents of A1 and moves to
						*number move.l uses the 1st 4 values
						*in order to not overwrite these I kept 
						*adding 4 more spaces
	adda.l		#4,A1		
	move.l		(A1),number+4
	adda.l		#4,A1
	move.l		(A1),number+8
	adda.l		#4,A1
	move.l		(A1),number+12
	lineout		answer
	



        break                  	 * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
title:		dc.b		'Program #1, Chad Krauthamer, masc0759',0
words:		dc.b		'unus.          ',0
		dc.b		'duo.           ',0
		dc.b		'tres.          ',0
		dc.b		'quattuor.      ',0
		dc.b		'quinque.       ',0
		dc.b		'sex.           ',0
		dc.b		'septem.        ',0
		dc.b		'octo.          ',0
		dc.b		'novem.         ',0
		dc.b		'decem.         ',0
		dc.b		'undecim.       ',0
		dc.b		'duodecim.      ',0
		dc.b		'tredecim.      ',0
		dc.b		'quattuordecim. ',0
		dc.b		'quindecim.     ',0
prompt:	dc.b		'Please enter an integer in the range 1..15',0
buffer:		ds.b		81
answer: 	dc.b		'That number in Latin is '
number:	ds.b		16
				
        end
