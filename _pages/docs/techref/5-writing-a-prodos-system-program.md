---
layout:      page
title:       TechRef - Writing a ProDOS System Program
description: ProDOS 8 Technical Reference Manual Writing a ProDOS System Program
permalink:   /docs/techref/writing-a-prodos-system-program/
---

<A NAME="5"></A>

<a name="page81"></a>

<P>This chapter is about writing system programs that use the ProDOS MLI.  It first explains the things that a program must do to qualify as a system program.  Next it discusses some of the things that a system program must be aware of, particularly how it should use memory.  The end of the chapter contains several programming hints.</P>

<A NAME="5.1"></A>

<H2>5.1 - System Program Requirements</H2>

<P>A ProDOS system program is any program that makes calls to the ProDOS MLI and that adheres to a set of standard system program rules.  Each system program must have</P>

<UL>

<LI>code to move the program from its load position to its final execution location, if necessary

<LI>a version number in the system global page</li>

<LI>the ability to switch to another system program.</li>

</UL>

<P>All other aspects of the system program are up to you.</P>

<A NAME="5.1.1"></A>

><H3>5.1.1 - Placement in Memory</H3

<P>System programs are always loaded into memory starting at location $2000.  When the system is first started up, the system program used is the first file on the startup disk with the name XXX.SYSTEM, and the $FF filetype.  When one system program switches to another, it can load any file of type $FF.</P>

<P>Figure 5-1 shows the portions of memory that are available to system programs.  If BASIC is not being used, the area assigned to BASIC.SYSTEM (the BASIC command interpreter) is also available.</P>

<P>A system program as large as $8F00 (36608) bytes can be loaded.  The total space available to a system program is $B700 (46848) bytes.</P>

<A NAME="page82"></a>

<A NAME="5-1"></A>

<P><B>Figure 5-1.  Memory Map</B></P>

<PRE>
             
             
             
             
             
              <B>Main Memory                                 Auxiliary Memory</B>
                                                       (IIc or 128K IIe only)

 $FFFF+---------+$FFFF+---------+                $FFFF+---------+
      |.Monitor.|     |#########|                     |.........|
 $F800|---------|     |#########|                     |.........|
      |.........|     |#########|                     |.........|
      |.........|     |#########|                     |.........|
      |.........|     |#########|                     |.........|
      |.........|     |#########|                     |.........|
      |.........|     |#########|                     |.........|
      |.........|     |#ProDOS##|                     |.........|
      |Applesoft|     |#########|$DFFF+---------+$E000|---------|$DFFF+---------+
      |.........|     |#########|     |.........|     |         |     |.........|
      |.........|     |#########|     |.........|     |         |     |.........|
      |.........|     |#########|$D400|---------|     |         |     |.........|
      |.........|     |#########|     |#########|     |         |     |.........|
      |.........|     |#########|$D100|---------|     |         |$D100|---------|
      |.........|     |#########|     |         |     |         |     |         |
 $D000|---------|     +---------+     +---------+$D000+---------+     +---------+
      |..Other..|
 $C100+---------+
              ^  $BFFF+---------+                $BFFF+---------+
              |       |#########|                     |.........|
 This ROM area|  $BF00|---------|                $BF00|---------|
 on IIc and IIe       |\\\\\\\\\|                     |         |
 only!                |\\\\\\\\\|                     |         |     +---------+
                      |\\\\\\\\\|                     |         |     |#########|
                      |\\\\\\\\\|                     |         |     +---------+
                      |\\\\\\\\\|                     |         |     Used by ProDOS
                      |\BASIC.\\|                     |         |
                      |\SYSTEM\\|                     |         |
                      |\\\\\\\\\|                     |         |     +---------+
                      |\\\\\\\\\|                     |         |     |\\\\\\\\\|
                      |\\\\\\\\\|                     |         |     +---------+
                      |\\\\\\\\\|                     |         |     Used by
                      |\\\\\\\\\|                     |         |     BASIC.SYSTEM
                 $9600|---------|                     |         |
                      |         |                     |         |
                      |         |                     |         |     +---------+
                      |         |                     |         |     |.........|
                      |         |                     |         |     +---------+
                      |         |                     |         |     Other used or
                      |         |                     |         |     reserved areas
                      |         |                     |         |
                      |         |                     |         |
                      |         |                     |         |     +---------+
                      |         |                     |         |     |         |
                      |         |                     |         |     +---------+
                      |         |                     |         |      Free Space
                      |         |                     |         |
                      /\/\/\/\/\/                     /\/\/\/\/\/

                      /\/\/\/\/\/                     /\/\/\/\/\/
                      |         |                     |         |
                      |         |                     |         |
                      |         |                     |         |
                      |         |                     |         |
                      |         |                     |         |
                  $800|---------|                 $800|---------|
                      |.........|                     |.........|
                      |.........|                     |.........|
                      |.........|                     |.........|
                      |.........|                 $400|---------|
                      |.........|                     |#########|
                  $300|.........|                     |#########|
                      |.........|                     |#########|
                      |.........|                     |#########|
                      |.........|                 $200|---------|
                      |.........|                     |         |
                  $100|---------|                 $100|---------|
                      |         |                     |#########|
                      |         |                  $80|---------|
                   $4F|---------|                     |         |
                      |#Shared/#|                     |         |
                      |####safe#|                     |         |
                   $3A|---------|                     |         |
                      |         |                     |         |
                      +---------+                     +---------+
                   $00
</PRE>

<a name="page83"></a>

<A NAME="5.1.2"></A>

<H3>5.1.2 - Relocating the Code</H3>

<P>The final execution location(s) to which you can relocate your code depends on your system configuration.  The memory locations $0800 through $BEFF are available to system programs.</P>

<A NAME="5.1.3"></A>

<H3>5.1.3 - Updating the System Global Page</H3>

<P>The MLI global page resides in locations $BF00 through $BFFF.  These are the locations whose values you must set:</P>

<P>$BF58-$BF6F - The system bit map. $BFFD - The version number of your system program.</P>

<P>In addition, there is other information in the global page that your program might find useful.  These values are documented in the section "The System Global Page."</P>

<A NAME="5.1.4"></A>

<H3>5.1.4 - The System Bit Map</H3>

<P>The system bit map occupies bytes $BF58 through $BF6F in the system global page and it represents the status of each 256-byte page of memory from $0000 through $BFFF, as shown in Figure 5-2.</P>

<A NAME="5-2"></A>


<P><B>Figure 5-2.  Memory Representation in the System Bit Map</B></P>

<PRE>
 Bit Map Address              Pages Represented
                   _____________
     $BF58-$BF5F  |_|_|_|_|_|_|_|  $00-$3F
     $BF60-$BF67  |_|_|_|_|_|_|_|  $40-$7F
     $BF68-$BF6F  |_|_|_|_|_|_|_|  $80-$BF
</PRE>

<P>Within each byte, the bits are used in reverse order.  Thus, bit 7 of byte $BF58 represents the first 256 bytes of memory, and bit 0 of byte $BF6F represents the last page before $C000.</P>

<P>You may have noticed that neither the Language Card area of memory nor the extended memory of an Apple IIe or Apple IIc is included in this map.  This is because these regions of memory cannot be directly accessed by the MLI.  You cannot read data into or out of these areas, and you cannot execute MLI calls from them.  More information is given in this chapter in the sections "Using the Language Card" and "Using the Alternate 64K RAM Bank."</P>

<A NAME="page84"></a>

<A NAME="5.1.4.1"></A>

<H4>5.1.4.1 - Using the Bit Map</H4>

<P>There are twenty-four bytes in the bit map: the high five bits of an address select which of these bytes contains a given page.  Each byte represents eight 256-byte pages; the next three bits of an address form the complement of the bit number within that byte.  Thus for page $00 in memory, the high five bits are zero: byte 0 of the bit map contains that page.  The next three bits are zero, the complement of 000 (binary) is 111 (binary): bit 7 within byte zero contains that page.  Figure 5-3 shows this relationship.</P>

<A NAME="5-3"></A>

<P><B>Figure 5-3.  Page Number to Bit-Map Bit Conversion</B></P>

<PRE>
 BIT       7     6     5     4     3     2     1     0
         +---------------------------------------------+
         |        Byte in Bit Map    |    Complement   |
 PAGE #  | (only 0 through 23 valid) |  of Bit in Byte |
         +---------------------------------------------+
</PRE>

<P>Here is a short routine that accepts the high byte of an address in the Accumulator.  It returns with the carry clear if the memory page is free; the carry is set if the page is already used (or if the page is in the Language Card).  It destroys the values in the A, X, and Y registers.</P>

<PRE>
 ------------------------------------------------------------------------

 SOURCE   FILE #01 =&#62;PFREE
 0000:        BF58    1 BITMAP  EQU  $BF58     ;the system bit map
 0000:                2 *
 0000:        0000    3 PFREE   EQU  *
 0000:C9 C0           4         CMP  #$C0      ;in language card?
 0002:B0 17   001B    5         BCS  NOTFREE   ;yes, it's protected
 0004:AA              6         TAX            ;save page for bit in page
 0005:4A              7         LSR  A         ;move byte number to right
 0006:4A              8         LSR  A
 0007:4A              9         LSR  A
 0008:A8             10         TAY            ;save byte number
 0009:8A             11         TXA            ;get bit in byte
 000A:29 07          12         AND  #$7       ;mask off byte number
 000C:AA             13         TAX            ;and save bit in byte
 000D:A9 80          14         LDA  #$80      ;bit 7 set for bit 0 in byte
 000F:CA             15 LOOP    DEX            ;done shifting?
 0010:30 04   0016   16         BMI  CHKBIT    ;yes, check bit value
 0012:4A             17         LSR  A         ;else shift again
 0013:4C 0F 00       18         JMP  LOOP      ;and continue
 0016:39 58 BF       19 CHKBIT  AND  BITMAP,Y  ;is selected bit set?
 0019:F0 02   001D   20         BEQ  ISFREE    ;nope, page is free
 001B:38             21 NOTFREE SEC            ;flag page not free
 001C:60             22         RTS
 001D:18             23 ISFREE  CLC            ;page is free
 001E:60             24         RTS

 ------------------------------------------------------------------------
</PRE>

<a name="page85"></a>

<A NAME="5.1.5"></A>

<H3>5.1.5 - Switching System Programs</H3>

<P>All system programs must use a standard way of starting and quitting.</P>

<A NAME="5.1.5.1"></A>


<H4>5.1.5.1 - Starting System Programs</H4>

<P>System programs are started in one of two ways:</P>

<UL>

<LI>The disk containing ProDOS and the system program is started up; ProDOS loads and runs the first XXX.SYSTEM file of type SYS($FF). The order of search is determined by the file entries in the startup volume directory.</li>

<LI>The program is loaded by another program (such as the ProDOS FILER or the BASIC.SYSTEM) or by a program dispatcher or selector.</li>

</UL>

<P>The system program is loaded and jumped to at $2000.  The complete or partial pathname of the system program is stored at $280, starting with a length byte.  The string is a full pathname if it starts with a slash.  It is a partial pathname if it starts with a letter.</P>

<P>This pathname allows a system program to determine the directory where other needed files may reside.  The program should never assume that the files are in a specific directory or subdirectory.</P>

<P>There is a way to pass a second pathname to interpreters -- for example, to language interpreters -- that like to run startup programs. The ProDOS dispatcher does not support this mechanism but other more sophisticated program selectors may.  It requires that the interpreter start a certain way:</P>

<P><B><TT>$2000</TT></B> is a jump instruction.  <B><TT>$2003</TT></B> and <B><TT>$2004</TT></B> are <B><TT>$EE</TT></B>.</P>

<P>If the interpreter starts this way, byte $2005 is assumed to indicate the length of a buffer that starts at $2006 and holds the pathname (starting with a length byte) of the startup file.</P>

<P>Interpreters that support this mechanism should supply their own default string, which should be a standard choice for a startup program or a flag not to run a startup program.</P>

<P>Once gaining control, the system program sets the reset vector and fixes the power-up byte.  Never assume the state of the machine to be anything that is not clearly documented.</P>

<A NAME="page86"></a>

<P><B>Important!</B> If your interpreter uses any location in the range $D100-$DFFF (the dispatcher/selector area) in the second 4K bank of RAM, be sure that the area is initially saved and then restored on exit.</P>

<A NAME="5.1.5.2"></A>

<H4>5.1.5.2 - Quitting System Programs</H4>

<P>Here is how to quit system programs:</P>

<OL>

<LI>Do normal housekeeping.  Close files, reinstall /RAM if you have disconnected it, and so on.</li>

<LI>Invalidate the power-up byte at $3F4.  The simplest way is either to increment or to decrement it, which will always make it an invalid check of the $3F2 vector.</li>

<LI>Execute a ProDOS system call number $65 as follows: <br /><br />

<PRE>
 EXIT       JSR  PRODOS        ;Call the MLI ($BF00)
            DFB  $65           ;CALL TYPE = QUIT
            DW   PARMTABLE     ;Pointer to parameter table
 PARMTABLE  DFB  4             ;Number of parameters is 4
            DFB  0             ;0 is the only quit type
            DW   0000          ;Pointer reserved for future use
            DFB  0             ;Byte reserved for future use
            DW   0000          ;Pointer reserved for future use
</PRE>

</li>

</OL>

<P>Even though most of the parameter table is reserved for future use it must all be present.  It must consist of seven bytes: $04 followed by six nulls ($00).</P>

<P>ProDOS MLI call $65, the QUIT call, moves addresses $D100 through $D3FF from the second 4K bank of RAM of the language card to $1000, and executes a JMP to $1000.  What initially resides in that area is Apple's dispatcher code.</P>

<P>The dispatcher, once executed, does the following:</P>

<OL>

<LI>Allows the user to enter the prefix and filename of the system program (interpreter) to be executed.</li>

<LI>Stores the system program name at $280, starting with a length byte.  Once the system program executes, it can find from where it was starred, and locate any files it needs for processing.</li>

<LI>Closes any open files.</li>

<LI>Clears the bit map, and protects the zero, stack, text, and ProDOS global pages.</li>

<LI>Reads in the system file at $2000, and executes a JMP to $2000.</li>

</OL>

<a name="page87"></a>

<P>To install your own QUIT code that loads your own selector program, you must, at some point, store the system program name at $280, close open files, clear the bit map, and protect the zero, stack, text, and ProDOS global pages, as described above.  In addition, the $D100 byte must be a CLD ($D8) instruction, so that programs can tell whether selector code or the ProDOS dispatcher code is resident.</P>

<P>In addition to just leaving the pathname at $280 for the interpreter's use, a method to enable a selector program to specify an accompanying startup program has been defined.  Once active, an interpreter can immediately run that program.  This involves reserving an area in the system file, which a selector program overwrites with the startup program's name.  The interpreter then loads and executes that specified program.</P>

<P>Here is how the procedure works: the selector program looks at the first byte of the interpreter at $2000.  If it is a JMP ($4C) instruction, and bytes $2003 and $2004 are both $EE, then byte $2005 is interpreted as a buffer size indicator with the buffer starting at $2006. The string at $2006 would be the normal ProDOS pathname or partial pathname, starting with a length byte.</P>

<PRE>

 <B>Byte           Content</B>

 $2000-$2002    JMP CONT
 $2003          $EE
 $2004          $EE
 $2005          $41
 $2006          $07
 $2007-$200D    Startup Code
 .
 .
 .
 $2047          CONT
 .
 .
 .
</PRE>

<P>The two $EEs let the selector program know that this particular interpreter can run a startup program.  The interpreters that support this feature will supply their own default string, which may be a startup program or a flag of your choice.</P>

<A NAME="page88"></a>

<A NAME="5.2"></A>

<H2>5.2 - Managing System Resources</H2>

<P>This section describes the interaction between ProDOS and the various parts of memory.</P>

<A NAME="5.2.1"></A>

<H3>5.2.1 - Using the Stack</H3>

<P>In the Apple II, the stack is stored in page $01 of memory, from the high byte of the page going down.  When an interrupt occurs, the interrupt handler saves the low 16 bytes of the stack, but only if the stack is more than 3/4 full.  For maximum interrupt efficiency, a system program should not use more than the upper 3/4 of the stack.</P>

<P>System programs should set the stack pointer to $FF at the warm-start entry point.</P>

<A NAME="5.2.2"></A>

<H3>5.2.2 - Using the Alternate 64K RAM Bank</H3>

<P>When ProDOS is started up, it checks its environment.  If it finds 128K of memory (Apple IIe with Extended 80-column Text card, or Apple IIc), the auxiliary 64K bank of memory is configured as a RAM disk named /RAM.  Because the memory on the 80-column card is in slot 3, /RAM appears as slot 3 drive 2.  Its unit number, as entered in the ProDOS global page's device list, is $BF.</P>

<P>Before using the auxiliary memory for any other purpose, you must protect your code from /RAM.  The routines described here are examples only.</P>

<P><B>Note:</B> These routines are examples; they are not being specified as suitable for any particular purpose.</P>

<A NAME="5.2.2.1"></A>

<H4>5.2.2.1 - Protecting Auxiliary Bank Hi-Res Graphics Pages</H4>

<P>If your use involves hi-res graphics, you may protect those areas of auxiliary memory.  If you save a dummy 8K file as the first entry in /RAM, it will always be saved at $2000 to $3FFF.  If you then immediately save a second dummy 8K file to /RAM, it will be saved at $4000 to $5FFF.  This protects the hi-res pages in auxiliary memory while maintaining /RAM as an online storage device.</P>

<A NAME="page89"></a>

<P>There is no formula for determining where the blocks of /RAM physically reside in memory.  Further, the logical blocks are not physically contiguous.  There is no guaranteed way to protect any other fixed portions of auxiliary memory by the dummy file method.</P>

<A NAME="5.2.2.2"></A>

<H4>5.2.2.2 - Disconnecting /RAM</H4>

<P>To protect all of the auxiliary memory that has not been reserved for use by Apple, you must disconnect /RAM.  Note these three areas of the system global page:</P>

<UL>

<LI>$BF10-$BF2F contains the disk device driver addresses.</li>

<LI>$BF31 contains the number of devices minus one.</li>

<LI>$BF32-$BF3F contains the list of disk device numbers.</li>

</UL>

<P>Here is how to disconnect /RAM.  It is suggested that you read block two on /RAM and check the FILE_COUNT field in the directory.  If there are any files on /RAM, prompt the user either to continue with the disconnect or to cancel the process.</P>

<P>Check the MACHID byte at $BF96 to see if you have 128K.  If not, there will be no /RAM to disconnect.</P>

<P>The slot 0 drive 1 disk-driver vector ($BF10) will point to the "No Device Connected" routine.  The slot 0 vectors $BF10 and $BF20 are reserved for Apple's use: you cannot use these vectors if this convention is to work.  If the slot 3 drive 2 vector also points to the same address, then /RAM is already disconnected.</P>

<P>If /RAM is on line, you are ready to remove it.  (Note that the following steps can be adapted to disconnecting any device.)</P>

<OL>

<LI>Retrieve the slot 3 drive 2 device number you find in DEVLST, and save it.</li>

<LI>Move any remaining device numbers forward in the DEVLST.</li>

<LI>Retrieve the slot 3 drive 2 driver vector, and save it for later reinstallation.</li>

<LI>Replicate the "No Device Connected" vector in slot 0 drive 1 into slot 3 drive 2.</li>

<LI>Decrement the device count (DEVCNT).</li>

</OL>

<P>/RAM is now disconnected.  You are free to use the unreserved areas of auxiliary memory.</P>

<P><B>Note:</B> If ProDOS has just been started up, /RAM is the last <I>disk device</I> installed.  However, if the user has manually installed another device(s), the device number for /RAM will not be the last entry in the device list (DEVLST).</P>

<A NAME="page90"></a>

<A NAME="5.2.2.3"></a>

<H4>5.2.2.3 - How to Treat RAM Disks With More Than 64K</H4>

<P>If there is a device in slot 3 drive 2 that is not /RAM, or is a RAM disk with a capacity of more than 64K, the following routine prevents it from being disconnected.</P>

<PRE>
 ORG $1000
 DEVCNT EQU $BF31       ; GLOBAL PAGE DEVICE COUNT
 DEVLST EQU $BF32       ; GLOBAL PAGE DEVICE LIST
 MACHID EQU $BF98       ; GLOBAL PAGE MACHINE ID BYTE
 RAMSLOT EQU $BF26      ; SLOT 3, DRIVE 2 IS /RAM'S DRIVER VECTOR
 *
 * NODEV IS THE GLOBAL PAGE SLOT ZERO, DRIVE 1 DISK DRIVE VECTOR.
 * IT IS RESERVED FOR USE AS THE "NO DEVICE CONNECTED" VECTOR.
 *
 NODEV EQU $BF10
 *
 *
 RAMOUT PHP             ; SAVE STATUS AND
  SEI                   ; MAKE SURE INTERRUPTS ARE OFF!
 *
 * FIRST THING TO DO IS TO SEE IF THERE IS A /RAM TO DISCONNECT!
 *
  LDA MACHID            ; LOAD THE MACHINE ID BYTE
  AND #$30              ; TO CHECK FOR A 128k SYSTEM
  CMP #$30              ; IS IT 128k?
  BNE DONE              ; IF NOT THEN BRANCH SINCE NO /RAM!
 *
  LDA RAMSLOT           ; IT IS 128K; IS A DEVICE THERE?
  CMP NODEV             ; COMPARE WITH LOW BYTE OF NODEV
  BNE CONT              ; BRANCH IF NOT EQUAL, DEVICE IS CONNECTED
  LDA RAMSLOT+1         ; CHECK HI BYTE FOR MATCH
  CMP NODEV+1           ; ARE WE CONNECTED?
  BEQ DONE              ; BRANCH, NO WORK TO DO; DEVICE NOT THERE
 *
 * AT THIS POINT /RAM (OR SOME OTHER DEVICE) IS CONNECTED IN
 * THE SLOT 3, DRIVE 2 VECTOR.  NOW WE MUST GO THRU THE DEVICE
 * LIST AND FIND THE SLOT 3, DRIVE 2 UNIT NUMBER OF /RAM ($BF).
 * THE ACTUAL UNIT NUMBERS, (THAT IS TO SAY 'DEVICES') THAT WILL
 * BE REMOVED WILL BE $BF, $BB, $B7, $B3.  /RAM'S DEVICE NUMBER
 * IS $BF.  THUS THIS CONVENTION WILL ALLOW OTHER DEVICES THAT
 * DO NOT NECESSARILY RESEMBLE (OR IN FACT, ARE COMPLETELY DIFFERENT
 * FROM) /RAM TO REMAIN INTACT IN THE SYSTEM.
 *
 *
 CONT LDY DEVCNT        ; GET THE NUMBER OF DEVICES ONLINE
 LOOP LDA DEVLST,Y      ; START LOOKING FOR /RAM OR FACSIMILE
  AND #$F3              ; LOOKING FOR $BF, $BB, $B7, $B3
  CMP #$B3              ; IS DEVICE NUMBER IN {$BF,$BB,$B7,$B3}?
  BEQ FOUND             ; BRANCH IF FOUND..
  DEY                   ; OTHERWISE CHECK OUT THE NEXT UNIT #.
  BPL LOOP              ; BRANCH UNLESS YOU'VE RUN OUT OF UNITS.
  BMI DONE              ; SINCE YOU HAVE RUN OUT OF UNITS TO
 FOUND LDA DEVLST,Y     ; GET THE ORIGINAL UNIT NUMBER BACK
  STA RAMUNITID         ; AND SAVE IT OFF FOR LATER RESTORATION.
 *
 * NOW WE MUST REMOVE THE UNIT FROM THE DEVICE LIST BY BUBBLING
 * UP THE TRAILING UNITS.
 *
 GETLOOP LDA DEVLST+1,Y ; GET THE NEXT UNIT NUMBER
  STA DEVLST,Y         ; AND MOVE IT UP.
  BEQ EXIT             ; BRANCH WHEN DONE(ZEROS TRAIL THE DEVLST)
  INY                  ; CONTINUE TO THE NEXT UNIT NUMBER...
  BNE GETLOOP          ; BRANCH ALWAYS.
 *
 EXIT LDA RAMSLOT      ; SAVE SLOT 3, DRIVE 2 DEVICE ADDRESS.
  STA ADDRESS          ; SAVE OFF LOW BYTE OF /RAM DRIVER ADDRESS
  LDA RAMSLOT+1        ; SAVE OFF HI BYTE
  STA ADDRESS+1        ;
 *
  LDA NODEV            ; FINALLY COPY THE 'NO DEVICE CONNECTED'
  STA RAMSLOT          ; INTO THE SLOT 3, DRIVE 2 VECTOR AND
  LDA NODEV+1          ;
  STA RAMSLOT+1        ;
  DEC DEVCNT           ; DECREMENT THE DEVICE COUNT.
 *
 DONE PLP              ; RESTORE STATUS
 *
  RTS                  ; AND RETURN
 *
 ADDRESS DW $0000      ; STORE THE DEVICE DRIVER ADDRESS HERE
 RAMUNITID DFB $00     ; STORE THE DEVICE'S UNIT NUMBER HERE
 *
</PRE>

<a name="page91"></a>

<A NAME="5.2.2.4"></A>

<H4>5.2.2.4 - Reinstalling /RAM</H4>

<P>Part of your exit procedure should include code to reinstall /RAM, making it available to the next application.  Be sure /RAM has been disconnected before you reinstall it.  Applications should not begin by reinstalling /RAM, because this would preclude passing files from one application to the next in /RAM.</P>

<P>Here is how to reinstall /RAM (or any general device):</P>

<OL>

<LI>Reinstall the device driver address you retrieved and saved as the slot 3 drive 2 vector.</li>

<LI>Increment the device count (DEVCNT).</li>

<LI>Reinstall the device number in the device list (DEVLST).  It may be best to reinstall the device number as the first entry in the list.  If the user has manually installed a disk driver, he may assume that because it was the last thing installed that it is still the last one in the list.  It is recommended that you move all the entries in the list down one, and reinstall the /RAM device number as the first entry.</li>

<LI>Set up the parameters for a format request and JSR to the device driver address you have reinstalled.  The /RAM driver will set up a new directory and bit map.</li>

</OL>

<a name="page92"></a>

<P>The following is an example of what the reinstallation code might look like.  These routines deal specifically with /RAM but can easily be adapted to any disk driver routines.</P>

<PRE>
 *
 * THIS IS THE EXAMPLE /RAM INSTALL ROUTINE
 *
 RAMIN PHP              ; SAVE STATUS
  SEI                   ; AND MAKE SURE INTERRUPTS ARE OFF!
 *
  LDY DEVCNT            ; GET THE NUMBER OF DEVICES - 1.
 LOOP1 LDA DEVLST,Y     ; LOAD THE UNIT NUMBER
  AND #$F0              ; CHECK FOR SLOT 3, DRIVE 2 UNIT.
  CMP #$B0              ; IS IT THE SLOT 3, DRIVE 2 UNIT?
  BEQ DONE1             ; IF SO BRANCH.
  DEY                   ; OTHERWISE SEARCH ON...
  BPL LOOP1             ; LOOP UNTIL DEVLST SEARCH IS COMPLETED
  LDA ADDRESS           ; RESTORE THE DEVICE DRIVER ADDRESS
  STA RAMSLOT           ; LOW BYTE..
  LDA ADDRESS+1         ; NOW THE
  STA RAMSLOT+1         ; HI BYTE.
  INC DEVCNT            ; AFTER INSTALLING DEVICE, INC DEVICE COUNT
  LDY DEVCNT            ; USE Y FOR LOOP COUNTER..
 LOOP2 LDA DEVLST-1,Y   ; BUBBLE DOWN THE ENTRIES IN DEVICE LIST
  STA DEVLST,Y          ;
  DEY                   ; NEXT
  BNE LOOP2             ; LOOP UNTIL ALL ENTRIES MOVED DOWN.
 *
 * NOW SET UP A /RAM FORMAT REQUEST
 *
  LDA #3                ; LOAD ACC WITH FORMAT REQUEST NUMBER.
  STA $42               ; STORE REQUEST NUMBER IN PROPER PLACE.
 *
  LDA RAMUNITID         ; RESTORE THE DEVICE
  STA DEVLST            ; UNIT NUMBER IN THE DEVICE LIST
  AND #$F0              ; STRIP THE DEVICE ID (ZERO LOW NIBBLE)
  STA $43               ; AND STORE THE UNIT NUMBER IN $43.
 *
  LDA #$00              ; LOAD LOW BYTE OF BUFFER POINTER
  STA $44               ; AND STORE IT.
  LDA #$20              ; LOAD HI BYTE OF BUFFER POINTER
  STA $45               ; AND STORE IT.
 *
  LDA $C08B             ; READ &#38; WRITE ENABLE
  LDA $C08B             ; THE LANGUAGE CARD WITH BANK 1 ON.
 *
 * NOTE HOW THE DRIVER IS CALLED.  YOU JSR TO AN INDIRECT JMP SO
 * CONTROL IS RETURNED BY THE DRIVER TO THE INSTRUCTION AFTER THE JSR.
 *
  JSR DRIVER            ; NOW LET DRIVER CARRY OUT CALL.
  BIT $C082             ; NOW PUT ROM BACK ON LINE.
 *
  BCC DONE1             ; IF THE CARRY IS CLEAR --&#62; NO ERROR
  JSR ERROR             ; GO PROCESS THE ERROR
 *
 DONE1 PLP              ; RESTORE STATUS
  RTS                   ; THAT'S ALL
 *
 DRIVER JMP (RAMSLOT)   ; CALL THE /RAM DRIVER
 *
 ERROR BRK              ; YOUR ERROR HANDLER CODE WOULD GO HERE
  RTS                   ;
</PRE>

<a name="page93"></a>

<A NAME="5.2.3"></A>

<H3>5.2.3 - The System Global Page</H3>

<P>The $BF page of memory, addresses $BF00 through $BFFF, contains the system's global variables.  Some of them, such as the system bit map and the date and time locations, can be set and used by system programs.  Others, such as the machine identification byte, are informational but are not to be changed.  Still others are for internal use of the system only.  Follow the rules described below.</P>

<P>The DFB assembler directive assigns a value to the current memory location.  The DW directive assigns a two-byte address, low byte first, to the current location.</P>

<A NAME="5.2.4"></A>

<H3>5.2.4 - Rules for Using the System Global Page</H3>

<P><B>MLI entry point.</B>  This is the only address in the global page that you should ever call:</P>

<PRE>
 BF00:        BF00    2           ORG   GLOBALS
 BF00:                3 *
 BF00:4C 4B BF        4 ENTRY     JMP   MLIENT1     ;MLI CALL ENTRY POINT
</PRE>

<P><B>Other entry points.</B>  Do not use these:</P>

<PRE>
 BF03:4C F6 BF        5 JSPARE    JMP   SYS.RTS     ;Jump Vector to cold
                                                    ;start, selector program,
                                                    ;etc.
 BF06:60 42 D7        6 DATETIME  DFB   $60,$42,$D7 ;CLOCK CALENDAR ROUTINE.
 BF09:4C F8 DF        7 SYSERR    JMP   SYSERR1     ;ERROR REPORTING HOOK.
 BF0C:4C 04 E0        8 SYSDEATH  JMP   SYSDEATH1   ;SYSTEM FAILURE HOOK.
 BF0F:00              9 SERR      DFB   $00         ;ERR CODE, 0=NO ERROR.
</PRE>

<P><B>Disk device driver vectors:</B></P>

<PRE>
 BF10:               11 *
 BF10:               12 * DEVICE DRIVER VECTORS.
 BF10:               13 *
 BF10:AB DE          14 DEVADR01  DW    GNODEV      ;SLOT ZERO RESERVED
 BF12:AB DE          15           DW    GNODEV      ;SLOT 1, DRIVE 1
 BF14:AB DE          16           DW    GNODEV      ;SLOT 2, DRIVE 1
 BF16:AB DE          17           DW    GNODEV      ;SLOT 3, DRIVE 1
 BF18:AB DE          18           DW    GNODEV      ;SLOT 4, DRIVE 1
 BF1A:AB DE          19           DW    GNODEV      ;SLOT 5, DRIVE 1
 BF1C:AB DE          20           DW    GNODEV      ;SLOT 6, DRIVE 1
 BF1E:AB DE          21           DW    GNODEV      ;SLOT 7, DRIVE 1
 BF20:AB DE          22           DW    GNODEV      ;SLOT ZERO RESERVED
 BF22:AB DE          23           DW    GNODEV      ;SLOT 1, DRIVE 2
 BF24:AB DE          24           DW    GNODEV      ;SLOT 2, DRIVE 2
 BF26:AB DE          25           DW    GNODEV      ;SLOT 3, DRIVE 2
 BF28:AB DE          26           DW    GNODEV      ;SLOT 4, DRIVE 2
 BF2A:AB DE          27           DW    GNODEV      ;SLOT 5, DRIVE 2
 BF2C:AB DE          28           DW    GNODEV      ;SLOT 6, DRIVE 2
 BF2E:AB DE          29           DW    GNODEV      ;SLOT 7, DRIVE 2
</PRE>

<a name="page94"></a>

<P><B>List of all active disk devices by unit number.</B>  When access to an unrecognized volume is requested, devices are searched from the end of the list to the beginning.  See also Sections 3.1, 3.2, and 4.4.6.  The lower half of each byte in <B><TT>DEVLST</TT></B> is a device identification: 0 = Disk II, 4 = ProFile, $F = /RAM.</P>

<PRE>
 BF30:               31 *
 BF30:               32 * CONFIGURED DEVICE LIST BY DEVICE NUMBER
 BF30:               33 * ACCESS ORDER IS LAST IN LIST FIRST.
 BF30:               34 *
 BF30:00             35 DEVNUM    DFB   $00         ;MOST RECENT ACCESSED
                                                    ;DEVICE.
 BF31:FF             36 DEVCNT    DFB   $FF         ;NUMBER OF ON-LINE DEVICES
                                                    ;(MINUS 1).
 BF32:00 00 00 00    37 DEVLST    DFB   $0,0,0,0    ;UP TO 14 UNITS MAY BE
                                                    ;ACTIVE.
 BF36:00 00 00 00    38           DFB   0,0,0,0,0
 BF3B:00 00 00 00    39           DFB   0,0,0,0,0

 BF40:28 43 29 41    41           ASC   "(C)APPLE'83"
</PRE>

<P><B>Routines reserved for MLI and subject to change.</B></P>

<PRE>
 BF4B:08             42 MLIENT1   PHP
 BF4C:78             43           SEI
 BF4D:4C B7 BF       44           JMP   MLICONT
 BF50:8D 8B C0       45 AFTIRQ    STA   RAMIN
 BF53:4C D8 FF       46           JMP   FIX45       ;Restore $45 after
                                                    ;Interrupt in Lang Card
 BF56:00             47 OLD45     DFB   0
 BF57:00             48 AFBANK    DFB   0
</PRE>

<P><B>Memory map of the lower 48K.</B>  Each bit represents one page (256 bytes) of memory.  Protected areas are marked with a <B><TT>1</TT></B>, unprotected with a <B><TT>0</TT></B>.  ProDOS disallows reading into or io_buffer allocation in protected areas.  See Section 5.1.</P>

<PRE>
 BF58:C0 00 00 00    56 MEMTABL   DFB   $C0,$00,$00,$00,$00,$00,$00,$00
 BF60:00 00 00 00    57           DFB   $00,$00,$00,$00,$00,$00,$00,$00
 BF68:00 00 00 00    58           DFB   $00,$00,$00,$00,$00,$00,$00,$01
</PRE>

<P><B>The addresses in this table are buffer addresses for open files.</B> These are informational only; they should not be changed except using the MLI call SET_BUF.</P>

<PRE>
 BF70:00 00          66 GL.BUFF   DW    $0000       ;FILE NUMBER 1
 BF72:00 00          67           DW    $0000       ;FILE NUMBER 2
 BF74:00 00          68           DW    $0000       ;FILE NUMBER 3
 BF76:00 00          69           DW    $0000       ;FILE NUMBER 4
 BF78:00 00          70           DW    $0000       ;FILE NUMBER 5
 BF7A:00 00          71           DW    $0000       ;FILE NUMBER 6
 BF7C:00 00          72           DW    $0000       ;FILE NUMBER 7
 BF7E:00 00          73           DW    $0000       ;FILE NUMBER 8
</PRE>

<a name="page95"></a>

<P>Interrupt vectors are stored here.  Again, these are informational and should be changed only by a call to the MLI using ALLOC_INTERRUPT.  <B>Values of the A, X, Y, stack, and status registers at the time of the most recent interrupt are also stored here.</B>  In addition, the address interrupted is preserved.  These may be used for performance studies and debugging, but should not be changed by the user.  The routines are polled in ascending order.  See Section 6.2.</P>

<PRE>
 BF80:00 00          85 INTRUPT1  DW    $0000       ;INTERRUPT ROUTINE 1
 BF82:00 00          86 INTRUPT2  DW    $0000       ;INTERRUPT ROUTINE 2
 BF84:00 00          87 INTRUPT3  DW    $0000       ;INTERRUPT ROUTINE 3
 BF86:00 00          88 INTRUPT4  DW    $0000       ;INTERRUPT ROUTINE 4
 BF88:00             89 INTAREG   DFB   $00         ;A-REGISTER
 BF89:00             90 INTXREG   DFB   $00         ;X-REGISTER
 BF8A:00             91 INTYREG   DFB   $00         ;Y-REGISTER
 BF8B:00             92 INTSREG   DFB   $00         ;STACK REGISTER
 BF8C:00             93 INTPREG   DFB   $00         ;STATUS REGISTER
 BF8D:01             94 INTBANKID DFB   $01         ;ROM, RAM1, OR RAM2 ($D000 IN LC)
 BF8E:00 00          95 INTADDR   DW    $0000       ;PROGRAM COUNTER RETN ADDR
</PRE>

<P><B>The following options can be changed before calls to the MLI:</B></P>

<PRE>
 BF90:00 00         101 DATELO    DW    $0000       ;BITS 15-9=YR, 8-5=MO, 4-0=DAY
 BF92:00 00         102 TIMELO    DW    $0000       ;BITS 12-8=HR, 5-0=MIN; LOW-HI FORMAT.
 BF94:00            103 LEVEL     DFB   $00         ;FILE LEVEL: USED IN OPEN, FLUSH, CLOSE.
 BF95:00            104 BUBIT     DFB   $00         ;BACKUP BIT DISABLE, SETFILEINFO ONLY.
 BF96:00 00         105 SPARE1    DFB   $00,$00     ;RESERVED FOR MLI USE
</PRE>

<P><B>The definition of MACHID at $BF98 is:</B></P>

<PRE>
 BF98:              107 *
 BF98:              108 * The following are informational only.  MACHID
 BF98:              109 * identifies the System Attributes:
 BF98:              110 * (Bit 3 off) BITS 7,6-  00=II  01=II+   10=IIe   11=/// EMULATION
 BF98:              111 * (Bit 3 on)  BITS 7,6-  00=NA  01=NA    10=//c   11=NA
 BF98:              112 *             BITS 5,4-  00=NA  01=48K   10=64K   11=128K
 BF98:              113 *             BIT  3  -  Modifier for MACHID Bits 7,6.
 BF98:              114 *             BIT  2  -  RESERVED FOR FUTURE DEFINITION.
 BF98:              115 *             BIT  1=1-  80 Column card
 BF98:              116 *             BIT  0=1-  Recognizable Clock Card
 BF98:              117 *
 BF98:              118 * SLTBYT indicates which slots are determined to have
 BF98:              119 * ROMS. PFIXPTR indicates an active PREFIX if it is
 BF98:              120 * non-zero. MLIACTV indicates an MLI call in progress
 BF98:              121 * if it is non-zero. CMDADR is the address of the last
 BF98:              122 * MLI call's parameter list. SAVX and SAVY are the
 BF98:              123 * values of X and Y when the MLI was last called.
 BF98:              124 *
 BF98:00            125 MACHID    DFB   $00         ;MACHINE IDENTIFICATION.
 BF99:00            126 SLTBYT    DFB   $00         ;'1' BITS INDICATE ROM IN SLOT(BIT#)
 BF9A:00            127 PFIXPTR   DFB   $00         ;IF = 0, NO PREFIX ACTIVE..
 BF9B:00            128 MLIACTV   DFB   $00         ;IF &#60;&#62; 0, MLI call in progress
 BF9C:00 00         129 CMDADR    DW    $0000       ;RETURN ADDRESS OF LAST CALL TO MLI.
 BF9E:00            130 SAVEX     DFB   $00         ;X-REG ON ENTRY TO MLI
 BF9F:00            131 SAVEY     DFB   $00         ;Y-REG ON ENTRY TO MLI
</PRE>

<a name="page96"></a>

<P><B>The following space is reserved for Language Card bank-switching routines.</B>  All routines and addresses are subject to change at any time without notice and will, in fact, vary with system configuration.  The routines presented here are for 64K systems only:</P>

<PRE>
 BFA0:4D 00 E0      141 EXIT      EOR   $E000       ;TEST FOR ROM ENABLE.
 BFA3:F0 05   BFAA  142           BEQ   EXIT1       ;BRANCH IF RAM ENABLED.
 BFA5:8D 82 C0      143           STA   ROMIN       ;ELSE ENABLE ROM &#38; RETURN.
 BFA8:D0 0B   BFB5  144           BNE   EXIT2       ;BRANCH ALWAYS
 BFAA:              145 **
 BFAA:AD F5 BF      146 EXIT1     LDA   BNKBYT2     ;FOR ALT RAM (MOD BY MLIENT1)
 BFAD:4D 00 D0      147           EOR   $D000       ;ENABLE.
 BFB0:F0 03   BFB5  148           BEQ   EXIT2       ;BRANCH IF NOT ALT RAM.
 BFB2:AD 83 C0      149           LDA   ALTRAM      ;ELSE ENABLE ALT $D000
 BFB5:68            150 EXIT2     PLA               ;RESTORE RETURN CODE.
 BFB6:40            151           RTI               ;RE-ENABLE INTERRUPTS &#38; RETURN
 BFB7:              152 **
 BFB7:38            153 MLICONT   SEC
 BFB8:6E 9B BF      154           ROR   MLIACTV     ;INDICATE TO INTERRUPT ROUTINES MLI ACTIVE.
 BFBB:AD 00 E0      155           LDA   $E000       ;PRESERVE LANGUAGE CARD / ROM
 BFBE:8D F4 BF      156           STA   BNKBYT1     ; ORIENTATION FOR PROPER
 BFC1:AD 00 D0      157           LDA   $D000       ; RESTORATION WHEN MLI EXITS...
 BFC4:8D F5 BF      158           STA   BNKBYT2
 BFC7:AD 8B C0      159           LDA   RAMIN       ;NOW FORCE RAM CARD ON
 BFCA:AD 8B C0      160           LDA   RAMIN       ; WITH RAM WRITE ALLOWED.
 BFCD:4C 00 DE      161           JMP   ENTRYMLI
</PRE>

<P><B>Interrupt exit and entry routines:</B></P>

<PRE>
 BFD0:              163 *
 BFD0:              164 * INTERRUPT EXIT/ENTRY ROUTINES
 BFD0:              165 *

 BFD0:AD 8D BF      167 IRQXIT    LDA   INTBANKID   ;DETERMINE STATE OF RAM CARD
 BFD3:F0 0D   BFE2  168 IRQXIT0   BEQ   IRQXIT2     ; IF ANY.  BRANCH IF ENABLED.
 BFD5:30 08   BFDF  169           BMI   IRQXIT1     ;BRANCH IF ALTERNATE $D000 ENABLED.
 BFD7:4A            170           LSR   A           ;DETERMINE IF NO RAM CARD PRESENT.
 BFD8:90 0D   BFE7  171           BCC   ROMXIT      ;BRANCH IF ROM ONLY SYSTEM.
 BFDA:AD 81 C0      172           LDA   ROMIN1      ;ELSE ENABLE ROM FIRST.
 BFDD:B0 08   BFE7  173           BCS   ROMXIT      ;BRANCH ALWAYS TAKEN...
 BFDF:AD 83 C0      174 IRQXIT1   LDA   ALTRAM      ;ENABLE ALTERNATE $D000.
 BFE2:A9 01         175 IRQXIT2   LDA   #1          ;PRESET BANKID FOR ROM.
 BFE4:8D 8D BF      176           STA   INTBANKID   ;(RESET IF RAM CARD INTERRUPT)
 BFE7:AD 88 BF      177 ROMXIT    LDA   INTAREG     ;RESTORE ACCUMULATOR...
 BFEA:40            178           RTI               ; AND EXIT!

 BFEB:2C 8B C0      180 IRQENT    BIT   RAMIN       ;THIS ENTRY ONLY USED WHEN ROM
 BFEE:2C 8B C0      181           BIT   RAMIN       ; WAS ENABLED AT TIME OF INTERRUT.
 BFF1:4C 4D DF      182           JMP   IRQRECEV    ; A-REG IS STORED AT $45 IN ZPAGE.
 BFF4:00            183 BNKBYT1   DFB   $00
 BFF5:00            184 BNKBYT2   DFB   $00
 BFF6:              185 **
 BFF6:2C 8B C0      186 SYS.RTS   BIT   RAMIN       ;Make certain Language card is switched in
 BFF9:4C 02 E0      187           JMP   SYS.END     ;Or anywhere else we need to go
</PRE>

<P><B>Each system program should set IVERSION to its own current version number.  ProDOS sets KVERSION to its current version number.</B></P>

<PRE>
 BFFC:00            188 IBAKVER   DFB   $00         ;UNDEFINED: Reserved for future use
 BFFD:00            189 IVERSION  DFB   $00         ;Version # of currently running Interpreter
 BFFE:00            191 KBAKVER   DFB   $00         ;UNDEFINED: Reserved for future use
 BFFF:02            192 KVERSION  DFB   $2          ;VERSION NO. (RELEASE ID)
</PRE>

<a name="page97"></a>

<A NAME="5.3"></A>

<H2>5.3 - General Techniques</H2>

<P>The first part of this chapter discusses the things that a system program must do.  This section of the manual describes some of the things that system programs commonly do, and it gives some techniques for implementing them.</P>

<A NAME="5.3.1"></A>

<H3>5.3.1 - Determining Machine Configuration</H3>

<P>It is often useful for a system program to know what type of Apple II it is running on.  The MACHID byte in the system global page identifies the machine type, the amount of memory, and whether an 80-column text card or clock/calendar card was detected.</P>

<P>MACHID byte: see Section 5.2.3.</P>

<A NAME="5.3.1.1"></A>

<H4>5.3.1.1 - Machine Type</H4>

<P>Two bits distinguish an Apple II, an Apple II Plus, an Apple IIe, an Apple IIc, or an Apple III in Apple II emulation mode.  This distinction is most useful for two reasons:</P>

<OL>

<LI>The Apple IIe and IIc always have lowercase available.  Screen messages can be coded using uppercase and lowercase, and then made all uppercase if the machine is not an Apple IIe or IIc (or if it is a Apple II without an 80-column text card).</li>

<LI>The Apple IIe and IIc have keys that are not available on earlier versions of the Apple II (most notably [UP], [DOWN], [OA], [SA], and [DELETE]).  Software should be coded to use the keys most convenient for the system it is running on, and the screen messages should be adjusted accordingly.</li>

</OL>

<A NAME="5.3.1.2"></a>

<H4>5.3.1.2 - Memory Size</H4>

<P>The possible memory sizes are 64K and 128K.  A system program can use these values when deciding where to relocate itself.  Recall that the alternate 64K bank cannot contain code that makes calls to the MLI and it cannot be used for system buffers.</P>

<A NAME="page98"></a>

<A NAME="5.3.1.3"></A>

<H4>5.3.1.3 - 80-Column Text Card</H4>

<P>This bit is always set in the Apple IIc.  It is set in an Apple IIe if an 80-column text card that follows the defined protocol is in slot 3 or in the auxiliary slot.  This protocol guarantees that the features of the card can be turned on by a JSR to $C300, the beginning of the ROM on the card (note that this disconnects BASIC.SYSTEM).</P>

<P>80-column text cards -- and other Apple IIe features -- can be turned off using the following sequence of instructions:</P>

<PRE>
 LDA #$15     ;Character that turns off video firmware
 JSR $C300   ;Print it to the video firmware
</PRE>

<a name="5.3.2"></A>

<H3>5.3.2 - Using the Date</H3>

<P>A system program often has reason to use the current date: to mark files with a modification date, to use as identification on a listing, or just for display on the screen.  Whatever the use, it is usually desirable to obtain the most current setting.</P>

<P>Save the system date and time locations ($BF90-BF93) for possible future use, and then clear them.  Next use the GET_TIME call.  If there is a clock/calendar card with an installed clock routine, then the system date and time locations will become nonzero.  This is the date and time you should use.  If the GET_TIME call has no effect, then you should either use the values that were previously in the date and time locations, or prompt the user for the current date and time.  Since the date and time locations are set to 0 when the system is started (unless ProDOS recognizes a clock/calendar card), it is reasonable to use nonzero values of the date and time locations as a default date and time.</P>

<P>If there is no system time, and the call to GET_TIME returns nothing an alternative is to use the GET_FILE_INFO call and to use the last modified date and time as a default.  If the user updates the time, and you place these values in the system date and time locations, a SET_FILE_INFO call will update the time for the next GET_FILE_INFO.</P>

<P>The system updates the date and time at every CREATE, DESTROY, RENAME SET_FILE_INFO CLOSE, and FLUSH operation.</P>

<P>Refer to the GET_TIME call in Chapter 4, and to the description of clock/calendar routines in Chapter 6 for more details.</P>

<A NAME="page99"></a>

<A NAME="5.3.3"></A>

<H3>5.3.3 - System Program Defaults</H3>

<P>Each file entry in a directory has a two-byte aux_type field.  This field contains information such as load address for BASIC programs or binary files, and record length for text files; for system files it is unused.  If your system program has a small amount of default information that you would like to preserve from one execution of the program to the next, this field is a good place to store it.</P>

<P>To alter the contents of this field, use the GET_FILE_INFO call to read the current contents of the file's entry, change the values in the aux_id field, then use the SET_FILE_INFO call with the same parameter list to save the modified values in the file's entry.</P>

<A NAME="5.3.4"></A>

<H3>5.3.4 - Finding a Volume</H3>

<P>Since one does not always know the names of all the online volumes, it is sometimes necessary to allow users to specify volumes by slot and drive instead of by volume name.  Before the slot and drive information can be used to access ProDOS files, it must be converted to a volume name.  To convert slot and drive numbers to volume names, you can use the following steps:</P>

<OL>

<LI>Make the slot and drive numbers into a unit_num.  This number is used to specify the desired device to the ON_LINE call.  The format of a unit_num is given in Section 4.4.6.</li>

<LI>Use the unit_num in the ON_LINE call.  This call will return a count byte followed by the volume name.  This volume name is not preceded by a slash.  You must increase the count by one and insert a slash preceding the volume name before using this name in other ProDOS calls.</li>

</OL>

<a name="page100"></a>

<A NAME="5.3.5"></A>

<H3>5.3.5 - Using the RESET Vector</H3>

<P>In the Apple II, pressing [CONTROL]-[RESET] causes an unconditional jump to the RESET vector (at $3F2 in memory).  Because the user can press [CONTROL]-[RESET] at any time -- including while files are open -- ProDOS cannot take responsibility for disk integrity after [RESET] has been pressed: the system program must do it.</P>

<P>Your program should place in the RESET vector the address of a routine that displays a message advising that it will be closing any open files, and then close the files.  Once this is done, the program may take any action required by the application.  It is preferable either to jump back to the beginning of the program or to jump directly to the quit routine.</P>

<A NAME="5.4"></A>

<H2>5.4 - ProDOS System Program Conventions</H2>

<P>For the sake of consistency from one piece of software to the next follow the conventions used in this manual:</P>

<UL>

<LI>Use the same terminology whenever possible.  If your application implements any of the functions used by the BASIC system program, the Filer, the Convert program, or the Editor/Assembler, try to use the same wording.</li>

<LI>Use the same catalog format in all software that displays a list of files.  It is not necessary to implement both the 40- and 80-column formats (see the CAT and CATALOG commands of the BASIC system program).<br /><br />If you choose to implement your own version of this command, recognize the file types and display the three-letter abbreviations that are shown in the quick reference card of this manual.</li>

<LI>The standard Apple II "Air-raid" bell has been replaced with a gentler tone.  Use it to give users some aural feedback that they are using a ProDOS program.  The code for it follows.

<br /><br />

<a name="page101"></a>

<PRE>
 SPKR      EQU   $C030         ;this clicks the speaker
 *
 LENGTH    DS    1             ;duration of tone
 *
 * This is the wait routine from the Monitor ROM.
 *
 WAIT      SEC
 WAIT2     PHA
 WAIT3     SBC   #1
           BNE   WAIT3
           PLA
           SBC   #1
           BNE   WAIT2
           RTS
 *
 * Generate a nice little tone
 * Exits with Z-flag set (BEQ) for branching
 * Destroys the contents of the accumulator
 *
 BELL      LDA   #$20          ;duration of tone
           STA   LENGTH
 BELL1     LDA   #$2           ;short delay...click
           JSR   WAIT
           STA   SPKR
           LDA   #$20          ;long delay...click
           JSR   WAIT
           STA   SPKR
           DEC   LENGTH
           BNE   BELL1         ;repeat LENGTH times
           RTS
</PRE>

</li>

</UL>

<a name="page102"></a>
