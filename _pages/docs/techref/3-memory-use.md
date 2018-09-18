---
layout:      page
title:       TechRef - Memory Use
description: ProDOS 8 Technical Reference Manual Memory Use
permalink:   /docs/techref/memory-use/
---

<A NAME="3"></A>

<a name="page21"></a>

<P>This chapter explains the way the Machine Language Interface uses memory.  It tells how much memory system programs have available to them, how system programs should manage this free memory, and it discusses the contents of important areas of memory while ProDOS is inn use.</P>

<A NAME="3.1"></A>

<H2>3.1 - Loading Sequence</H2>

<P>When you start up your Apple II from a ProDOS startup disk -- one that contains both the MLI (ProDOS) and a system program (XXX.SYSTEM) -- a complex loading sequence is initiated.</P>

<P>A preliminary loading program is stored in the read-only memory (<B>boot ROM</B>) on a disk drive's controller card; the main part of the <B>loader program</B>, as it is called, resides in blocks 0 and 1 of every ProDOS-formatted disk.</P>

<P>When you turn on your computer, or use a <B><TT>PR#</TT></B> or <B><TT>IN#</TT></B> command to reference a disk drive from Applesoft, or otherwise transfer control to the ROM on the disk-drive controller card when a ProDOS startup disk is in the drive, this is what happens:</P>

<OL>

<LI>The program in the ROM reads the loader program from blocks 0 and 1 of the disk, places it into memory starting at location $800, and then executes it.</li>

<LI>This loader program looks for the file with the name PRODOS and type $FF (containing the MLI) in the volume directory of the startup disk, loads it into memory starting at location $2000, and executes it.</li>

<LI>The MLI ascertains the computer's memory size and moves itself to its final location, as shown in Figure 3-1.  Next it determines what devices are in what slots and it sets up the <B>system global page</B>, described in the section "The System Global Page," for this system configuration.</li>

<LI>The MLI then searches the volume directory of the boot disk for the first file with the name XXX.SYSTEM and type $FF, loads it into memory starting at $2000, and executes it.</li>

</OL>

<P>If PRODOS cannot be found, the loader reports to the user that it is unable to load ProDOS.  If no XXX.SYSTEM program is found, ProDOS displays the message <B><TT>UNABLE TO FIND A SYSTEM FILE</TT></B>.</P>

<P>The rules for system programs are described in Chapter 5.</P>

<a name="page22"></a>

<P>The MLI is entirely memory resident.  Once it is in memory, it neither moves, nor does it require any additional disk accesses (although the system program might).  The memory configuration that results from this loading process is described in the section "Memory Map."</P>

<A NAME="3.2"></A>

<H2>3.2 - Volume Search Order</H2>

<P>When a program or user requests access to a volume that ProDOS has not yet accessed, it must search through the volumes that are currently online for the requested volume.  The order in which it searches the devices is determined during step 3 above.</P>

<P>The first volume checked is /RAM, if present, then the startup volume (generally slot 6, drive 1).  The search then checks slots in descending slot order, starting with slot 7.  In any slot, drive 1 is searched before drive 2.</P>

<P>For example, if there are two Disk II drives in slot 6, two Disk II drives in slot 5, and a ProFile in slot 7, the search order is:</P>

<P>/RAM Slot 6, drive 1 Slot 6, drive 2 Slot 7 Slot 5, drive 1 Slot 5, drive 2</P>

<P>The startup volume is the volume in the highest numbered slot that can be identified by the system as a startup volume.  This sequence is kept in the device list in the ProDOS global page and can be altered.</P>

<P><B>Note:</B> If the startup volume is a hard disk, the search order is from slot 7 to slot 1.</P>

<A NAME="3.3"></A>

<H2>3.3 - Memory Map</H2>

<P>ProDOS requires at least 64 kilobytes of memory.  Figure 3-1 is the ProDOS memory map.</P>

<a name="page23"></a>

<A NAME="3-1">></A>

<P><B>Figure 3-1.  Memory Map</B></P>

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

<P>A system program as large as $8F00 (36608) bytes can be loaded into a 64K system.  The total amount of space available to a system program running on a 64K system is $B700 (46848) bytes.</P>

<A NAME="3.3.1"></A>

<H3>3.3.1 - Zero Page</H3>

<P>The ProDOS Machine Language Interface uses zero-page locations $40-$4E, but it restores them before it completes a call.  The disk-driver routines, called by the MLI, use locations $3A through $3F.  These locations are not restored.  See Chapter 4 for details.</P>

<A NAME="3.3.2"></A>

<H3>3.3.2 - The System Global Page</H3>

<P>The $BF-page of memory, addresses $BF00 through $BFFF, contains the system's global variables.  This section of memory is special because no matter what system ProDOS is booted on, the global page is always in the same location.  Because of this it serves as the communication link between system programs and the operating system.  The MLI places all information that might be useful to a system program in these locations.  These locations are defined and described in Chapter 5.</P>

<A NAME="3.3.3"></A>

<H3>3.3.3 - The System Bit Map</H3>

<P>ProDOS uses a simple form of memory management that allows it to protect itself and the user's data from being overwritten by ProDOS buffer allocation.  It represents the lower 48K of the Apple II's random-access memory using twenty-four bytes of the system global page: one bit for each 256-byte page of RAM in the lower 48K of the Apple II.  These twenty-four bytes are called the <B>system bit map</B>.</P>

<P>When ProDOS is started up, it protects the zero page, the stack, and the global page, by setting the bits that correspond to the used pages. If at all possible, a system program should not use pages of memory that are already used.  If this is not possible, the system program must close all files and clear the bit map, leaving pages 0, 1, 4 through 7, and BF (zero page, stack, text, and ProDOS global page) protected.  If an error occurs on the close, the program should ask the user to restart the system.  See Chapter 5 for details.</P>

<a name="page25"></a>

<P>While a system program is using the MLI, there are only three calls that affect the setting of the bit map: OPEN, CLOSE, and SET_BUF. When the system program opens a file, it must specify the starting address of a 1024-byte file buffer.  As long as the file is open, this buffer is a part of the system, and is marked off in the bit map.  When the file is closed, the buffer is released, and its bits are cleared.</P>

<P>In general, a system program requires the used pages of memory to be contiguous, or touching.  This leaves the maximum possible unbroken memory space for the reading and manipulation of data.  Suppose a system program opens several files and then closes the one that was opened first.  In most cases, this causes a vacant 1K area to appear. The GET_BUF and SET_BUF calls can be used to find this vacant area, and to move another file's buffer into this space.</P>

<P>Refer to Chapter 5 for a specific example of using the system bit map.</P>

<a name="page26"></a>
