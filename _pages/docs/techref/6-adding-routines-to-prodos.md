---
layout:      page
title:       TechRef - Adding Routines to ProDOS
description: ProDOS 8 Technical Reference Manual Adding Routines to ProDOS
permalink:   /docs/techref/adding-routines-to-prodos/
---


<A NAME="6"></A>

<a name="page103"></a>

<P>This chapter explains device-handling routines that can be used with the ProDOS MLI.  Because such routines are connected to and interact with the MLI, they are essentially invisible to the BASIC system program described in Appendix A of this manual and in <I>BASIC Programming With ProDOS</I>.</P>

<P>Appendix A explains the rules for installing routines when the BASIC system program is active.</P>

<P>The types of routines described in this chapter are:</P>

<UL>

<LI>clock/calendar routines</li>

<LI>interrupt handling routines</li>

<LI>disk driver routines.</li>

</UL>

<P><B>Note:</B> These routines must all begin with a CLD instruction and end with an RTS.</P>

<A NAME="6.1"></A>

<H2>6.1 - Clock/Calendar Routines</H2>

<P>ProDOS has a built-in clock driver that queries a clock/calendar card for the date and time.  After the routine stores that information in the ProDOS Global Page ($BF90-$BF93), either ProDOS or your own application programs can use it.  See Figure 6-1.</P>


<A NAME="6-1"></A>

<P><B>Figure 6-1.  ProDOS Date and Time Locations</B></P>


<PRE>
          49041 ($BF91)     49040 ($BF90)

         7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 DATE:  |    year     |  month  |   day   |
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

         7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 TIME:  |    hour       | |    minute     |
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

          49043 ($BF93)     49042 ($BF92)
</PRE>

<P>You can cause ProDOS to call the clock driver and to update the date and time by issuing a GET_TIME call (see Section 4.6.1).</P>

<P>ProDOS calls the clock driver routine for every call that might need the date and time: CREATE, DESTROY, RENAME SET_FILE_INFO CLOSE, and FLUSH.</P>

<a name="page104"></a>

<P>The ProDOS clock driver expects the clock card's firmware to return information in a certain way.  The ROM on the clock card must also follow Apple's identification convention if it is to be recognized by ProDOS at startup.</P>

<P>The ProDOS clock driver expects the clock card to send an ASCII string to the GETLN input buffer ($200).  This string must have the following format (including the commas):</P>

<P>mo,da,dt,hr,mn</P>

<P>where</P>

<P><I>mo</I> is the month (01 = January...12 = December) <I>da</I> is the day of the week (00 = Sunday...06 = Saturday) <I>dt</I> is the date (00 through 31) <I>hr</I> is the hour (00 through 23) <I>mn</I> is the minute (00 through 59)</P>

<P>For example:</P>

<P>07,04,14,22,46</P>

<P>would represent Thursday, July 14, 10:46 p.m.  The year is looked up in a table in the clock driver.</P>

<P>When the ProDOS system file is executed, it installs the address of the clock routine at $BF07, $BF08 -- whether there is a recognized clock card or not.</P>

<P>ProDOS recognizes a clock card if the following bytes are present in the Cn00 ROM:</P>

<P>$Cn00 = $08 $Cn02 = $28 $Cn04 = $58 $Cn06 = $70</P>

<P>The address is preceded by a $4C (JMP) if a clock card is recognized, or by a $60 (RTS) if not.</P>

<P>The ProDOS clock driver uses the following addresses for its I/O to the clock:</P>

<P>Cn08 - READ entry point Cn0B - WRITE entry point</P>

<P>The accumulator is loaded with an #A3 before the JSR to the WRITE entry point.  This value could be used to let the clock card's firmware know in what format to leave the time.</P>

<P>The ProDOS driver takes the ASCII values sent by the clock, converts them to binary, and stores them in the ProDOS Global Page.</P>

<a name="page105"></a>

<P>The driver uses zero page locations $3A through $3E.  It also saves and restores the peripheral RAM card location $F8+n, where <I>n</I> is the slot where the card resides.</P>


<A NAME="6.1.1"></A>

<H3>6.1.1 - Other Clock/Calendars</H3>



<P>To support clock cards that do not follow the ProDOS protocol defined above, you can locate your code in a number of places.  The cleanest solution is to replace the ProDOS routines with your own, if they fit.</P>

<P>If you look at $BF07,$BF08, you will find the location to put your code. There is room for 125 bytes.</P>

<P>To install your code, simply write-enable the language card area, and move your code.  Your relocation code must justify the absolute addresses as part of the relocation procedure.  Finally, restore any soft switches you have changed.  (There is no guarantee as to the absolute location of the clock-driver code on future revisions of ProDOS, only that its location can be found by examining the global page.)</P>

<P>All that your code needs to do is get the time from the clock card, convert it to the ProDOS format, and store it in the date and time locations in the global page.</P>

<P>Your installation routine can be called either from an application program, or as part of the STARTUP program.</P>

<A NAME="6.2"></A>

<H2>6.2 - Interrupt Handling Routines</H2>

<P>To aid the development of software that can handle interrupts, the MLI provides a convention for interfacing interrupt driven devices.</P>

<P>To use interrupts, you must install from one to four interrupt receiving routines somewhere in memory.  It is up to you to check and update the system bit map to be sure that the routines do not conflict with ProDOS or other concurrently executing programs.</P>

<P>Once a routine is installed, you must use the ALLOC_INTERRUPT call to inform the MLI of the starting address of the receiving routine.  After this call has been successfully completed, you may enable the hardware for interrupts.</P>


<a name="page106"></a>

<P>When an interrupt occurs, the MLI's interrupt handler preserves the 6502's registers, zero page locations $FA thru $ff, and, if the stack is more than 3/4 full, 16 bytes of the stack.  Then it calls each receiving routine (via JSR), one by one, in the order in which they were installed.  Each installed routine must begin with a CLD instruction.</P>

<P>When the routine that can process the interrupt is called, it should carry out its task, clear the interrupt on the hardware, and return (via an RTS) with the carry flag clear.  When a routine that cannot process the interrupt is called, it should return (via an RTS) with the carry flag set so that the MLI knows to call the next routine in the list.</P>

<P>As mentioned above, all 6502 registers, locations $FA thru $FF and if the stack is more than 3/4 full, 16 bytes of the stack, are preserved. The interrupt routine may use these resources freely for temporary data storage.</P>

<P><B>Note:</B> There is no general way for an interrupt routine to identify whether or not its device was the source of the interrupt.  This task depends on the specific characteristics of the device; in fact, some devices provide no mechanism for interrupt verification.  It is necessary to service such a device after all others have been polled.</P>

<P>If no installed and allocated routine claims a pending interrupt, a <B><TT>SYSTEM FAILURE</TT></B> message will be displayed and program execution will be halted.</P>

<P>When finished with a interrupt driven device, a DEALLOC_INTERRUPT call should be made, but only after the device itself is disabled.</P>

<P><B>Warning</B> This warning does not apply to the Apple IIc nor to Apple IIe's with enhanced ROMs.  Because the Apple II Monitor program relies on a zero-page location ($45) that is overwritten when an interrupt occurs, you should disable interrupts while you are using the Monitor program.  The system also uses location $7F8 to store the I/O slot location that was in use before an interrupt occurred; do not use this location.</P>

<a name="page107"></a>

<A NAME="6.2.1"></A>

<H3>6.2.1 - Interrupts During MLI Calls</H3>

<P>The preceding section does not discuss what a program should do if an interrupt were to occur during the execution of an MLI call and your interrupt handling routine itself makes calls to the MLI.</P>

<P>The interrupt routine must allow the MLI to complete its current call before initiating a new call to the MLI.  The mechanism for doing this consists of changing the globals so that the MLI completes its call and returns to your routine rather than to the routine that originally called it.  Then your routine can use the MLI as needed.  When it is finished, it must restore the 6502 registers to the state they would have been in at completion of the MLI call had the interrupt not occurred, and then jump back to the proper address in the original routine.</P>

<P>To do this, the interrupt handling routine should first check the status of the MLI.  If the flag <B><TT>MLIACTV</TT></B> ($BF9B) has the high bit set, then the MLI was in the middle of a call.  Your routine should then:</P>

<OL>

<LI>Save the return address of the original caller (<B><TT>CMDADR</TT></B>, $BF9C), replacing it with the address to which the MLI should return on completion of the current call.</li>

<LI>Claim the interrupt by disabling interrupts on the hardware, and clearing the carry flag.</li>

<LI>RTS<br /><br />The MLI's interrupt handler believes that the interrupt has been processed, so it completes the current MLI call and returns to the address in <B><TT>CMDADR</TT></B>, which is actually in your routine.  Your routine should now do this:<br />
<OL>
<LI>Save the A, X, Y, and P registers as the return state for the routine whose call just completed.</li>

<LI>Use the MLI as needed.</li>

<LI>Restore the A, X, Y, and P registers.</li>

<LI>Jump to the original <B><TT>CMDADR</TT></B>.</li>

</OL>
</OL>

<P>The original program sees only that its MLI call was successfully completed, and it continues execution.</P><a name="page108"></a>

<A NAME="6.2.2"></A>

<H3>6.2.2 - Sample Interrupt Routine</H3>

<P>Here is a sample interrupt routine that reads the date from a clock/calendar card, and displays it in the upper-right corner of the screen once per second.  It assumes the card is in slot 2.</P>


<PRE>
 SOURCE   FILE #01 =&#62;SHOWTIME
 ----- NEXT OBJECT FILE NAME IS SHOWTIME.0
 0300:        0300    1           ORG   $300
 0300:        C20B    2 WTTCP     EQU   $C20B     ;CLOCK WRITE ENTRY PT (SLOT 2)
 0300:        C208    3 RDTCP     EQU   $C208     ;CLOCK READ ENTRY PT (SLOT 2)
 0300;        C080    4 TCICR     EQU   $C080     ;INTERRUPT CONTROL REG (SLOT 2)
 0300:        C088    5 TCMR      EQU   $C088     ;MYSTERY REGISTER (SLOT 2)
 0300:                6 *
 0300:        0200    7 IN        EQU   $200      ;WHERE CLOCK LEAVES THE TIME
 0300:                8 *
 0300:        0412    9 UPRIGHT   EQU   $412      ;THE UPPER RIGHT OF THE SCREEN
 0300:        047A   10 INTONI    EQU   $47A      ;LEAVE INTERRUPTS ON (SLOT 2)
 0300:        07FA   11 INTON2    EQU   $7FA      ;LEAVE INTERRUPTS ON (SLOT 2)
 0300:               12 *
 0300:        BF00   13 MLI       EQU   $BF00     ;ENTRY POINT TO THE PRODOS MLI
 0300:               14 *
 0300:               15 * CALLING INTERRUPTS, CALLING INTERRUPTS
 0300:               16 *
 0300:20 7E 03       17           JSR   ALLOC.INT ;HAVE MLI INSTALL INT ROUTINE
 0303:60             18           RTS             ;THAT'S ALL FOLKS
 0304:               19 *
 0304:               20 *
 0304:        0304   21 SHOWTIME  EQU   *
 0304:D8             22           CLD
 0305:08             23           PHP
 0306:78             24           SEI             ;DISABLE INTERRUPTS
 0307:A0 20          25           LDY   #$20      ; FOR SLOT 2
 O3O9;B9 80 C0       26           LDA   TCICR,Y   ;GET VAL OF INT CONTROL REG
 03OC:29 20          27           AND   #$20      ;CHK BIT 5 - IS INT FROM CLK?
 030E:F0 3C   034C   28           BEQ   NOTCLK    ;IF BIT 5 OFF, INT NOT FROM CLK
 0310:B9 88 C0       29           LDA   TCMR,Y    ;CLEAR MYSTERY REGISTER
 0313:B9 80 C0       30           LDA   TCICR,Y   ;CLEAR INTERRUPT ON HARDWARE
 0316:CE 4F 03       31           DEC   COUNTER   ;ONLY PRINT TIME EVERY SECOND
 0319:D0 2E   0349   32           BNE   EXITCLK   ; NOT TIME TO PRINT YET
 031B:               33 *
 031B:A2 27          34           LDX   #39       ;SAVE THE INPUT BUFFER
 031D:BD 00 02       35 DOIN      LDA   IN,X      ; SINCE THE CLOCK WRITES OVER
 0320:9D 56 03       36           STA   INBUF,X   ; IT WHEN IT IS CALLED
 0323:CA             37           DEX             ;
 0324:10 F7   031D   38           BPL   DOIN      ;
 0326:               39
 0326:A9 A5          40           LDA   #$A5      ;SET APPLESOFT STRING INPUT
 0328:20 0B C2       41           JSR   WTTCP     ; MODE & SEND IT TO THE CARD
 032B:20 08 C2       42           JSR   RDTCP     ;READ TIME INTO INPUT BUFFER
 032E:               43
 032E:A2 15          44           LDX   #21
 0330:BD 01 02       45 GETNEXT   LDA   IN+1,X    ;PRINT TIME TO SCREEN
 0333:9D 12 04       46           STA   UPRIGHT,X ;CHARS 0-22 OF INPUT BUFFER
 0336:CA             47           DEX             ;
 0337:10 F7   0330   48           BPL   GETNEXT   ;
 0339:               49
 0339:A9 40          50 SETCNTR   LDA   #64       ;SET UP COUNTER FOR NEXT TIME
</PRE>

<a name="page109"></a>

<PRE>
 033B:8D 4F 03       51           STA   COUNTER   ;
 033E:               52
 033E:A2 27          53           LDX   #39       ;RESTORE THE INPUT BUFFER
 0340:BD 56 03       54 DOIN2     LDA   INBUF,X   ;
 0343:9D 00 02       55           STA   IN,X      ;
 0346:CA             56           DEX             ;
 0347:10 F7   0340   57           BPI   DOIN2     ;
 0349:               58 *
 0349:28             59 EXITCLK   PLP
 034A:18             60           CLC             ;TELL MLI INT WAS PROCESSED
 034B:60             61           RTS
 034C:28             62 NOTCLK    PLP
 034D:38             63           SEC             ;TELL MLI IT ISN'T OURS
 034E:60             64           RTS
 034F:               65 *
 034F:        0001   66 COUNTER   DS    1,0       ;
 0350;               67 *
 0350:02 00          68 AIPARMS   DFB   2,0       ;PUT ALLOCATE AND DEALLOCATE
 0352:04 03          69           DW    SHOWTIME  ; INTERRUPT PARAMETERS HERE,
 0354:               70 *
 0354:01 00          71 DIPARMS   DFB   1,0       ; SO BOTH ROUTINES CAN USE THEM
 0356:               72 *
 0356:        0028   73 INBUF     DS    40,0      ;SAVE 40 BYTES IN HERE
 037E:               74 *                         ; FOR INPUT BUFFER SAVE/RESTORE
</PRE>

<P>Note the important features of this routine:</P>

<OL>

<LI>The routine begins with a CLD instruction (line 22).</li>

<LI>The routine checks to see if the IRQ interrupt is being caused by the clock/calendar card (lines 25-28).  If not, it returns with the carry set (lines 62-64).</li>

<LI>If the interrupt belongs to the clock/calendar card, it clears the inter- rupt hardware (lines 29-30).</li>

<LI>When it is done with the interrupt task, it returns with carry clear (lines 59-61).</li>

</OL>

<a name="page110"></a>

<P>The following routine adds the interrupt routine to ProDOS using the ALLOC_INTERRUPT call.  Having done this, it then activates interrupts on the clock/calendar card.  Then a CLI instruction is executed to allow the 6502 to process interrupts.</P>

<PRE>
 03A0:A9 00          94 DEALLOC.INT LDA #0        ;DISABLE INTERRUPTS
 03A2:8D 7A 04       95           STA   INTON1    ; IN THE THUNDERCLOCK
 03A5:8D FA 07       96           STA   INTON2
 03A8:Ao 20          97           LDY   #$20
 03AA;99 80 C0       98           STA   TCICR,Y
 03AD:               99 *
 03AD:AD 51 03      100           LDA   AIPARMS+1 ;GET INT_NUM
 03B0:8D 55 03      101           STA   DIPARMS+1 ; FOR DEALLOCATION
 03B3:20 00 BF      102           JSR   MLI       ;CALL THE MLI TO
 03B6:41            103           DFB   $41       ; DEALLOCATE INT ROUTINE
 03B7:54 03         104           DW    DIPARMS
 03B9:D0 01   03BC  105           BNE   OOPS2     ;BREAK ON ERROR
 03BB:60            106           RTS             ;DONE
 03BC:              107 *
 03BC:00            108 OOPS2     BRK             ;BREAK ON ERROR
</PRE>

<P>The next routine disables interrupts on the clock/calendar card before removing the interrupt routine from ProDOS with a DEALLOC_INTERRUPT call.</P>

<PRE>
 037E:               75
 037E:20 00 BF       76 ALLOC.INT JSR   MLI       ;CALL THE MLI TO
 0381:40             77           DFB   $40       ; ALLOCATE THE INTERRUPT
 0382:50 03          78           DW    AIPARMS   ;
 0384:D0 19   039F   79           BNE   OOPS      ;BREAK ON ERROR
 0386:               80 *
 0386:A0 20          81           LDY   #$20
 0388:A9 AC          82           LDA   #$AC      ;SET 64HZ INTERRUPT RATE
 038A:20 0B C2       83           JSR   WTTCP     ; BY WRITING A ',' To CLOCK
 038D:A9 40          84           LDA   #$40      ;NOW ENABLE THE SOFTWARE
 038F:8D 7A 04       85           STA   INTON1    ; AND TELL IT NOT TO DISABLE
 0392:8D FA 07       86           STA   INTON2    ; INTERRUPTS AFTER READS
 0395:99 80 C0       87           STA   TCICR,Y
 0398:A9 01          88           LDA   #1        ;PRINT TIME IMMEDIATELY
 039A:8D 4F 03       89           STA   COUNTER   ; ONCE PER SECOND LATER
 039D:58             90           CLI             ;ALLOW THE 6502 TO SEE THE
 039E:60             91           RTS             ; INTERRUPTS
 039F:               92 *
 039F:00             93 OOPS      BRK             ;BREAK ON ERROR
</PRE>

<a name="page111"></a>

<A NAME="6.3"></A>

<H2>6.3 - Disk Driver Routines</H2>

<P>If a disk drive supplied by another manufacturer is to work with ProDOS, it must look and act just like a disk drive supplied by Apple Computer, Inc.  Its boot ROM must have certain things in certain locations, and its driver routine must use certain zero-page locations for its call parameters.</P>

<A NAME="6.3.1"></A>

<H3>6.3.1 - ROM Code Conventions</H3>

<P>During startup, ProDOS searches for block storage devices.  If it finds the following three bytes in the ROM of a particular slot, ProDOS assumes it has found a disk drive (<I>n</I> represents slot number):</P>

<P>$Cn01 = $20 $Cn03 = $00 $Cn05 = $03</P>

<P>If $CnFF = $00, ProDOS assumes it has found a Disk II with 16-sector ROMs and marks the device driver table in the ProDOS global page with the address of the Disk II driver routines.  The Disk II driver routines support any drive that emulates Apple's 16-sector Disk II (280 blocks, single volume, and so on).</P>

<P>If $CnFF = $FF, ProDOS assumes it has found a Disk II with 13-sector ROMs, which ProDOS does not support.</P>

<P>If ProDOS finds a value other than $00 or $FF at $CnFF, it assumes it has found an intelligent disk controller.  If the STATUS byte at $CnFE indicates that the device supports READ and STATUS requests, ProDOS marks the global page with a device-driver address whose high-byte is equal to $Cn and whose low-byte is equal to the value found at $CnFF.</P>

<a name="page112"></a>

<P>The only calls to the disk driver are STATUS, READ, WRITE, and FORMAT.  The STATUS call should perform a check to verify that the device is ready for a READ or WRITE.  If it is not, the carry should be set and the appropriate error code returned in the accumulator.  If the device is ready for a READ or WRITE, then the driver should clear the carry, place a zero in the accumulator, and return the number of blocks on the device in the X-register (low-byte) and Y-register (high-byte).</P>

<P>If you wish to interface a disk controller card with more than two drives (or a device with more than two volumes), additional device driver vectors for disk controllers plugged into slot 5 or 6 may be installed in slot 1 or 2 locations.  There will be no conflict with character devices physically present in these slots.</P>

<P>Device numbers for four drives in slot 5 or 6 are listed below.</P>

<P>Physical Slot Five: S5,D1 = $50 S5,D2 = $D0 S1,D1 = $10 S1,D2 = $90</P>

<P>Physical Slot Six: S6,D1 = $60 S6,D2 = $E0 S2,D1 = $20 S2,D2 = $A0</P>

<a name="page113"></a>

<P>The special locations in the ROM code are:</P>

<DL>
  <DT>$CnFC- $CnFD</dt>
  <DD>The total number of blocks on the device.  Used for writing the disk's bit map and directory header after formatting.  (If this location is $0000, it indicates that the number of blocks must be obtained by making a STATUS request.)</dd>
</DL>

<DL>
  <DT>$CnFE</dt>
  <DD>The status byte (bits 0 and 1 must be set for ProDOS to install the driver vector.) bit 7 - Medium is removable. bit 6 - Device is interruptible. bit 5-4 - Number of volumes on the device (0-3). bit 3 - The device supports formatting. bit 2 - The device can be written to. bit 1 - The device can be read from (must be on). bit 0 - The device's status can be read -- (must be on).</dd>
</DL>

<DL>
  <DT>$CnFF</dt>
  <DD>The low-byte of entry to the driver routines.  ProDOS will place $Cn + this byte in the global page.</dd>
</DL>

<A NAME="6.3.2"></A>

<H3>6.3.2 - Call Parameters</H3>

<P>parameters are passed to the driver are:</P>

<DL>
  <DT>$42 Command:
  <DD>0 = STATUS request 1 = READ request 2 = WRITE request 3 = FORMAT request</dd>
</DL>

<P><B>Note:</B> The FORMAT code in the driver need only lay down address marks if required.  The calling routine should write the virgin directory and bit map.</P>

<a name="page114"></a>

<DL>
  <DT>$43 Unit Number:
  <DD><PRE>
    7  6  5  4  3  2  1  0
  +--+--+--+--+--+--+--+--+
  |DR|  SLOT  | NOT USED  |
  +--+--+--+--+--+--+--+--+
</PRE></dd>
</DL>

<P><B>Note:</B> The UNIT_NUMBER that appears in the device list (DEVLST) in the system globals will include the high nibble of the status byte ($CnFE) as an ID in its low nibble.</P>

<DL>
  <DT>$44-$45 Buffer Pointer:</dt>
  <DD>Indicates the start of a 512-byte memory buffer for data transfer.</dd>
</DL>

<DL>
  <DT>$46-$47 Block Number:</dt>
  <DD>Indicates the block on the disk for data transfer.</dd>
</DL>

<P>The device driver should report errors by setting the carry flag and loading the error code into the accumulator.  The error codes that should be implemented are:</P>

<P>$27 - I/O error $28 - No device connected $2B - Write protected</P>

<a name="page115"></a>

<a name="page116"></a>
