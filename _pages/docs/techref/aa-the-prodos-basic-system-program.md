---
layout:      page
title:       TechRef - Appendix - The ProDOS BASIC System Program
description: ProDOS 8 Technical Reference Manual The ProDOS BASIC System Program
permalink:   /docs/techref/the-prodos-basic-system-program/
---

<A NAME="A"><H1>Appendix A<br />The ProDOS BASIC System Program</H1></A><a name="page117"></a>

<P>This appendix explains aspects of the BASIC system program<br />
(BASIC.SYSTEM) that are beyond the scope of the manual <I>BASIC<br />
Programming With ProDOS</I>.  The primary subjects discussed in this<br />
appendix are</P><UL>

<LI>how the BASIC system program uses memory

<LI>how a machine-language program can make calls to the BASIC<br />
system program

<LI>useful locations in the BASIC system program

<LI>how you can add commands to the BASIC system program.

</UL>

<A NAME="A.1"><H2>A.1 - Memory Map</H2></A><P>The arrangement of ProDOS in memory is decided when the system is<br />
started up, and it depends on your particular system configuration.<br />
Figure A-1 shows the memory organization for an Apple IIe (64K or<br />
128K) or Apple IIc (128K).</P><a name="page118"></a>

<A NAME="A-1"><P><B>Figure A-1.  Memory Map</B></P></A><PRE>
             
             
             
             
             
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
</PRE><a name="page119"></a>

<A NAME="A.2"><H2>A.2 - HIMEM</H2></A><P>When ProDOS starts up the BASIC system program, it loads all the<br />
necessary programs and data into memory as shown in Figure A-1,<br />
leaves a 1K buffer on the highest available 1K boundary, and then sets<br />
HIMEM right below this buffer.  This buffer is used as the file buffer<br />
for commands, such as CATALOG, that only need a temporary buffer.<br />
Table A-1 shows the possible settings of HIMEM, and the maximum<br />
number of bytes available to a program running under such a system<br />
configuration.</P><A NAME="A-1T"><P><B>Table A-1.  HIMEM and Program Workspace</B></P></A><PRE>































 <B>System                                          Bytes Available
 Configuration           HIMEM                   to Programs</B>

 64K                     38400 ($9600)           36352 ($8E00)
 Applesoft in ROM
</PRE><P>These settings are in effect immediately after you boot the BASIC<br />
system program.  While a program is running, however, these figures<br />
may change.  Each time a file is opened, ProDOS lowers HIMEM<br />
by 1K ($400), keeping the 1K temporary command buffer immediately<br />
above it, and places a buffer for the file where the old temporary<br />
buffer was.  When a file is closed, ProDOS releases the file's buffer, and<br />
raises HIMEM by 1K.  Figure A-2 illustrates this process.</P><a name="page120"></a>

<A NAME="A-2"><P><B>Figure A-2.  The Movement of HIMEM</B></P></A><PRE>
  _______      _______      _______      _______      _______      _______
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |_______|    |_______|    |_______|    |_______|    |_______|    |_______|
 |       |    |///////|    |       |    |       |    |       |    |       |
 | Free  | 1K |/CAT's/| 1K | Free  | 1K | DOG's | 1K | DOG's | 1K | Free  | 1K
 |_______|    |_______|    |_______|    |_______|    |_______|    |_______|
 |       |    |       |    |       |    |       |    |       |    |       |
 | HIMEM |    | HIMEM |    | HIMEM |    | Free  | 1K | CAT's | 1K | HIMEM |
 |       |    |       |    |       |    |_______|    |_______|    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    | HIMEM |    | HIMEM |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |       |    |       |    |       |    |       |    |       |    |       |
 |_______|    |_______|    |_______|    |_______|    |_______|    |_______|

 No Files     During CAT   After CAT    Open "DOG"   During CAT   Close "DOG"
   Open
</PRE><A NAME="A.2.1"><H3>A.2.1 - Buffer Management</H3></A><P>There are many times when you might want machine-language<br />
routines to coexist with ProDOS; for example, when using<br />
interrupt-driven devices, when using input/output devices that have no<br />
ROM, or when using commands that you have added to ProDOS.</P><P>BASIC.SYSTEM provides buffer management for file I/O.  Those<br />
facilities can also be utilized from machine-language modules operating<br />
in the ProDOS/Applesoft environment to provide protected areas for<br />
code, data, and so on.</P><P>BASIC.SYSTEM resides from $9A00 upward, with a general-purpose<br />
buffer from $9600 (HIMEM) to $99FF.  When a file is opened,<br />
BASIC.SYSTEM does garbage collection if needed, moves the<br />
general-purpose buffer down to $9200, and installs a file I/O buffer at<br />
$9600.  When a second file is opened, the general-purpose buffer is<br />
moved down to $8E00 and a second file I/O buffer is installed at<br />
$9200.  If an EXEC file is opened, it is always installed as the highest<br />
file I/O buffer at $9600, and all the other buffers are moved down.<br />
Additional regular file I/O buffers are installed by moving the<br />
general-purpose buffer down and installing it below the lowest file I/O<br />
buffer.  All file I/O buffers, including the general-purpose buffer, are 1K<br />
(1024 bytes) and begin on a page boundary.</P><a name="page121"></a>

<P>BASIC.SYSTEM may be called from machine language to allocate any<br />
number of pages (256 bytes) as a buffer, located above HIMEM and<br />
protected from Applesoft BASIC programs.  The ProDOS bit map is not<br />
altered, so that files can be loaded into the area without an error from<br />
the ProDOS Kernel.  If you subsequently alter the bit map to protect the<br />
area, you must mark the area as free when you are finished -- <br />
BASIC.SYSTEM will not do it for you.</P><P>To allocate a buffer, simply place the number of desired pages in the<br />
accumulator and use <B><TT>JSR GETBUFR</TT></B> ($BEF5).  If the carry flag<br />
returns clear, the allocation was successful and the accumulator will<br />
return the high byte of the buffer address.  If the carry flag returns set,<br />
an error has occurred and the accumulator will return the error code.<br />
Note that the X and Y registers are not preserved.</P><P>The first buffer is installed as the highest buffer, just below<br />
BASIC.SYSTEM from $99FF downward, regardless of the number and<br />
type of file I/O buffers that are open.  If a second allocation is<br />
requested, it is installed immediately below the first.  Thus, it is<br />
possible to assemble code to run at known addresses-relocatable<br />
modules are not needed.</P><P>To de-allocate the buffers created by the above call and move the file<br />
buffers back up, just use <B><TT>JSR FREEBUFR</TT></B> ($BEF8).  Although more<br />
than one buffer may be allocated by this call, they may not be<br />
selectively de-allocated.</P><P><B>Important!</B><br />
All routines that are to be called by BASIC.SYSTEM should begin with<br />
the CLD instruction.  This includes I/O routines accessed by <B><TT>PR#</TT></B> and<br />
<B><TT>IN#</TT></B> and clock/calendar routines.  This allows ProDOS to spot<br />
accidental calls.</P><P>For tips on raising LOMEM to provide more memory for<br />
assembly-language routines, and protecting high-res graphics pages, see<br />
the <I>Applesoft BASIC Programmer's Reference Manual</I>.</P><a name="page122"></a>

<A NAME="A.3"><H2>A.3 - The BASIC Global Page</H2></A><P>The BASIC system program has a specific area of memory, its global<br />
page, in which it keeps its current status.  This page lies in the address<br />
range $BE00 through $BEFF (48640-48895).  When BASIC.SYSTEM is<br />
active, its fields are defined as follows:</P><PRE>
 BE00:  CI.ENTRY  JMP WARMDOS     ;Reenter ProDOS/Applesoft
 BE03:  DOSCMD    JMP SYNTAX      ;External entry for command string
 BE06:  EXTRNCMD  JMP XRETURN     ;Called for added CMD syntaxing
 BE09:  ERROUT    JMP ERROR       ;Handles ONERR or prints error
 BE0C:  PRINTERR  JMP PRTERR      ;Prints error message
                                  ;Number is in accumulator
 BE0F:  ERRCODE   DFB 0           ;ProDOS error code stored here
                                  ;and $DE for Applesoft
</PRE><a name="page123"></a>

<P><B>Default I/O vectors.</B>  These may be changed by the user to remap<br />
slots for nondisk devices.  When the system is booted, all slots not<br />
containing a ROM are considered <I>not connected</I> and the default vector<br />
is left to point at the appropriate error handling routine.</P><PRE>
 BE10:  OUTVECT0  DW  COUT1       ;Monitor video output routine
 BE12:  OUTVECT1  DW  NODEVERR    ;Default $C100 when ROM present
 BE14:  OUTVECT2  DW  NODEVERR    ;Default $C200 when ROM present
 BE16:  OUTVECT3  DW  NODEVERR    ;Default $C300 when ROM present
 BE18:  OUTVECT4  DW  NODEVERR    ;Default $C400 when ROM present
 BE1A:  OUTVECT5  DW  NODEVERR    ;Default $C500 when ROM present
 BE1C:  OUTVECT6  DW  NODEVERR    ;Default $C600 when ROM present
 BE1E:  OUTVECT7  DW  NODEVERR    ;Default $C700 when ROM present
 BE20:  INVECT0   DW  CHIN1       ;Monitor keyboard input routine
 BE22:  INVECT1   DW  NODEVERR    ;Default $C100 when ROM present
 BE24:  INVECT2   DW  NODEVERR    ;Default $C200 when ROM present
 BE26:  INVECT3   DW  NODEVERR    ;Default $C300 when ROM present
 BE28:  INVECT4   DW  NODEVERR    ;Default $C400 when ROM present
 BE2A:  INVECT5   DW  NODEVERR    ;Default $C500 when ROM present
 BE2C:  INVECT6   DW  NODEVERR    ;Default $C600 when ROM present
 BE2E:  INVECT7   DW  NODEVERR    ;Default $C700 when ROM present
 BE30:  VECTOUT   DW  COUT1       ;Current character output routine
 BE32:  VECTIN    DW  CHIN1       ;Current character input routine
 BE34:  VDOSIO    DW  DOSOUT      ;ProDOS char out intercept routine
</PRE><a name="page124"></a>

<PRE>
 BE36:            DW  DOSINP      ;ProDOS char in intercept routine
 BE38:  VSYSIO    DW  0,0         ;Internal redirection of I/O
 BE3C:  DEFSLT    DFB $06         ;Default slot, set by 'S' parm
 BE3D:  DEFDRV    DFB $01         ;Default drive, set by 'D' parm
 BE3E:  PREGA     DFB 0           ;Register save area
 BE3F:  PREGX     DFB 0
 BE40:  PREGY     DFB 0
 BE41:  DTRACE    DFB 0           ;Applesoft trace enable
 BE42:  STATE     DFB 0           ;0=Imm, &#62;0=Def modes
 BE43:  EXACTV    DFB 0           ;EXEC file active if bit 7 on
 BE44:  IFILACTV  DFB 0           ;Input file active if bit 7 on
 BE45:  OFILACTV  DFB 0           ;Output file active if bit 7 on
 BE46:  PFXACTV   DFB 0           ;Prefix input active if bit 7 on
 BE47:  DIRFLG    DFB 0           ;File being accessed is directory
 BE48:  EDIRFLG   DFB 0           ;End of directory encountered
 BE49:  STRINGS   DFB 0           ;Counter for free string space
 BE4A:  TBUFPTR   DFB 0           ;Temporary buffered char count (WRITE)
 BE4B:  INPTR     DFB 0           ;Input char count during kbd input
 BE4C:  CHRLAST   DFB 0           ;Last character output (for error detect)
 BE4D:  OPENCNT   DFB $00         ;Number of open file (except EXEC file)
 BE4E:  EXFILE    DFB $00         ;Flag to indicate EXEC file being closed
 BE4F:  CATFLAG   DFB $00         ;File being input is (translated) dir
 BE50:  XTRNADDR  DW  0           ;Execution address of external cmd (0)
 BE52:  XLEN      DFB 0           ;Length of command string-1, ('HELP'=3)
 BE53:  XCNUM     DFB 0           ;BASIC cmd number (external cmd if =0)
</PRE><a name="page125"></a>

<P>Command parameter <B><TT>PBITS/FBITS</TT></B> bit definitions:</P><PRE>
 BE54:  PFIX      EQU $80         ;Prefix needs fetching, pathname optional
 BE54:  SLOT      EQU $40         ;No parameters to be processed
 BE54:  RRUN      EQU $20         ;Command only valid during program
 BE54:  FNOPT     EQU $10         ;Filename is optional
 BE54:  CRFLG     EQU $08         ;CREATE allowed
 BE54:  T         EQU $04         ;File type
 BE54:  FN2       EQU $02         ;Filename '2' for RENAME
 BE54:  FN1       EQU $01         ;Filename expected
</PRE><P>And for <B><TT>PBITS+1/FBITS+1</TT></B> definitions:</P><PRE>
 BE54:  AD        EQU $80         ;Address
 BE54:  B         EQU $40         ;Byte
 BE54:  E         EQU $20         ;End address
 BE54:  L         EQU $10         ;Length
 BE54:  LINE      EQU $08         ;'@' line number
 BE54:  SD        EQU $04         ;Slot and drive numbers
 BE54:  F         EQU $02         ;Field
 BE54:  R         EQU $01         ;Record
 BE54:  V         EQU $00         ;Volume number ignored
</PRE><P>When the BASIC system program recognizes one of its commands,<br />
it sets up <B><TT>PBITS</TT></B> to indicate which parameters (#S, #D, and so<br />
on) may be used with that command.  Then it parses the command<br />
string, marking the found parameters in <B><TT>FBITS</TT></B>, and placing<br />
their values in locations $BE58-$BE6B.  The meanings of the bit<br />
within <B><TT>PBITS</TT></B> and <B><TT>FBITS</TT></B> are discussed in the section "Adding<br />
Commands to the BASIC System Program."</P><PRE>
 BE54:  PBITS     DW  0           ;Allowed parameter bits
 BE56:  FBITS     DW  0           ;Found parameter bits
</PRE><a name="page126"></a>

<P><B>The following locations hold the values of the parameters for the<br />
BASIC commands.</B>  As the BASIC system program parses command<br />
options, it sets the value of the corresponding command parameters.<br />
Previously set parameters do not change.</P><PRE>
 BE58:  PVALS     EQU *
 BE58:  VADDR     DW  0           ;Parameter value for 'A' parm
 BE5A:  VBYTE     DFB 0,0,0       ;Parameter value for 'B' parm
 BE5D:  VENDA     DW  0           ;Parameter value for 'E' parm
 BE5F:  VLNTH     DW  0           ;Parameter value for 'L' parm
 BE61:  VSLOT     DFB 0           ;Parameter value for 'S' parm
 BE62:  VDRIV     DFB 0           ;Parameter value for 'D' parm
 BE63:  VFELD     DW  0           ;Parameter value for 'F' parm
 BE65:  VRECD     DW  0           ;Parameter value for 'R' parm
 BE67:  VVOLM     DFB 0           ;Parameter value for 'V' parm
 BE68:  VLINE     DW  0           ;Parameter value for '@' parm
 BE6A:  PTYPE     EQU *-PVALS
 BE6A:  VTYPE     DFB 0           ;Parameter value for 'T' parm
 BE6B:  PIOSLT    EQU *-PVALS
 BE6B:  VIOSLT    DFB 0           ;Parameter value for IN# or PR#
 BE6C:  VPATH1    DW  TXBUF-1     ;Pathname 1 buffer
 BE6E:  VPATH2    DW  TXBUF2      ;Pathname 2 buffer (RENAME)
</PRE><a name="page127"></a>

<P><B><TT>GOSYSTEM</TT> is used to make all MLI calls since errors must be<br />
translated before returning to the calling routine.</B>  On entry the<br />
Accumulator should contain the call number.  The address of the<br />
parameter table is looked up and set based on the call number.  Only<br />
file management calls can be made using this routine: $C0-$D3.  The<br />
original implementation of this BASIC system program contains only<br />
these calls.</P><PRE>
 BE70:  GOSYSTEM  STA SYSCALL     ;Save call number
 BE73:            STX CALLX       ;Preserve X register
 BE76:            AND #$1F        ;Strip high bits of call number
 BE78:            TAX             ; and use as lookup index
 BE79:            LDA SYSCTBL,X   ;Get low address of parm table
 BE7C:            STA SYSPARM
 BE7F:            LDX CALLX       ;Restore X before calling
 BE82:            JSR MLIENTRY    ;Call ProDOS MLI to execute request
 BE85:  SYSCALL   DFB 0
 BE86:  SYSPARM   DW  *           ;(High address should be same
                                  ; as parameter tables)
 BE88:            BCS BADCALL     ;Branch if error encountered
 BE8A:            RTS
</PRE><P><P><B><TT>BADCALL</TT> converts MLI errors into BASIC system program error<br />
equivalents.</B>  Routines should be entered with error number in the<br />
Accumulator.  The <B><TT>BADCALL</TT></B> routine should be used whenever a<br />
ProDOS MLI call returns an error and BASIC.SYSTEM will be used to<br />
print the error message.  Returns BASIC system program error number<br />
in Accumulator.  All unrecognized errors are mapped to I/O error.<br />
X register is restored to its value before the call is made.  Carry is set.</P><PRE>
 BE8B:  BADCALL   LDA #12         ;19 errors are mapped to
 BE8D:  MLIERR1   CMP MLIERTBL,X  ; other than I/O error
 BE90:            BEQ MLIERR2
 BE92:            DEX
 BE93:            BPL MLIERR1
 BE95:            LDX #$13        ;If not recognized, make it I/O error
 BE97:  MLIERR2   LDA BIERRTBL,X  ;return error in Accumulator
 BE9A:            LDX CALLX       ;Restore X register
 BE9D:            SEC             ;Set Carry to indicate error
 BE9E:  XRETURN   RTS
 BE9F:  CISPARE1  DFB $00
</PRE><a name="page128"></a>

<P><B>The following are the system-call parameter tables.</B>  These tables<br />
must reside within the same page of memory.  Only those parameters<br />
that are subject to alterations have been labeled.  <B><TT>SYSCTBL</TT></B> below<br />
contains the low-order addresses of each parameter table.  <B><TT>SYSCTBL</TT></B><br />
is used by <B><TT>GOSYSTEM</TT></B> to set up the address of the parameter table<br />
for each call.  (See <B><TT>GOSYSTEM</TT></B>.)</P><PRE>
 BEA0:  SCREATE   DFB $07
 BEA1:            DW  TXBUF-1     ;Pointer to pathname
 BEA3:  CRACESS   DFB $C3         ;$C1 if directory create
 BEA4:  CRFILID   DFB $00
 BEA5:  CRAUXID   DW  $0000
 BEA7:  CRFKIND   DFB 0
 BEA8:            DW  0           ;No predetermined date/time
 BEAA:            DW  0
 BEAC:  SSGPRFX   EQU *
 BEAC:  SDSTROY   DFB $01
 BEAD:            DW  TXBUF-1     ;This call requires no modifications
 BEAF:  SRECNAME  DFB $02
 BEB0:            DW  TXBUF-1     ;No modifications needed
 BEB2:            DW  TXBUF2
 BEB4:  SSGINFO   DFB $00         ;P.CNT=7 if SET_FILE_INFO
                                  ;P.CNT=A if GET_FILE_INFO
 BEB5:            DW  TXBUF-1
 BEB7:  FIACESS   DFB $00         ;Access used by lock/unlock
 BEB8:  FIFILID   DFB $00         ;FILE ID is type specifier
 BEB9:  FIAUXID   DW  $0000       ;Aux_id is used for load addr
                                  ; and record length
 BEBB:  FIFKIND   DFB $00         ;Identifies trees vs. directories
 BEBC:  FIBLOKS   DW  $0000       ;Used by CAT commands for root dir
 BEBE:  FIMDATE   DW  $0000       ;Modification date &#38; time
 BEC0:            DW  $0000       ;should always be zeroed before call
 BEC2:            DW  $0000       ;Create date and time ignored
 BEC4:            DW  $0000
</PRE><a name="page129"></a>

<PRE>
 BEC6:  SONLINE   EQU *
 BEC6:  SSETMRK   EQU *
 BEC6:  SGETMRK   EQU *
 BEC6:  SSETEOF   EQU *
 BEC6:  SGETEOF   EQU *
 BEC6:  SSETBUF   EQU *
 BEC6:  SGETBUF   EQU *
 BEC6:            DFB $02         ;Parameter count
 BEC7:  SBUFREF   EQU *
 BEC7:  SREFNUM   EQU *
 BEC7:  SUNITNUM  EQU *
 BEC7:            DFB 0           ;Unit or reference number
 BEC8:  SDATPTR   EQU *
 BEC8:  SMARK     EQU *
 BEC8:  SEOF      EQU *
 BEC8:  SBUFADR   EQU *
 BEC8:            DFB 0,0,0       ;Some calls only use 2 bytes
                                  ;MRK &#38; EOF use 3 bytes
 BECB:  SOPEN     DFB $03
 BECC:            DW  TXBUF-1
 BECE:  OSYSBUF   DW  $0000
 BED0:  OREFNUM   DFB 0
 BED1:  SNEWLIN   DFB $03
 BED2:  NEWLREF   DFB $00         ;Reference number
 BED3:  NLINEBL   DFB $7F         ;Newline character is always CR
 BED4:            DFB $0D         ; both $0D and $8D are recognized
 BED5:  SREAD     EQU *
 BED5:  SWRITE    EQU *
 BED5:            DFB $04
 BED6:  RWREFNUM  DFB $00
 BED7:  RWDATA    DW  $0000       ;Pointer to data to be read/written
 BED9:  RWCOUNT   DW  $0000       ;Number of bytes to be read/written
 BEDB:  RWTRANS   DW  $0000       ;returned # of bytes read/written
</PRE><a name="page130"></a>

<PRE>
 BEDD:  SCLOSE    EQU *
 BEDD:  SFLUSH    EQU *
 BEDD:            DFB $01
 BEDE:  CFREFNUM  DFB $00
 BEDF:  CCCSPARE  DFB $00
 BEE0:            ASC 'COPYRIGHT APPLE, 1983'
 BEF5:  GETBUFR   JMP GETPAGES
 BEF8:  FREBUFR   JMP FREPAGES
 BEFB:  RSHIMEM   DFB 0, 0, 0, 0, 0
</PRE><A NAME="A.3.1"><H3>A.3.1 - BASIC.SYSTEM Commands From Assembly Language</H3></A><P>There are times when a routine wants to perform functions that are<br />
already implemented by the BASIC system program -- deleting and<br />
renaming files, displaying a directory, and so on.  The <B><TT>DOSCMD</TT></B> vector<br />
serves just this function.</P><P>First a routine should place the desired BASIC command in the input<br />
buffer ($200).  It should be an ASCII string with the high bits set,<br />
followed by a carriage return ($8D), exactly as the Monitor <B><TT>GETLN</TT></B><br />
routine would leave a string.  Next the routine should do a JSR to the<br />
<B><TT>DOSCMD</TT></B> entry point ($BE03).</P><P>BASIC.SYSTEM will parse the command, set up all the parameters, (as<br />
explained in Section A.3.3), and then execute the command.  If there is<br />
an error, it will return the error code in the accumulator with the<br />
carry set.  If it is 0, there was no error.  Otherwise it contains a BASIC<br />
system program error number.</P><P><B>Note:</B> The <B><TT>JSR DOSCMD</TT></B> must be executed in deferred mode (from<br />
a BASIC program), rather than in immediate mode.  This applies also to<br />
the Monitor program: from the Monitor, you can't do a <B><TT>$xxxxG</TT></B> to<br />
execute the code that contains the <B><TT>JSR DOSCMD</TT></B>.  This is because<br />
BASIC.SYSTEM checks certain state flags, which are set correctly only<br />
while in deferred mode.</P><P>There are certain commands that do <I>not</I> work as expected when<br />
initiated via <B><TT>DOSCMD</TT></B>: RUN -(dash command), LOAD, CHAIN, READ,<br />
WRITE, APPEND, and EXEC.  Use them this way at your own risk.</P><a name="page131"></a>

<P>The commands that <I>do</I> work correctly are: CATALOG, CAT, PREFIX,<br />
CREATE, RENAME, DELETE, LOCK, UNLOCK, SAVE, STORE,<br />
RESTORE, PR#, IN#, FRE, OPEN, CLOSE, FLUSH, POSITION, BRUN,<br />
BLOAD, and BSAVE.</P><P>The following are:</P><OL>

<LI>An example of a BASIC program that uses the BLOAD command to<br />
load an assembly-language routine that exercises the <B><TT>DOSCMD</TT></B><br />
routine.

<LI>A listing of that assembly-language routine.</P></OL><P>You should review them before writing your own routine.</P><PRE>
 10 REM YOU MUST CALL THE ROUTINE FROM INSIDE A BASIC PROGRAM
 11 REM
 12 REM
 20 PRINT CHR$(4)"BLOAD/P/PROGRAMS/CMD.0"
 30 CALL 4096
 40 PRINT "BACK TO THE WONDERFUL WORLD OF BASIC!"
 50 END
</PRE><a name="page132"></a>

<PRE>
 1000:        1000    1           ORG   $1000
 1000:        FD6F    2 GETLN1    EQU   $FD6F         ; MONITORS INPUT ROUTINE
 1000:        BE03    3 DOSCMD    EQU   $BE03         ; BASIC.SYSTEM GLBL PG DOS CMD ENTRY
 1000:        FDED    4 COUT      EQU   $FDED         ; MONITORS CHAR OUT ROUTINE
 1000:        BE0C    5 PRERR     EQU   $BE0C         ; PRINT THE ERROR
 1000:                6 *
 1000:                7 *
 1000:                8 *
 1000:A2 00           9 START     LDX   #0            ; DISPLAY PROMPT...
 1002:BD 1F 10       10 L1        LDA   PROMPT,X      ;
 1005:F0 06   100D   11           BEQ   CONT          ; BRANCH IF END OF STRING
 1007:20 ED FD       12           JSR   COUT          ;
 100A:E8             13           INX                 ;
 100B:D0 F5   1002   14           BNE   L1            ; LOOP UNTIL NULL TERMINATOR HIT
 100D:               15 *
 100D:20 6F FD       16 CONT      JSR   GETLN1        ; ACCEPT COMMAND FROM KB
 1010:20 03 BE       17           JSR   DOSCMD        ; AND EXECUTE COMMAND
 1013:2C 10 C0       18           BIT   $C010         ; CLEAR STROBE
 1016:B0 02   101A   19           BCS   ERROR         ; BRANCH IF ERROR DETECTED
 1018:90 E6   1000   20           BCC   START         ; OTHERWISE RESTART
 101A:               21 *
 101A:               22 *
 101A:               23 * NOTE: AFTER HANDLING YOUR ERROR YOU MUST CLEAR THE CARRY
 101A:               24 *       BEFORE RETURNING TO BASIC OR BASIC WILL DO
 101A:               25 *       STRANGE TO YOU.
 101A:               26 *
 101A:20 0C BE       27 ERROR     JSR   PRERR         ; PRINT 'ERR'
 101D:18             28           CLC                 ;
 101E:60             29           RTS                 ; RETURN TO BASIC
 101F:               30 *
 101F:               31           MSB   ON
 101F:               32 *
 101F:8D             33 PROMPT    DB    $8D           ; OUTPUT A RETURN FIRST
 1020:C5 CE D4 C5    34           ASC   'ENTER        BASIC.SYSTEM COMMAND --&#62; '
 103F:00             35           DB    0
</PRE><a name="page133"></a>

<P><B><TT>DOSCMD</TT></B> is merely a way to perform some BASIC.SYSTEM commands<br />
from assembly language, and is not a substitute for performing the<br />
commands in BASIC.  Keep in mind the consequences of the command<br />
you are executing.  For example, when doing a BRUN or BLOAD, make<br />
sure the code is loaded at proper addresses.</P><P>After you call <B><TT>DOSCMD</TT></B>, the carry bit will be set if an error has<br />
occurred.  The accumulator will have the error number.</P><P>There are three ways to handle <B><TT>DOSCMD</TT></B> errors:</P><UL>

<LI>Do a <B><TT>JSR ERROUT</TT></B> ($BE09).  This returns control to your<br />
<B><TT>BASIC ONERR</TT></B> routine, where you can handle the error.

<LI>Do a <B><TT>JSR PRINTERR</TT></B> ($BE0C).  This prints Out the error and<br />
returns control to the point just after the <B><TT>JSR</TT></B>.

<LI>Handle the error yourself.  Be sure to clear the carry (CLC) before<br />
returning control to BASIC.SYSTEM.  If you don't, an error will be<br />
assumed, and the results are unpredictable.

</UL>

<A NAME="A.3.2"><H3>A.3.2 - Adding Commands to the BASIC System Program</H3></A>The <B><TT>EXTRNCMD</TT></B> location in the global page allows you to add your<br />
own commands to the ProDOS command set.  Once you attach a<br />
command, it is treated as if it were one of the BASIC.SYSTEM<br />
commands, except that the original commands have preference.  To<br />
execute your command in immediate mode, just enter it.  To execute it<br />
in deferred mode, preface it with <B><TT>PRINT CHR$(4)</TT></B>.</P><P>Whenever BASIC.SYSTEM receives a command, it first checks its<br />
command list for a match.  If the command is not recognized,<br />
BASIC.SYSTEM sends the command to the external command handlers,<br />
if any are connected.  If no external command handler claims the<br />
command, BASIC.SYSTEM passes control to Applesoft, which returns<br />
an error if the command is not recognized.</P><P>If you have frequent need for special commands, you can write your<br />
own command handler and attach it to BASIC.SYSTEM through the<br />
EXTRNCMD jump vector.  First, save the current EXTRNCMD vector (to<br />
JMP to if the command is not yours), and install the address of your<br />
routine in EXTRNCMD+1 and +2 (low byte first).  Your routine must<br />
do three things:</P><a name="page134"></a>

<UL>

<LI>It must check for the presence of your command(s) by inspecting the<br />
GETLN input buffer.  If the command is not yours, you must set the<br />
carry (SEC) and JMP to the initial EXTRNCMD vector you saved to<br />
continue the search.

<LI>If the command is yours, you must zero XCNUM ($BE53) to indicate<br />
an external command, and set XLEN ($BE52) equal to the length of<br />
your command string minus one.

<P>If there are no associated parameters (such as slot, drive, A$, and so<br />
on) to parse, or if you're going to parse them yourself, you must set<br />
all 16 parameter bits in PBITS ($BE54,$BE55) to zero.  And, if you're<br />
going to handle everything yourself before returning control to<br />
BASIC.SYSTEM, you must point XTRNADDR ($BE50,$BE51) at an<br />
RTS instruction.  XRETURN ($BE9E) is a good location.  Now, just<br />
fall through to your execution routines.</P><P>If there are parameters to parse, it is easiest to let BASIC.SYSTEM<br />
parse them for you (unless you want to use some undefined<br />
parameters).  By setting up the bits in PBITS ($BE54,$BE55), and<br />
setting XTRNADDR ($BE50,$BE51) equal to the location where<br />
execution of your command begins, you can return control to<br />
BASIC.SYSTEM, with an RTS, and let it parse and verify the<br />
parameters and return them to you in the global page.</P><LI>It must execute the instructions expected of the command, and it<br />
should RTS with the carry cleared.

</UL>

<P><B>Note:</B> Having BASIC.SYSTEM parse your external command parameters<br />
was initially intended only for its own use.  As it happens, not all<br />
parameters can be parsed separately.  The low byte of PBITS ($BE54)<br />
must have a nonzero value to have BASIC.SYSTEM parse parameters.<br />
This means that regardless of the parameters you need parsed, you<br />
must also elect to parse some parameter specified by the low byte of<br />
PBITS.  For example, set PBITS to $10, filename optional (this<br />
parameter need not be known by the user).</P><P>The following are two sample routines, BEEP and BEEPSLOT.  They<br />
can reside together as external commands.  BEEP handles everything<br />
itself, while BEEPSLOT lets you pass a slot and drive parameter<br />
(,S#,D#) where the drive is ignored.</P><a name="page135"></a>

<A NAME="A.3.2.1"><H4>A.3.2.1 - BEEP Example</H4></A><PRE>
 **************************************************************
 *                                                            *
 *  BRUN BEEP.0 TO INSTALL THE ROUTINE'S ADDRESS IN EXTRNCMD. *
 *  THEN TYPE BEEP AS AN IMMEDIATE COMMAND OR USE PRINT       *
 *  CHR$(4);"BEEP" IN A PROGRAM.                              *
 *                                                            *
 **************************************************************
 *
 *
            ORG  $300
 INBUF      EQU  $200     ;GETLN input buffer.
 WAIT       EQU  $FCA8    ;Monitor wait routine.
 BELL       EQU  $FF3A    ;Monitor bell routine.
 EXTRNCMD   EQU  $BE06    ;External cmd JMP vector.
 XTRNADDR   EQU  $BE50    ;Ext cmd implementation addr.
 XLEN       EQU  $BE52    ;length of command string-1.
 XCNUM      EQU  $BE53    ;CI cmd no. (ext cmd - 0).
 PBITS      EQU  $BE54    ;Command parameter bits.
 XRETURN    EQU  $BE9E    ;Known RTS instruction.
            MSB  ON       ;Set high bit on ASCII
 *
 * FIRST SAVE THE EXTERNAL COMMAND ADDRESS SO YOU WON'T
 * DISCONNECT ANY PREVIOUSLY CONNECTED COMMAND.
 *
            LDA  EXTRNCMD+1
            STA  NXTCMD
            LDA  EXTRNCMD+2
            STA  NXTCMD+1
 *
            LDA  #&#62;BEEP      ;Install the address of our
            STA  EXTRNCMD+1  ; command handler in the
            LDA  #&#60;BEEP      ; external command JMP
            STA  EXTRNCMD+2  ; vector.
            RTS
 *
 BEEP       LDX  #0          ;Check for our command.
 NXTCHR     LDA  INBUF,X     ;Get first character.
            CMP  CMD,X       ;Does it match?
            BNE  NOTOURS     ;No, back to CI.
            INX              ;Next character
            CPX  #CMDLEN     ;All characters yet?
            BNE  NXTCHR      ;No, read next one.
 *
            LDA  #CMDLEN-1   ;Our cmd! Put cmd length-1
            STA  XLEN        ; in CI global XLEN.
            LDA  #&#62;XRETURN   ;Point XTRNADDR to a known
            STA  XTRNADDR    ; RTS since we'll handle
            LDA  #&#60;XRETURN   ; at the time we intercept
</PRE><a name="page136"></a>

<PRE>
            STA  XTRNADDR+1  ; our command.
            LDA  #0          ;Mark the cmd number as
            STA  XCNUM       ; zero (external).
            STA  PBITS       ;And indicate no parameters
            STA  PBITS+1     ; to be parsed.
 *
            LDX  #5          ;Number of desired beeps.
 NXTBEEP    JSR  BELL        ;Else, beep once.
            LDA  #$80        ;Set up the delay
            JSR  WAIT        ; and wait.
            DEX              ;Decrement index and
            BNE  NXTBEEP     ; repeat until X = 0.
 *
            CLC              ;All done successfully.
            RTS              ; RETURN WITH THE CARRY CLEAR.
 *
 NOTOURS    SEC              ; ALWAYS SET CARRY IF NOT YOUR
            JMP  (NXTCMD)    ; CMD AND LET NEXT COMMAND TRY
 *                           ; TO CLAIM IT.
 CMD        ASC  "BEEP"      ;Our command
 CMDLEN     EQU  *-CMD       ;Our command length
 *
 NXTCMD     DW   0           ; STORE THE NEXT EXT CMD'S
                             ; ADDRESS HERE.
</PRE><a name="page137"></a>

<A NAME="A.3.2.2"><H4>A.3.2.2 - BEEPSLOT Example</H4></A><PRE>
 *************************************************************
 *                                                           *
 * BRUN BEEPSLOT.0 TO INSTALL THE ROUTINE'S ADDRESS IN       *
 * EXTRNCMD.  THEN ENTER BEEPSLOT,S(n),D(n).  ONLY A LEGAL   *
 * SLOT AND DRIVE NUMBERS ARE ACCEPTABLE.  IF NO SLOT NUMBER *
 * IT WILL USE THE DEFAULT SLOT NUMBER.  ANY DRIVE NUMBER IS *
 * SIMPLY IGNORED.  THE COMMAND MAY ALSO BE USED IN A        *
 * PROGRAM PRINT CHR$(4) STATEMENT.                          *
 *                                                           *
 *************************************************************
 *
 *
            ORG  $2000
 INBUF      EQU  $200       ;GETLN input buffer.
 WAIT       EQU  $FCA8      ;Monitor wait routine.
 BELL       EQU  $FF3A      ;Monitor bell routine
 EXTRNCMD   EQU  $BE06      ;External cmd JMP vector.
 XTRNADDR   EQU  $BE50      ;Ext cmd implementation addr.
 XLEN       EQU  $BE52      ;Length of command string-1.
 XCNUM      EQU  $BE53      ;CI cmd no. (ext cmd = 0).
 PBITS      EQU  $BE54      ;Command parameter bits.
 VSLOT      EQU  $BE61      ;Verified slot parameter.
            MSB  ON         ;Set high bit on ASCII.
 *
 * REMEMBER TO SAVE THE PREVIOUS COMMAND ADDRESS.
 *
            LDA  EXTRNCMD+1
            STA  NXTCMD
            LDA  EXTRNCMD+2
            STA  NXTCMD+1
 *
            LDA  #&#62;BEEPSLOT ;Install the address of our
            STA  EXTRNCMD+1 ; command handler in the
            LDA  #&#60BEEPSLOT ; external command JMP
            STA  EXTRNCMD+2 ; vector.
            RTS
 *
 BEEPSLOT   LDX  #0         ;Check for our command.
 NXTCHR     LDA  INBUF,X    ;Get first character.
            CMP  CMD,X      ;Does it match?
            BNE  NOTOURS    ;NO, SO CONTINUE WITH NEXT CMD.
            INX             ;Next character
            CPX  #CMDLEN    ;All characters yet?
            BNE  NXTCHR     ;No, read next one.
 *
            LDA  #CMDLEN-1  ;Our cmd! Put cmd length-1
            STA  XLEN       ; in CI global XLEN.
            LDA  #&#62;EXECUTE  ;Point XTRNADDR to our
</PRE><a name="page138"></a>

<PRE>
            STA  XTRNADDR   ; command execution
            LDA  #&#60;EXECUTE  ; routine
            STA  XTRNADDR+1
            LDA  #0         ;Mark the cmd number as
            STA  XCNUM      ; zero (external).
 *
            LDA  #%00010000 ;Set at least one bit
            STA  PBITS      ; in PBITS low byte!
 *
            LDA  #%00000100 ;And mark PBITS high byte
            STA  PBITS+1    ; that slot & drive are legal.
            CLC             ;Everything is OK.
            RTS             ;Return to BASIC.SYSTEM
 *
 EXECUTE    LDA  VSLOT      ;Get slot parameter.
            TAX             ;Transfer to index reg.
 NXTBEEP    JSR  BELL       ;Else, beep once.
            LDA  #$80       ;Set up the delay
            JSR  WAIT       ; and wait.
            DEX             ;decrement index and
            BNE  NXTBEEP    ; repeat until x = 0.
            CLC             ;All done successfully.
            RTS             ;Back to BASIC.SYSTEM.
 *
 * IT'S NOT OUR COMMAND SO MAKE SURE YOU LET BASIC
 * CHECK WHETER OR NOT IT'S THE NEXT COMMAND.
 *
 NOTOURS    SEC             ;SET CARRY AND LET
            JMP  (NXTCMD)   ; NEXT EXT CMD GO FOR IT.
 *
 CMD        ASC  "BEEPSLOT" ;Our command
 CMDLEN     EQU  *-CMD      ;Our command length
 NXTCMD     DW   0          ; STORE THE NEXT COMMAND'S
                            ; ADDRESS HERE.
</PRE><a name="page139"></a>

<A NAME="A.3.3"><H3>A.3.3 - Command String Parsing</H3></A><P>First, the external command must tell the BASIC system program<br />
which parameters are allowed for the command.  It does this by<br />
assigning the appropriate values to the two <B><TT>PBITS</TT></B> bytes, which have<br />
the following meanings:</P><PRE>
 Address:              $BE54                      $BE55
             _______________________    _______________________
            |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
 PBITS:     |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
            |__|__|__|__|__|__|__|__|  |__|__|__|__|__|__|__|__|
 Bit #:      15 14 13 12 11 10  9  8     7  6  5  4  3  2  1  0
</PRE><P><B>Bit # - Meaning</B></P><P>15 - Prefix needs fetching.  Pathname is optional<br />
14 - No parameters to be processed<br />
13 - Command only valid during program execution<br />
12 - Filename is optional<br />
11 - Create allowed if file doesn't exist<br />
10 - File type (Ttype) optional<br />
 9 - A second filename expected<br />
 8 - A first filename expected<br />
 7 - Address (A#) allowed<br />
 6 - Byte (B#) allowed<br />
 5 - End address (E#) allowed<br />
 4 - Length (L#) allowed<br />
 3 - Line number (@#) allowed<br />
 2 - Slot and Drive (S# and D#) allowed<br />
 1 - Field (F#) allowed<br />
 0 - Record (R#) allowed</P><P>Having done this, the routine should place the length of the recognized<br />
command word minus one into <B><TT>XLEN</TT></B> ($BE52).  It should also place<br />
a $00 into <B><TT>XCNUM</TT></B> ($BE53), indicating that an external command was<br />
found, and it should place the address within the routine at which<br />
further processing of the parsed command will take place into<br />
<B><TT>XTRNADDR</TT></B> ($BE50).  Then it should RTS back to the BASIC system<br />
program.</P><a name="page140"></a>

<P>The BASIC system program will see that the command was recognized,<br />
and it will parse the string according to <B><TT>PBITS</TT></B>.  For each parameter<br />
that was used in the command, it will set the corresponding bit in<br />
<B><TT>FBITS</TT></B> ($BE56) and update the value of that parameter in the global<br />
page.  Finally, it will do a JSR to the location indicated in<br />
<B><TT>XTRNADDR</TT></B> ($BE50).</P><P>The routine can now process the command.  All parameters are stored<br />
in the global page except the filenames which are stored in the<br />
locations indicated by <B><TT>VPATH1</TT></B> and <B><TT>VPATH2</TT></B>.</P><P>The HELP command is such a routine.  When you type <B><TT>-HELP</TT></B>, the<br />
help command is loaded into memory at $2000, it moves HIMEM down<br />
and places itself above HIMEM, then it marks itself in the bit map.<br />
Finally it places the start address of the routine in the <B><TT>EXTRNCMD</TT></B><br />
vector.  The BASIC system program now <I>recognizes</I> a series of HELP<br />
commands as well as the NOHELP command.</P><P>The NOHELP command removes the help routine's address from the<br />
<B><TT>EXTRNCMD</TT></B> vector, unmarks the routine from the bit map, and<br />
moves HIMEM back up.</P><a name="page141"></a>

<A NAME="A.4"><H2>A.4 - Zero Page</H2></A><P>Figure A-3 is a memory map that shows the locations used by the<br />
Monitor, Applesoft, the Device Drivers, and the ProDOS MLI.  The<br />
owner of each location is shown by a letter: M, A, D, or P.</P><A NAME="A-3"><P><B>Figure A-3.  Zero Page Memory Map</B></P></A><P><I>Use by the Monitor (M), Applesoft (A), Disk Drivers (D),<br />
and ProDOS MLI (P) is shown.</I></P><PRE>
 Decimal---0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
 ,   Hex---$0  $1  $2  $3  $4  $5  $6  $7  $8  $9  $A  $B  $C  $D  $E  $F
 0   $00  DA  DA   A   A   A   A                   A   A   A   A   A   A
 16  $10   A   A   A   A   A   A   A   A   A                           A
 32  $20   M   M   M   M   M   M   M   M   M   M   M   M   M   M   M   M
 48  $30   M   M   M   M   M   M   M   M   M   M  PMD PMD PMD PMD PMD DM
 64  $40  PMD PMD PMD PMD PMD PMD PMD PM  PM  PM   P   P   P   P  PM   M
 80  $50  MA  MA  MA  MA  MA  MA   A   A   A   A   A   A   A   A   A   A
 96  $60   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A
 112 $70   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A
 128 $80   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A
 144 $90   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A
 160 $A0   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A
 176 $B0   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A   A
 192 $C0   A   A   A   A   A   A   A   A   A   A   A   A   A   A
 208 $D0   A   A   A   A   A   A           A   A   A   A   A   A   A   A
 224 $E0   A   A   A       A   A   A   A   A   A   A
 240 $F0   A   A   A   A   A   A   A   A   A   A
</PRE><P>If you need many zero-page locations for your routines, choose a region<br />
of already-used locations, save them at the beginning of the routine,<br />
and then restore them at the end.</P><a name="page142"></a>

<A NAME="A.5"><H2>A.5 - The Extended 80-Column Text Card</H2></A><P>The Apple IIe computer can optionally contain an Extended 80-Column<br />
Text Card, giving the computer access to an additional 64K of RAM.<br />
(The Apple IIc has the equivalent of such a card built in.)  ProDOS<br />
uses this extra RAM as a volume, just like a small disk volume.  This<br />
volume is initially given the name /RAM, but it can be renamed.</P><P>The 64K of RAM on the card is logically partitioned into 127 512-byte<br />
blocks of information.  The contents of these blocks are:</P><P>Blocks 00-01 - Unavailable<br />
Block 02 - Volume directory<br />
Block 03 - Volume bit map<br />
Blocks 04-07 - Unavailable<br />
Blocks 08-126 - Directories and files</P><P>A detailed description of the way these blocks are used on a disk<br />
volume is in Appendix B.  The major differences between a disk volume<br />
and /RAM are:</P><UL>

<LI> On a disk volume, blocks 0 and 1 are used for the loader program.<br />
Since /RAM is not a bootable volume, these blocks are not used.

<LI>On a disk volume, there are usually four blocks reserved for the<br />
volume directory, with a maximum capacity of 51 files in the<br />
volume directory.  On /RAM, there is only one block of volume<br />
directory: it can hold 12 files (any or all of them can be<br />
subdirectory files).

<LI>Normal disk devices are associated with a given slot and drive.<br />
/RAM is placed in the device list as slot 3, drive 2.

</UL>

<P>This arrangement gives you a total of 119 blocks of file storage.</P><a name="page143"></a>

<a name="page144"></a>
