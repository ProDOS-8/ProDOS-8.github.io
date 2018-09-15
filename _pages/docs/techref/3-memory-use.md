---
layout:      page
title:       TechRef - Memory Use
description: ProDOS 8 Technical Reference Manual Memory Use
permalink:   /docs/techref/memory-use/
---

<A NAME="3"><H1>Chapter 3<br />Memory Use</H1></A>

<a name="page21"></a>

<P>This chapter explains the way the Machine Language Interface uses<br />
memory.  It tells how much memory system programs have available to<br />
them, how system programs should manage this free memory, and it<br />
discusses the contents of important areas of memory while ProDOS is<br />
inn use.</P>

<A NAME="3.1"><H2>3.1 - Loading Sequence</H2></A>

<P>When you start up your Apple II from a ProDOS startup disk -- one<br />
that contains both the MLI (ProDOS) and a system program<br />
(XXX.SYSTEM) -- a complex loading sequence is initiated.</P>

<P>A preliminary loading program is stored in the read-only memory (<B>boot<br />
ROM</B>) on a disk drive's controller card; the main part of the <B>loader<br />
program</B>, as it is called, resides in blocks 0 and 1 of every<br />
ProDOS-formatted disk.</P>

<P>When you turn on your computer, or use a <B><TT>PR#</TT></B> or <B><TT>IN#</TT></B> command to<br />
reference a disk drive from Applesoft, or otherwise transfer control to<br />
the ROM on the disk-drive controller card when a ProDOS startup disk<br />
is in the drive, this is what happens:</P>

<OL>

<LI>The program in the ROM reads the loader program from blocks 0<br />
and 1 of the disk, places it into memory starting at location $800,<br />
and then executes it.

<LI>This loader program looks for the file with the name PRODOS and<br />
type $FF (containing the MLI) in the volume directory of the<br />
startup disk, loads it into memory starting at location $2000, and<br />
executes it.

<LI>The MLI ascertains the computer's memory size and moves itself to<br />
its final location, as shown in Figure 3-1.  Next it determines what<br />
devices are in what slots and it sets up the <B>system global page</B>,<br />
described in the section "The System Global Page," for this system<br />
configuration.

<LI>The MLI then searches the volume directory of the boot disk for<br />
the first file with the name XXX.SYSTEM and type $FF, loads it<br />
into memory starting at $2000, and executes it.

</OL>

<P>If PRODOS cannot be found, the loader reports to the user that it is<br />
unable to load ProDOS.  If no XXX.SYSTEM program is found, ProDOS<br />
displays the message <B><TT>UNABLE TO FIND A SYSTEM FILE</TT></B>.</P>

<P>The rules for system programs are<br />
described in Chapter 5.</P>

<a name="page22"></a>

<P>The MLI is entirely memory resident.  Once it is in memory, it neither<br />
moves, nor does it require any additional disk accesses (although the<br />
system program might).  The memory configuration that results from<br />
this loading process is described in the section "Memory Map."</P>

<A NAME="3.2"><H2>3.2 - Volume Search Order</H2></A>

<P>When a program or user requests access to a volume that ProDOS has<br />
not yet accessed, it must search through the volumes that are<br />
currently online for the requested volume.  The order in which it<br />
searches the devices is determined during step 3 above.</P>

<P>The first volume checked is /RAM, if present, then the startup volume<br />
(generally slot 6, drive 1).  The search then checks slots in descending<br />
slot order, starting with slot 7.  In any slot, drive 1 is searched before<br />
drive 2.</P>

<P>For example, if there are two Disk II drives in slot 6, two Disk II<br />
drives in slot 5, and a ProFile in slot 7, the search order is:</P>

<P>/RAM<br />
Slot 6, drive 1<br />
Slot 6, drive 2<br />
Slot 7<br />
Slot 5, drive 1<br />
Slot 5, drive 2</P>

<P>The startup volume is the volume in the highest numbered slot that<br />
can be identified by the system as a startup volume.  This sequence is<br />
kept in the device list in the ProDOS global page and can be altered.</P>

<P><B>Note:</B> If the startup volume is a hard disk, the search order is from<br />
slot 7 to slot 1.</P>

<A NAME="3.3"><H2>3.3 - Memory Map</H2></A>

<P>ProDOS requires at least 64 kilobytes of memory.  Figure 3-1 is the<br />
ProDOS memory map.</P>

<a name="page23"></a>

<A NAME="3-1"><P><B>Figure 3-1.  Memory Map</B></P></A>

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

<a name="page24"></a>

<P>A system program as large as $8F00 (36608) bytes can be loaded into a<br />
64K system.  The total amount of space available to a system program<br />
running on a 64K system is $B700 (46848) bytes.</P>

<A NAME="3.3.1"><H3>3.3.1 - Zero Page</H3></A>

<P>The ProDOS Machine Language Interface uses zero-page locations<br />
$40-$4E, but it restores them before it completes a call.  The disk-driver<br />
routines, called by the MLI, use locations $3A through $3F.  These<br />
locations are not restored.  See Chapter 4 for details.</P>

<A NAME="3.3.2"><H3>3.3.2 - The System Global Page</H3></A>

<P>The $BF-page of memory, addresses $BF00 through $BFFF, contains<br />
the system's global variables.  This section of memory is special because<br />
no matter what system ProDOS is booted on, the global page is always<br />
in the same location.  Because of this it serves as the communication<br />
link between system programs and the operating system.  The MLI<br />
places all information that might be useful to a system program in<br />
these locations.  These locations are defined and described in Chapter 5.</P>

<A NAME="3.3.3"><H3>3.3.3 - The System Bit Map</H3></A>

<P>ProDOS uses a simple form of memory management that allows it to<br />
protect itself and the user's data from being overwritten by ProDOS<br />
buffer allocation.  It represents the lower 48K of the Apple II's<br />
random-access memory using twenty-four bytes of the system global<br />
page: one bit for each 256-byte page of RAM in the lower 48K of the<br />
Apple II.  These twenty-four bytes are called the <B>system bit map</B>.</P>

<P>When ProDOS is started up, it protects the zero page, the stack, and<br />
the global page, by setting the bits that correspond to the used pages.<br />
If at all possible, a system program should not use pages of memory<br />
that are already used.  If this is not possible, the system program must<br />
close all files and clear the bit map, leaving pages 0, 1, 4 through 7,<br />
and BF (zero page, stack, text, and ProDOS global page) protected.  If<br />
an error occurs on the close, the program should ask the user to<br />
restart the system.  See Chapter 5 for details.</P>

<a name="page25"></a>

<P>While a system program is using the MLI, there are only three calls<br />
that affect the setting of the bit map: OPEN, CLOSE, and SET_BUF.<br />
When the system program opens a file, it must specify the starting<br />
address of a 1024-byte file buffer.  As long as the file is open, this<br />
buffer is a part of the system, and is marked off in the bit map.  When<br />
the file is closed, the buffer is released, and its bits are cleared.</P>

<P>In general, a system program requires the used pages of memory to be<br />
contiguous, or touching.  This leaves the maximum possible unbroken<br />
memory space for the reading and manipulation of data.  Suppose a<br />
system program opens several files and then closes the one that was<br />
opened first.  In most cases, this causes a vacant 1K area to appear.<br />
The GET_BUF and SET_BUF calls can be used to find this vacant<br />
area, and to move another file's buffer into this space.</P>

<P>Refer to Chapter 5 for a specific example<br />
of using the system bit map.</P>

<a name="page26"></a>
