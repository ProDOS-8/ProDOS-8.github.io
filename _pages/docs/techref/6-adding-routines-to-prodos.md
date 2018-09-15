---
layout:      page
title:       TechRef - Adding Routines to ProDOS
description: ProDOS 8 Technical Reference Manual Adding Routines to ProDOS
permalink:   /docs/techref/adding-routines-to-prodos/
---


<A NAME="6"><H1>Chapter 6<br />Adding Routines to ProDOS</H1></A><a name="page103"></a>

<P>This chapter explains device-handling routines that can be used with<br />
the ProDOS MLI.  Because such routines are connected to and interact<br />
with the MLI, they are essentially invisible to the BASIC system<br />
program described in Appendix A of this manual and in <I>BASIC<br />
Programming With ProDOS</I>.</P><P>Appendix A explains the rules for<br />
installing routines when the BASIC<br />
system program is active.</P><P>The types of routines described in this chapter are:</P><UL>

<LI>clock/calendar routines

<LI>interrupt handling routines

<LI>disk driver routines.

</UL>

<P><B>Note:</B> These routines must all begin with a CLD instruction and end<br />
with an RTS.</P><A NAME="6.1"><H2>6.1 - Clock/Calendar Routines</H2></A><P>ProDOS has a built-in clock driver that queries a clock/calendar card<br />
for the date and time.  After the routine stores that information in the<br />
ProDOS Global Page ($BF90-$BF93), either ProDOS or your own<br />
application programs can use it.  See Figure 6-1.</P><A NAME="6-1"><P><B>Figure 6-1.  ProDOS Date and Time Locations</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 49041 ($BF91)&nbsp;&nbsp;&nbsp;&nbsp; 49040 ($BF90)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7 6 5 4 3 2 1 0&nbsp;&nbsp; 7 6 5 4 3 2 1 0
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 DATE:&nbsp; |&nbsp;&nbsp;&nbsp; year&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; month&nbsp; |&nbsp;&nbsp; day&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7 6 5 4 3 2 1 0&nbsp;&nbsp; 7 6 5 4 3 2 1 0
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 TIME:&nbsp; |&nbsp;&nbsp;&nbsp; hour&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | |&nbsp;&nbsp;&nbsp; minute&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 49043 ($BF93)&nbsp;&nbsp;&nbsp;&nbsp; 49042 ($BF92)
</PRE><P>You can cause ProDOS to call the clock driver and to update the date<br />
and time by issuing a GET_TIME call (see Section 4.6.1).</P><P>ProDOS calls the clock driver routine for every call that might need<br />
the date and time: CREATE, DESTROY, RENAME SET_FILE_INFO<br />
CLOSE, and FLUSH.</P><a name="page104"></a>

<P>The ProDOS clock driver expects the clock card's firmware to return<br />
information in a certain way.  The ROM on the clock card must also<br />
follow Apple's identification convention if it is to be recognized by<br />
ProDOS at startup.</P><P>The ProDOS clock driver expects the clock card to send an ASCII<br />
string to the GETLN input buffer ($200).  This string must have the<br />
following format (including the commas):</P><P>mo,da,dt,hr,mn</P><P>where</P><P><I>mo</I> is the month (01 = January...12 = December)<br />
<I>da</I> is the day of the week (00 = Sunday...06 = Saturday)<br />
<I>dt</I> is the date (00 through 31)<br />
<I>hr</I> is the hour (00 through 23)<br />
<I>mn</I> is the minute (00 through 59)</P><P>For example:</P><P>07,04,14,22,46</P><P>would represent Thursday, July 14, 10:46 p.m.  The year is looked up<br />
in a table in the clock driver.</P><P>When the ProDOS system file is executed, it installs the address of the<br />
clock routine at $BF07, $BF08 -- whether there is a recognized clock<br />
card or not.</P><P>ProDOS recognizes a clock card if the following bytes are present in<br />
the Cn00 ROM:</P><P>$Cn00 = $08<br />
$Cn02 = $28<br />
$Cn04 = $58<br />
$Cn06 = $70</P><P>The address is preceded by a $4C (JMP) if a clock card is recognized,<br />
or by a $60 (RTS) if not.</P><P>The ProDOS clock driver uses the following addresses for its I/O to the<br />
clock:</P><P>Cn08 - READ entry point<br />
Cn0B - WRITE entry point</P><P>The accumulator is loaded with an #A3 before the JSR to the WRITE<br />
entry point.  This value could be used to let the clock card's firmware<br />
know in what format to leave the time.</P><P>The ProDOS driver takes the ASCII values sent by the clock, converts<br />
them to binary, and stores them in the ProDOS Global Page.</P><a name="page105"></a>

<P>The driver uses zero page locations $3A through $3E.  It also saves and<br />
restores the peripheral RAM card location $F8+n, where <I>n</I> is the slot<br />
where the card resides.</P><A NAME="6.1.1"><H3>6.1.1 - Other Clock/Calendars</H3></A><P>To support clock cards that do not follow the ProDOS protocol defined<br />
above, you can locate your code in a number of places.  The cleanest<br />
solution is to replace the ProDOS routines with your own, if they fit.</P><P>If you look at $BF07,$BF08, you will find the location to put your code.<br />
There is room for 125 bytes.</P><P>To install your code, simply write-enable the language card area, and<br />
move your code.  Your relocation code must justify the absolute<br />
addresses as part of the relocation procedure.  Finally, restore any soft<br />
switches you have changed.  (There is no guarantee as to the absolute<br />
location of the clock-driver code on future revisions of ProDOS, only<br />
that its location can be found by examining the global page.)</P><P>All that your code needs to do is get the time from the clock card,<br />
convert it to the ProDOS format, and store it in the date and time<br />
locations in the global page.</P><P>Your installation routine can be called either from an application<br />
program, or as part of the STARTUP program.</P><A NAME="6.2"><H2>6.2 - Interrupt Handling Routines</H2></A><P>To aid the development of software that can handle interrupts, the MLI<br />
provides a convention for interfacing interrupt driven devices.</P><P>To use interrupts, you must install from one to four interrupt receiving<br />
routines somewhere in memory.  It is up to you to check and update<br />
the system bit map to be sure that the routines do not conflict with<br />
ProDOS or other concurrently executing programs.</P><P>Once a routine is installed, you must use the ALLOC_INTERRUPT call<br />
to inform the MLI of the starting address of the receiving routine.  After<br />
this call has been successfully completed, you may enable the<br />
hardware for interrupts.</P><a name="page106"></a>

<P>When an interrupt occurs, the MLI's interrupt handler preserves the<br />
6502's registers, zero page locations $FA thru $ff, and, if the stack is<br />
more than 3/4 full, 16 bytes of the stack.  Then it calls each receiving<br />
routine (via JSR), one by one, in the order in which they were<br />
installed.  Each installed routine must begin with a CLD instruction.</P><P>When the routine that can process the interrupt is called, it should<br />
carry out its task, clear the interrupt on the hardware, and return (via<br />
an RTS) with the carry flag clear.  When a routine that cannot process<br />
the interrupt is called, it should return (via an RTS) with the carry<br />
flag set so that the MLI knows to call the next routine in the list.</P><P>As mentioned above, all 6502 registers, locations $FA thru $FF and if<br />
the stack is more than 3/4 full, 16 bytes of the stack, are preserved.<br />
The interrupt routine may use these resources freely for temporary<br />
data storage.</P><P><B>Note:</B> There is no general way for an interrupt routine to identify<br />
whether or not its device was the source of the interrupt.  This task<br />
depends on the specific characteristics of the device; in fact, some<br />
devices provide no mechanism for interrupt verification.  It is necessary<br />
to service such a device after all others have been polled.</P><P>If no installed and allocated routine claims a pending interrupt, a<br />
<B><TT>SYSTEM FAILURE</TT></B> message will be displayed and program<br />
execution will be halted.</P><P>When finished with a interrupt driven device, a<br />
DEALLOC_INTERRUPT call should be made, but only after the device<br />
itself is disabled.</P><P><B>Warning</B><br />
This warning does not apply to the Apple IIc nor to Apple IIe's<br />
with enhanced ROMs.  Because the Apple II Monitor program relies<br />
on a zero-page location ($45) that is overwritten when an<br />
interrupt occurs, you should disable interrupts while you are using<br />
the Monitor program.  The system also uses location $7F8 to store<br />
the I/O slot location that was in use before an interrupt occurred;<br />
do not use this location.</P><a name="page107"></a>

<A NAME="6.2.1"><H3>6.2.1 - Interrupts During MLI Calls</H3></A><P>The preceding section does not discuss what a program should do if an<br />
interrupt were to occur during the execution of an MLI call and your<br />
interrupt handling routine itself makes calls to the MLI.</P><P>The interrupt routine must allow the MLI to complete its current call<br />
before initiating a new call to the MLI.  The mechanism for doing this<br />
consists of changing the globals so that the MLI completes its call and<br />
returns to your routine rather than to the routine that originally<br />
called it.  Then your routine can use the MLI as needed.  When it is<br />
finished, it must restore the 6502 registers to the state they would<br />
have been in at completion of the MLI call had the interrupt not<br />
occurred, and then jump back to the proper address in the original<br />
routine.</P><P>To do this, the interrupt handling routine should first check the status<br />
of the MLI.  If the flag <B><TT>MLIACTV</TT></B> ($BF9B) has the high bit set, then<br />
the MLI was in the middle of a call.  Your routine should then:</P><OL>

<LI>Save the return address of the original caller (<B><TT>CMDADR</TT></B>, $BF9C),<br />
replacing it with the address to which the MLI should return on<br />
completion of the current call.

<LI>Claim the interrupt by disabling interrupts on the hardware, and<br />
clearing the carry flag.

<LI>RTS

<P>The MLI's interrupt handler believes that the interrupt has been<br />
processed, so it completes the current MLI call and returns to the<br />
address in <B><TT>CMDADR</TT></B>, which is actually in your routine.  Your routine<br />
should now do this:</P><LI>Save the A, X, Y, and P registers as the return state for the routine<br />
whose call just completed.

<LI>Use the MLI as needed.

<LI>Restore the A, X, Y, and P registers.

<LI>Jump to the original <B><TT>CMDADR</TT></B>.

</OL>

<P>The original program sees only that its MLI call was successfully<br />
completed, and it continues execution.</P><a name="page108"></a>

<A NAME="6.2.2"><H3>6.2.2 - Sample Interrupt Routine</H3></A><P>Here is a sample interrupt routine that reads the date from a<br />
clock/calendar card, and displays it in the upper-right corner of the<br />
screen once per second.  It assumes the card is in slot 2.</P><PRE>
 SOURCE&nbsp;&nbsp; FILE #01 =&#62;SHOWTIME
 ----- NEXT OBJECT FILE NAME IS SHOWTIME.0
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0300&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ORG&nbsp;&nbsp; $300
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C20B&nbsp;&nbsp;&nbsp; 2 WTTCP&nbsp;&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $C20B&nbsp;&nbsp;&nbsp;&nbsp; ;CLOCK WRITE ENTRY PT (SLOT 2)
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C208&nbsp;&nbsp;&nbsp; 3 RDTCP&nbsp;&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $C208&nbsp;&nbsp;&nbsp;&nbsp; ;CLOCK READ ENTRY PT (SLOT 2)
 0300;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C080&nbsp;&nbsp;&nbsp; 4 TCICR&nbsp;&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $C080&nbsp;&nbsp;&nbsp;&nbsp; ;INTERRUPT CONTROL REG (SLOT 2)
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C088&nbsp;&nbsp;&nbsp; 5 TCMR&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $C088&nbsp;&nbsp;&nbsp;&nbsp; ;MYSTERY REGISTER (SLOT 2)
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6 *
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0200&nbsp;&nbsp;&nbsp; 7 IN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $200&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;WHERE CLOCK LEAVES THE TIME
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8 *
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0412&nbsp;&nbsp;&nbsp; 9 UPRIGHT&nbsp;&nbsp; EQU&nbsp;&nbsp; $412&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;THE UPPER RIGHT OF THE SCREEN
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 047A&nbsp;&nbsp; 10 INTONI&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $47A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;LEAVE INTERRUPTS ON (SLOT 2)
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 07FA&nbsp;&nbsp; 11 INTON2&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $7FA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;LEAVE INTERRUPTS ON (SLOT 2)
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12 *
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BF00&nbsp;&nbsp; 13 MLI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EQU&nbsp;&nbsp; $BF00&nbsp;&nbsp;&nbsp;&nbsp; ;ENTRY POINT TO THE PRODOS MLI
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14 *
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15 * CALLING INTERRUPTS, CALLING INTERRUPTS
 0300:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 16 *
 0300:20 7E 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JSR&nbsp;&nbsp; ALLOC.INT ;HAVE MLI INSTALL INT ROUTINE
 0303:60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;THAT'S ALL FOLKS
 0304:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19 *
 0304:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20 *
 0304:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0304&nbsp;&nbsp; 21 SHOWTIME&nbsp; EQU&nbsp;&nbsp; *
 0304:D8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CLD
 0305:08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 23&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PHP
 0306:78&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 24&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SEI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;DISABLE INTERRUPTS
 0307:A0 20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDY&nbsp;&nbsp; #$20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; FOR SLOT 2
 O3O9;B9 80 C0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 26&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; TCICR,Y&nbsp;&nbsp; ;GET VAL OF INT CONTROL REG
 03OC:29 20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 27&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AND&nbsp;&nbsp; #$20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;CHK BIT 5 - IS INT FROM CLK?
 030E:F0 3C&nbsp;&nbsp; 034C&nbsp;&nbsp; 28&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BEQ&nbsp;&nbsp; NOTCLK&nbsp;&nbsp;&nbsp; ;IF BIT 5 OFF, INT NOT FROM CLK
 0310:B9 88 C0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 29&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; TCMR,Y&nbsp;&nbsp;&nbsp; ;CLEAR MYSTERY REGISTER
 0313:B9 80 C0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; TCICR,Y&nbsp;&nbsp; ;CLEAR INTERRUPT ON HARDWARE
 0316:CE 4F 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEC&nbsp;&nbsp; COUNTER&nbsp;&nbsp; ;ONLY PRINT TIME EVERY SECOND
 0319:D0 2E&nbsp;&nbsp; 0349&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BNE&nbsp;&nbsp; EXITCLK&nbsp;&nbsp; ; NOT TIME TO PRINT YET
 031B:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 33 *
 031B:A2 27&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 34&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDX&nbsp;&nbsp; #39&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;SAVE THE INPUT BUFFER
 031D:BD 00 02&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 35 DOIN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; IN,X&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; SINCE THE CLOCK WRITES OVER
 0320:9D 56 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 36&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; INBUF,X&nbsp;&nbsp; ; IT WHEN IT IS CALLED
 0323:CA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 37&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEX&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;
 0324:10 F7&nbsp;&nbsp; 031D&nbsp;&nbsp; 38&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BPL&nbsp;&nbsp; DOIN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;
 0326:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 39
 0326:A9 A5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; #$A5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;SET APPLESOFT STRING INPUT
 0328:20 0B C2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 41&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JSR&nbsp;&nbsp; WTTCP&nbsp;&nbsp;&nbsp;&nbsp; ; MODE & SEND IT TO THE CARD
 032B:20 08 C2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 42&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JSR&nbsp;&nbsp; RDTCP&nbsp;&nbsp;&nbsp;&nbsp; ;READ TIME INTO INPUT BUFFER
 032E:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 43
 032E:A2 15&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 44&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDX&nbsp;&nbsp; #21
 0330:BD 01 02&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 45 GETNEXT&nbsp;&nbsp; LDA&nbsp;&nbsp; IN+1,X&nbsp;&nbsp;&nbsp; ;PRINT TIME TO SCREEN
 0333:9D 12 04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 46&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; UPRIGHT,X ;CHARS 0-22 OF INPUT BUFFER
 0336:CA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 47&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEX&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;
 0337:10 F7&nbsp;&nbsp; 0330&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BPL&nbsp;&nbsp; GETNEXT&nbsp;&nbsp; ;
 0339:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 49
 0339:A9 40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 50 SETCNTR&nbsp;&nbsp; LDA&nbsp;&nbsp; #64&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;SET UP COUNTER FOR NEXT TIME
</PRE><a name="page109"></a>

<PRE>
 033B:8D 4F 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 51&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; COUNTER&nbsp;&nbsp; ;
 033E:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 52
 033E:A2 27&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 53&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDX&nbsp;&nbsp; #39&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;RESTORE THE INPUT BUFFER
 0340:BD 56 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 54 DOIN2&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; INBUF,X&nbsp;&nbsp; ;
 0343:9D 00 02&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 55&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; IN,X&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;
 0346:CA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 56&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEX&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;
 0347:10 F7&nbsp;&nbsp; 0340&nbsp;&nbsp; 57&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BPI&nbsp;&nbsp; DOIN2&nbsp;&nbsp;&nbsp;&nbsp; ;
 0349:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 58 *
 0349:28&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 59 EXITCLK&nbsp;&nbsp; PLP
 034A:18&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CLC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;TELL MLI INT WAS PROCESSED
 034B:60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 61&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RTS
 034C:28&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 62 NOTCLK&nbsp;&nbsp;&nbsp; PLP
 034D:38&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SEC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;TELL MLI IT ISN'T OURS
 034E:60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RTS
 034F:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 65 *
 034F:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0001&nbsp;&nbsp; 66 COUNTER&nbsp;&nbsp; DS&nbsp;&nbsp;&nbsp; 1,0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;
 0350;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 67 *
 0350:02 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 68 AIPARMS&nbsp;&nbsp; DFB&nbsp;&nbsp; 2,0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;PUT ALLOCATE AND DEALLOCATE
 0352:04 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 69&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DW&nbsp;&nbsp;&nbsp; SHOWTIME&nbsp; ; INTERRUPT PARAMETERS HERE,
 0354:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 70 *
 0354:01 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 71 DIPARMS&nbsp;&nbsp; DFB&nbsp;&nbsp; 1,0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; SO BOTH ROUTINES CAN USE THEM
 0356:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 72 *
 0356:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0028&nbsp;&nbsp; 73 INBUF&nbsp;&nbsp;&nbsp;&nbsp; DS&nbsp;&nbsp;&nbsp; 40,0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;SAVE 40 BYTES IN HERE
 037E:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 74 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; FOR INPUT BUFFER SAVE/RESTORE
</PRE><P>Note the important features of this routine:</P><OL>

<LI>The routine begins with a CLD instruction (line 22).

<LI>The routine checks to see if the IRQ interrupt is being caused by the<br />
clock/calendar card (lines 25-28).  If not, it returns with the carry set<br />
(lines 62-64).

<LI>If the interrupt belongs to the clock/calendar card, it clears the inter-<br />
rupt hardware (lines 29-30).

<LI>When it is done with the interrupt task, it returns with carry clear<br />
(lines 59-61).

</OL>

<a name="page110"></a>

<P>The following routine adds the interrupt routine to ProDOS using the<br />
ALLOC_INTERRUPT call.  Having done this, it then activates interrupts<br />
on the clock/calendar card.  Then a CLI instruction is executed to allow<br />
the 6502 to process interrupts.</P><PRE>
 03A0:A9 00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 94 DEALLOC.INT LDA #0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;DISABLE INTERRUPTS
 03A2:8D 7A 04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 95&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; INTON1&nbsp;&nbsp;&nbsp; ; IN THE THUNDERCLOCK
 03A5:8D FA 07&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 96&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; INTON2
 03A8:Ao 20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 97&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDY&nbsp;&nbsp; #$20
 03AA;99 80 C0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 98&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; TCICR,Y
 03AD:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 99 *
 03AD:AD 51 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; AIPARMS+1 ;GET INT_NUM
 03B0:8D 55 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 101&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; DIPARMS+1 ; FOR DEALLOCATION
 03B3:20 00 BF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 102&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JSR&nbsp;&nbsp; MLI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;CALL THE MLI TO
 03B6:41&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 103&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DFB&nbsp;&nbsp; $41&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; DEALLOCATE INT ROUTINE
 03B7:54 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 104&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DW&nbsp;&nbsp;&nbsp; DIPARMS
 03B9:D0 01&nbsp;&nbsp; 03BC&nbsp; 105&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BNE&nbsp;&nbsp; OOPS2&nbsp;&nbsp;&nbsp;&nbsp; ;BREAK ON ERROR
 03BB:60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 106&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;DONE
 03BC:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 107 *
 03BC:00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 108 OOPS2&nbsp;&nbsp;&nbsp;&nbsp; BRK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;BREAK ON ERROR
</PRE><P>The next routine disables interrupts on the clock/calendar card before<br />
removing the interrupt routine from ProDOS with a<br />
DEALLOC_INTERRUPT call.</P><PRE>
 037E:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 75
 037E:20 00 BF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 76 ALLOC.INT JSR&nbsp;&nbsp; MLI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;CALL THE MLI TO
 0381:40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 77&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DFB&nbsp;&nbsp; $40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; ALLOCATE THE INTERRUPT
 0382:50 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 78&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DW&nbsp;&nbsp;&nbsp; AIPARMS&nbsp;&nbsp; ;
 0384:D0 19&nbsp;&nbsp; 039F&nbsp;&nbsp; 79&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BNE&nbsp;&nbsp; OOPS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;BREAK ON ERROR
 0386:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80 *
 0386:A0 20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 81&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDY&nbsp;&nbsp; #$20
 0388:A9 AC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 82&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; #$AC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;SET 64HZ INTERRUPT RATE
 038A:20 0B C2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 83&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; JSR&nbsp;&nbsp; WTTCP&nbsp;&nbsp;&nbsp;&nbsp; ; BY WRITING A ',' To CLOCK
 038D:A9 40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 84&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; #$40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;NOW ENABLE THE SOFTWARE
 038F:8D 7A 04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 85&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; INTON1&nbsp;&nbsp;&nbsp; ; AND TELL IT NOT TO DISABLE
 0392:8D FA 07&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 86&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; INTON2&nbsp;&nbsp;&nbsp; ; INTERRUPTS AFTER READS
 0395:99 80 C0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 87&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; TCICR,Y
 0398:A9 01&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 88&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LDA&nbsp;&nbsp; #1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;PRINT TIME IMMEDIATELY
 039A:8D 4F 03&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 89&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STA&nbsp;&nbsp; COUNTER&nbsp;&nbsp; ; ONCE PER SECOND LATER
 039D:58&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 90&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CLI&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;ALLOW THE 6502 TO SEE THE
 039E:60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 91&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RTS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ; INTERRUPTS
 039F:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 92 *
 039F:00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 93 OOPS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BRK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;BREAK ON ERROR
</PRE><a name="page111"></a>

<A NAME="6.3"><H2>6.3 - Disk Driver Routines</H2></A><P>If a disk drive supplied by another manufacturer is to work with<br />
ProDOS, it must look and act just like a disk drive supplied by Apple<br />
Computer, Inc.  Its boot ROM must have certain things in certain<br />
locations, and its driver routine must use certain zero-page locations for<br />
its call parameters.</P><A NAME="6.3.1"><H3>6.3.1 - ROM Code Conventions</H3></A><P>During startup, ProDOS searches for block storage devices.  If it finds<br />
the following three bytes in the ROM of a particular slot, ProDOS<br />
assumes it has found a disk drive (<I>n</I> represents slot number):</P><P>$Cn01 = $20<br />
$Cn03 = $00<br />
$Cn05 = $03</P><P>If $CnFF = $00, ProDOS assumes it has found a Disk II with 16-sector<br />
ROMs and marks the device driver table in the ProDOS global page<br />
with the address of the Disk II driver routines.  The Disk II driver<br />
routines support any drive that emulates Apple's 16-sector Disk II (280<br />
blocks, single volume, and so on).</P><P>If $CnFF = $FF, ProDOS assumes it has found a Disk II with 13-sector<br />
ROMs, which ProDOS does not support.</P><P>If ProDOS finds a value other than $00 or $FF at $CnFF, it assumes it<br />
has found an intelligent disk controller.  If the STATUS byte at $CnFE<br />
indicates that the device supports READ and STATUS requests,<br />
ProDOS marks the global page with a device-driver address whose<br />
high-byte is equal to $Cn and whose low-byte is equal to the value<br />
found at $CnFF.</P><a name="page112"></a>

<P>The only calls to the disk driver are STATUS, READ, WRITE, and<br />
FORMAT.  The STATUS call should perform a check to verify that the<br />
device is ready for a READ or WRITE.  If it is not, the carry should be<br />
set and the appropriate error code returned in the accumulator.  If the<br />
device is ready for a READ or WRITE, then the driver should clear the<br />
carry, place a zero in the accumulator, and return the number of<br />
blocks on the device in the X-register (low-byte) and Y-register<br />
(high-byte).</P><P>If you wish to interface a disk controller card with more than two<br />
drives (or a device with more than two volumes), additional device<br />
driver vectors for disk controllers plugged into slot 5 or 6 may be<br />
installed in slot 1 or 2 locations.  There will be no conflict with<br />
character devices physically present in these slots.</P><P>Device numbers for four drives in slot 5 or 6 are listed below.</P><P>Physical Slot Five:<br />
S5,D1 = $50<br />
S5,D2 = $D0<br />
S1,D1 = $10<br />
S1,D2 = $90</P><P>Physical Slot Six:<br />
S6,D1 = $60<br />
S6,D2 = $E0<br />
S2,D1 = $20<br />
S2,D2 = $A0</P><a name="page113"></a>

<P>The special locations in the ROM code are:</P><DL><DT>$CnFC-<br />
$CnFD
<DD>The total number of blocks on the device.  Used for<br />
writing the disk's bit map and directory header after<br />
formatting.  (If this location is $0000, it indicates that<br />
the number of blocks must be obtained by making a<br />
STATUS request.)</DL><DL><DT>$CnFE
<DD>The status byte (bits 0 and 1 must be set for ProDOS<br />
to install the driver vector.)<br />
bit 7 - Medium is removable.<br />
bit 6 - Device is interruptible.<br />
bit 5-4 - Number of volumes on the device (0-3).<br />
bit 3 - The device supports formatting.<br />
bit 2 - The device can be written to.<br />
bit 1 - The device can be read from (must be on).<br />
bit 0 - The device's status can be read<br />
-- (must be on).</DL><DL><DT>$CnFF<br />
<DD>The low-byte of entry to the driver routines.  ProDOS<br />
will place $Cn + this byte in the global page.</DL><A NAME="6.3.2"><H3>6.3.2 - Call Parameters</H3></A><P>parameters are passed to the driver are:</P><DL><DT>
$42<br />
Command:
<DD>0 = STATUS request<br />
1 = READ request<br />
2 = WRITE request<br />
3 = FORMAT request</DL><P><B>Note:</B> The FORMAT code in the driver need only lay down address<br />
marks if required.  The calling routine should write the virgin directory<br />
and bit map.</P><a name="page114"></a>

<DL><DT>$43<br />
Unit Number:
<DD>
<PRE>
&nbsp;&nbsp;&nbsp; 7&nbsp; 6&nbsp; 5&nbsp; 4&nbsp; 3&nbsp; 2&nbsp; 1&nbsp; 0
&nbsp; +--+--+--+--+--+--+--+--+
&nbsp; |DR|&nbsp; SLOT&nbsp; | NOT USED&nbsp; |
&nbsp; +--+--+--+--+--+--+--+--+
</PRE></DL><P><B>Note:</B> The UNIT_NUMBER that appears in the device list (DEVLST)<br />
in the system globals will include the high nibble of the status byte<br />
($CnFE) as an ID in its low nibble.</P><DL><DT>$44-$45<br />
Buffer Pointer:
<DD>Indicates the start of a 512-byte memory<br />
buffer for data transfer.</DL><DL><DT>$46-$47<br />
Block Number:
<DD>Indicates the block on the disk for data<br />
transfer.</DL><P>The device driver should report errors by setting the carry flag and<br />
loading the error code into the accumulator.  The error codes that<br />
should be implemented are:</P><P>$27 - I/O error<br />
$28 - No device connected<br />
$2B - Write protected</P><a name="page115"></a>

<a name="page116"></a>
