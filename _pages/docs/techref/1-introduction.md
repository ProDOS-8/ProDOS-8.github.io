---
layout:      page
title:       TechRef - Introduction
description: ProDOS 8 Technical Reference Manual Introduction
permalink:   /docs/techref/introduction/
---




<a name="pagexvii"></a>

<a name="pagexviii"></a>

<A NAME="1"><H1>Chapter 1<br />Introduction</H1></A>

<a name="page1"></a>

<P>This chapter contains an overview of ProDOS and of the material<br />
explained in the rest of this manual.  It presents a conceptual picture of<br />
the organization and capabilities of ProDOS.  It also tells you where in<br />
the manual each aspect of ProDOS is explained.</P>

<A NAME="1.1"><H2>1.1 - What Is ProDOS?</H2></A>

<P>ProDOS is an operating system that allows you to manage many of the<br />
resources available to an Apple II.  It functions primarily as a disk<br />
operating system, but it also handles interrupts and provides a simple<br />
means for memory management.  ProDOS marks files with the current<br />
date and time, taken from a clock/calendar card if you have one.</P>

<P>All ProDOS startup disks have two files in common: PRODOS and<br />
XXX.SYSTEM (Chapter 2 explains the possible values for XXX).  The<br />
file PRODOS contains the ProDOS operating system; it performs most of<br />
the communication between a <B>system program</B> and the computer's<br />
hardware.  The file XXX.SYSTEM contains a system program, the<br />
program that usually communicates between the user and the operating<br />
system.  Figure 1-1 shows a simplified block diagram of the ProDOS<br />
system.</P>

<A NAME="1-1"></A>

<PRE>
       ------
      ( User )
       ------
          ^
          |
          v
 +------------------+  From File
 |  System Program  |  xxx.SYSTEM
 +------------------+
          ^
          |
          v
 +------------------+  From File
 | Operating System |  PRODOS
 +------------------+
          ^
          |
          v
 +------------------+  Disk Drives,
 |     Hardware     |  Memory,
 +------------------+  and Slots
</PRE>

<a name="page2"></a>

<P>A ProDOS system program -- such as the BASIC system program (file<br />
BASIC.SYSTEM on the <I>ProDOS BASIC Programming Examples</I><br />
disk), the ProDOS Filer (file FILER on the <I>ProDOS User's Disk</I>), or<br />
the DOS-ProDOS Conversion program (file CONVERT on the <I>ProDOS<br />
User's Disk</I>) -- is an assembly-language program that accepts commands<br />
from a user, makes sure they are valid, and then takes the appropriate<br />
action.  One course of action is to make a call to the Machine Language<br />
Interface (MLI), the portion of the operating system that receives,<br />
validates, and issues operating system commands.</P>

<P>Calls to the MLI give you control over various aspects of the hardware.<br />
MLI calls can be divided into housekeeping calls, filing calls, memory<br />
calls, and interrupt handling calls.  The way that the MLI<br />
communicates with disk drives, memory, and interrupt driven devices<br />
is described in the following sections.</P>

<P>Calls to the MLI: see Chapter 4.</P>

<BLOCKQUOTE>

<P><B>About System Programs:</B> If you have dealt with system programs<br />
before, you may be a bit confused about the term as used in this<br />
manual.  True system programs are neither application programs (such<br />
as a word processor) nor operating systems: they provide an easy<br />
means of making operating system calls from application programs.</P>

<P>As used in this manual, <I>system program</I> refers to a program that is<br />
written in assembly language, makes calls to the Machine Language<br />
Interface, and adheres to a set of conventions, making it relatively easy<br />
to switch from one system program to another.  System programs can<br />
be identified by their file type.</P>

<P>In short, it is the structure of a program, not its function, that makes a<br />
program a ProDOS system program.</P>

<P>The rules for organizing system programs are given in Chapter 5.</P>

</BLOCKQUOTE>

<A NAME="1.1.1"><H3>1.1.1 - Use of Disk Drives</H3></A>

<P>Although ProDOS is able to communicate with several different types<br />
of disk drives, the type of disk drive and the slot location of the drive<br />
need not be known by the system program: the MLI takes care of such<br />
details.  Instead disks -- or, more accurately, volumes of information -- are<br />
identified by their volume names.</P>

<P>The information on a volume is divided into files.  A <B>file</B> is an ordered<br />
collection of bytes, having a name, a type, and several other properties.<br />
One important type of file is the <B>directory file</B>: a directory file<br />
contains the names and location on the volume of other files.  When a<br />
disk is formatted using the Format a Volume option of the ProDOS<br />
Filer program, a main directory file for the volume is automatically<br />

<a name="page3"></a>

placed on the disk.  It is called the disk's <B>volume directory</B> file, and it<br />
has the same name as the volume itself.  Although it is initially empty,<br />
a volume directory file has a maximum capacity of 51 files.</P>

<P>Any file in the volume directory may itself be a directory file (called a<br />
<B>subdirectory</B>), and any file within a subdirectory can also be a<br />
subdirectory.  Using directory files, you can arrange your files so that<br />
they can be most easily accessed and manipulated.  This is especially<br />
useful when you are working with large capacity disk drives such as<br />
the ProFile.  A sample directory structure is shown in Figure 1-2.</P>

<P>Directory structures are described in Chapter 2.</P>

<A NAME="1-2"><P><B>Figure 1-2.  A Typical ProDOS Directory Structure</B></P></A>

<PRE>
                                                     +---------------+
                            +-----------------+  +--&#62;| VIDEOBALL     |
                      +----&#62;| PROGRAMS/       |  |   +---------------+
                      |     |-----------------|  |
                      |     | VIDEOBALL       |--+   +---------------+
                      |     | DISKWARS        |-----&#62;| DISKWARS      |
                      |     |                 |      +---------------+
                      |     +-----------------+
 +-----------------+  |
 | /PROFILE/       |  |
 |-----------------|  |                              +---------------+
 | PROGRAMS/       |--+     +-----------------+  +--&#62;| MOM           |
 | LETTERS/        |-------&#62;| LETTERS/        |  |   +---------------+
 | SYSTEMPROGRAMS/ |----+   |-----------------|  |
 | JUNK/           |--+ |   | MOM             |--+   +---------------+
 +-----------------+  | |   | DAD             |-----&#62;| DAD           |
                      | |   | SPOT            |--+   +---------------+
                      | |   +-----------------+  |
                      | |                        |   +---------------+
                      | |                        +--&#62;| SPOT          |
                      | |                            +---------------+
                      | |
                      | |
                      | |                            +---------------+
                      | |   +-----------------+  +--&#62;| BASIC.SYSTEM  |
                      | +--&#62;| SYSTEMPROGRAMS/ |  |   +---------------+
                      |     |-----------------|  |
                      |     | BASIC.SYSTEM    |--+   +---------------+
                      |     | FILER           |-----&#62;| FILER         |
                      |     | CONVERT         |--+   +---------------+
                      |     +-----------------+  |
                      |                          |   +---------------+
                      |                          +--&#62;| CONVERT       |
                      |                              +---------------+
                      |
                      |     +-----------------+
                      +----&#62;| JUNK            |
                            +-----------------+
</PRE>

<P>The filing calls, described in Chapter 4, provide all functions necessary<br />
for the access and manipulation of files.</P>

<a name="page4"></a>

<A NAME="1.1.2"><H3>1.1.2 - Volume and File Characteristics</H3></A>

<P>Programs that make filing calls to the ProDOS Machine Language<br />
Interface can take advantage of the following features:</P>

<UL>

<LI>Access to all ProDOS formatted disks; maximum capacity<br />
32 megabytes on a volume.

<LI>Files can be stored in up to 64 levels of readable directory and<br />
subdirectory files.

<LI>A volume directory holds up to 51 entries.

<LI>Subdirectories can hold as many files as needed; they become larger<br />
as files are added to them.

<LI>There are over 60 distinct file identification codes; some are<br />
predefined, others can be defined by the system program.  For<br />
compatibility, existing file types should be used.

<LI>Up to eight files can be open for access simultaneously.

<LI>A file can hold up to 16 megabytes of data.

<LI>Disks can be accessed by block number as well as by file.

<LI>If the data in a file is not sequential, the logical size of the file can<br />
be bigger than the amount of disk space used.

</UL>

<P>The use of files is described in<br />
Chapter 2; their format is given in<br />
Appendix B.</P>

<A NAME="1.1.3"><H3>1.1.3 - Use of Memory</H3></A>

<P>ProDOS treats memory as a sequence of 256-byte <B>pages</B>.  It represents<br />
the status of each page, used or unused, as a single bit in a portion of<br />
memory called the <B>system bit map</B>.</P>

<P>When ProDOS initializes itself, it marks all the pages in memory it<br />
needs to protect.  Once running, it sets the corresponding bit in the bit<br />
map for each new page it uses; when it releases the page, it clears the<br />
bit.</P>

<P>If your program allows the user to read information into specific areas<br />
of memory, you can use the bit map to prevent ProDOS from<br />
overwriting the program.</P>

<P>The arrangement of ProDOS in memory<br />
is described in Chapter 3.</P>

<a name="page5"></a>

<A NAME="1.1.4"><H3>1.1.4 - Use of Interrupt Driven Devices</H3></A>

<P>Certain devices generate interrupts, signals that tell the controlling<br />
computer (in this case an Apple II), that the device needs attention.</P>

<P>ProDOS is able to handle up to four interrupting devices at a time.  To<br />
add an interrupt driven device to your system:</P>

<OL>

<LI>Place an interrupt handling routine into memory.

<LI>Mark the block of memory as used.

<LI>Use the MLI call that adds interrupt routines to the system.

<LI>Enable the device.

</OL>

<P>This causes the routine to be called each time an interrupt occurs.  If<br />
you install more than one routine, the routines will be called in the<br />
order in which they were installed.</P>

<P>To remove an interrupt handling routine:</P>

<OL>

<LI>Disable the device.

<LI>Unmark its block in memory

<LI>Use the MLI call that removes interrupt routines from the system.

</OL>

<P><B>Warning:</B><br />
Failure to follow these procedures in sequence may cause system<br />
error.</P>

<P>The use of interrupt driven devices is<br />
described in Chapter 6.</P>

<A NAME="1.1.5"><H3>1.1.5 - Use of Other Devices</H3></A>

<P>Other than disks, ProDOS communicates only with clock/calendar<br />
cards.  If your system has a clock/calendar card that follows ProDOS<br />
protocols (see Chapter 6), ProDOS automatically sets up a routine so<br />
that it can read from the clock before marking files with the time.  If<br />
you have some other type of clock, you must write your own routine,<br />
place it in memory, and tell ProDOS where the routine is located.</P>

<a name="page6"></a>

<A NAME="1.2"><H2>1.2 - Summary</H2></A>

<P>Figure 1-3 illustrates the entire mechanism used by ProDOS and shows<br />
the interaction between the levels of ProDOS.  A complete ProDOS<br />
system consists of the Machine Language Interface, a system program,<br />
and some external routines.  If you wish your system to operate with<br />
interrupt driven devices, a clock/calendar card, or other external<br />
devices, you must supply routines that communicate with these<br />
devices.</P>

<P>The system program takes commands from the user and issues them to<br />
the Command Dispatcher portion of the Machine Language Interface or<br />
to independently controlled devices.  The Command Dispatcher validates<br />
each command before passing it to the Block File Manager (which also<br />
manages memory) or to the Interrupt Receiver/Dispatcher.  The Block<br />
File Manager calls a disk driver routine and the clock/calendar routine<br />
if necessary; the Interrupt Receiver/Dispatcher calls the interrupt<br />
handling routines.</P>

<a name="page7"></a>

<A NAME="1-3"><P><B>Figure 1-3.  The Levels of ProDOS</B></P></A>

<PRE>
                                            ------
 USER                                      ( User )                                        IMA.USER
                                            ------
                                               ^
 - - - - - - - - - - - - - - - - - - - - - - - | - - - - - - - - - - - - - - - - - - - - - - - - -
                                               v
                                       +----------------+
 USER INTERFACE                        | System Program |                                xxx.SYSTEM
                                       +----------------+
                                               ^      ^
                                               |       \
                                               v        \
                                         +------------+  \
 - - - - - - - - - - - - - - - - - - - - | Command    | - \ - - - - - - - - - - - - - - - - - - - -
                                         | Dispatcher |    \
                                         +------------+     \
                                            ^       ^        +-------------------+
                                            |       |                            |
                          +-----------------+       |                            |
                          |                         |                            |
                          v                         v                            |
                    +------------+                +---------------------+        |           PRODOS
                    | Block File |                | Interrupt           |        |
 OPERATING          | Manager    |                | Receiver/Dispatcher |        |
 SYSTEM             +------------+                +---------------------+        |
                      ^        ^                         ^                       |
                      |        |                +- - - - | - - - - - - - - - - - | - - - - - - - -
                      v        v                |        v                       v
           +-------------+  +----------------+  |  +------------+   +-----------------+
           | Disk Driver |  | Clock/Calendar |  |  | Interrupt  |   | Other Device    |   User
           | Routines    |  | Routine        |  |  | Routine(s) |   | Driver Routines |   Installed
           +-------------+  +----------------+  |  +------------+   +-----------------+
                ^                  ^            |        ^                   ^
 - - - - - - - -|- - - - - - - - - | - - - - - -+- - - - | - - - - - - - - - | - - - - - - - - - -
                v                  v                     v                   v
           +---------+      +----------------+     +----------------+  +---------------+
 HARDWARE  | Disk II |      | Clock/Calendar |     | Interrupt      |  | Other Devices |
           | ProFile |      | Card           |     | Driven Devices |  |               |
           +-----+   |      +--------+       |     +--------+       |  +--------+      |
                 |   |               |       |              |       |           |      |
                 +---+               +-------+              +-------+           +------+
</PRE>

<P>The following chapters describe the implementation of this mechanism.<br />
After reading through Chapter 5, you will be ready to start writing<br />
your own system programs.  After reading through Chapter 6, you will<br />
be able to write your own external routines.</P>

<a name="page8"></a>