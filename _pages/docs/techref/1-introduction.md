---
layout:      page
title:       TechRef - Introduction
description: ProDOS 8 Technical Reference Manual Introduction
permalink:   /docs/techref/introduction/
---


<A NAME="1"></A>

<a name="page1"></a>

<P>This chapter contains an overview of ProDOS and of the material explained in the rest of this manual.  It presents a conceptual picture of the organization and capabilities of ProDOS.  It also tells you where in the manual each aspect of ProDOS is explained.</P>

<A NAME="1.1"></A>

<H2>1.1 - What Is ProDOS?</H2>

<P>ProDOS is an operating system that allows you to manage many of the resources available to an Apple II.  It functions primarily as a disk operating system, but it also handles interrupts and provides a simple means for memory management.  ProDOS marks files with the current date and time, taken from a clock/calendar card if you have one.</P>

<P>All ProDOS startup disks have two files in common: PRODOS and XXX.SYSTEM (Chapter 2 explains the possible values for XXX).  The file PRODOS contains the ProDOS operating system; it performs most of the communication between a <B>system program</B> and the computer's hardware.  The file XXX.SYSTEM contains a system program, the program that usually communicates between the user and the operating system.  Figure 1-1 shows a simplified block diagram of the ProDOS system.</P>

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

<P>A ProDOS system program -- such as the BASIC system program (file BASIC.SYSTEM on the <I>ProDOS BASIC Programming Examples</I> disk), the ProDOS Filer (file FILER on the <I>ProDOS User's Disk</I>), or the DOS-ProDOS Conversion program (file CONVERT on the <I>ProDOS User's Disk</I>) -- is an assembly-language program that accepts commands from a user, makes sure they are valid, and then takes the appropriate action.  One course of action is to make a call to the Machine Language Interface (MLI), the portion of the operating system that receives, validates, and issues operating system commands.</P>

<P>Calls to the MLI give you control over various aspects of the hardware. MLI calls can be divided into housekeeping calls, filing calls, memory calls, and interrupt handling calls.  The way that the MLI communicates with disk drives, memory, and interrupt driven devices is described in the following sections.</P>

<P>Calls to the MLI: see Chapter 4.</P>

<BLOCKQUOTE>

<P><B>About System Programs:</B> If you have dealt with system programs before, you may be a bit confused about the term as used in this manual.  True system programs are neither application programs (such as a word processor) nor operating systems: they provide an easy means of making operating system calls from application programs.</P>

<P>As used in this manual, <I>system program</I> refers to a program that is written in assembly language, makes calls to the Machine Language Interface, and adheres to a set of conventions, making it relatively easy to switch from one system program to another.  System programs can be identified by their file type.</P>

<P>In short, it is the structure of a program, not its function, that makes a program a ProDOS system program.</P>

<P>The rules for organizing system programs are given in Chapter 5.</P>

</BLOCKQUOTE>

<A NAME="1.1.1"></A>

<H3>1.1.1 - Use of Disk Drives</H3>

<P>Although ProDOS is able to communicate with several different types of disk drives, the type of disk drive and the slot location of the drive need not be known by the system program: the MLI takes care of such details.  Instead disks -- or, more accurately, volumes of information -- are identified by their volume names.</P>

<a name="page3"></a>

<P>The information on a volume is divided into files.  A <B>file</B> is an ordered collection of bytes, having a name, a type, and several other properties. One important type of file is the <B>directory file</B>: a directory file contains the names and location on the volume of other files.  When a disk is formatted using the Format a Volume option of the ProDOS Filer program, a main directory file for the volume is automatically placed on the disk. It is called the disk's <B>volume directory</B> file, and it has the same name as the volume itself.  Although it is initially empty, a volume directory file has a maximum capacity of 51 files.</P>

<P>Any file in the volume directory may itself be a directory file (called a <B>subdirectory</B>), and any file within a subdirectory can also be a subdirectory.  Using directory files, you can arrange your files so that they can be most easily accessed and manipulated.  This is especially useful when you are working with large capacity disk drives such as the ProFile.  A sample directory structure is shown in Figure 1-2.</P>

<P>Directory structures are described in Chapter 2.</P>

<A NAME="1-2"></A>

<P><B>Figure 1-2.  A Typical ProDOS Directory Structure</B></P>

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

<P>The filing calls, described in Chapter 4, provide all functions necessary for the access and manipulation of files.</P>

<a name="page4"></a>

<A NAME="1.1.2"></A>

<H3>1.1.2 - Volume and File Characteristics</H3>

<P>Programs that make filing calls to the ProDOS Machine Language Interface can take advantage of the following features:</P>

<UL>

<LI>Access to all ProDOS formatted disks; maximum capacity 32 megabytes on a volume.</li>

<LI>Files can be stored in up to 64 levels of readable directory and subdirectory files.</li>

<LI>A volume directory holds up to 51 entries.</li>

<LI>Subdirectories can hold as many files as needed; they become larger as files are added to them.</li>

<LI>There are over 60 distinct file identification codes; some are predefined, others can be defined by the system program.  For compatibility, existing file types should be used.</li>

<LI>Up to eight files can be open for access simultaneously.</li>

<LI>A file can hold up to 16 megabytes of data.</li>

<LI>Disks can be accessed by block number as well as by file.</li>

<LI>If the data in a file is not sequential, the logical size of the file can be bigger than the amount of disk space used.</li>

</UL>

<P>The use of files is described in Chapter 2; their format is given in Appendix B.</P>

<A NAME="1.1.3"></A>

<H3>1.1.3 - Use of Memory</H3>

<P>ProDOS treats memory as a sequence of 256-byte <B>pages</B>.  It represents the status of each page, used or unused, as a single bit in a portion of memory called the <B>system bit map</B>.</P>

<P>When ProDOS initializes itself, it marks all the pages in memory it needs to protect.  Once running, it sets the corresponding bit in the bit map for each new page it uses; when it releases the page, it clears the bit.</P>

<P>If your program allows the user to read information into specific areas of memory, you can use the bit map to prevent ProDOS from overwriting the program.</P>

<P>The arrangement of ProDOS in memory is described in Chapter 3.</P>

<a name="page5"></a>

<A NAME="1.1.4"></A>

<H3>1.1.4 - Use of Interrupt Driven Devices</H3>

<P>Certain devices generate interrupts, signals that tell the controlling computer (in this case an Apple II), that the device needs attention.</P>

<P>ProDOS is able to handle up to four interrupting devices at a time.  To add an interrupt driven device to your system:</P>

<OL>

<LI>Place an interrupt handling routine into memory.</li>

<LI>Mark the block of memory as used.</li>

<LI>Use the MLI call that adds interrupt routines to the system.</li>

<LI>Enable the device.</li>

</OL>

<P>This causes the routine to be called each time an interrupt occurs.  If you install more than one routine, the routines will be called in the order in which they were installed.</P>

<P>To remove an interrupt handling routine:</P>

<OL>

<LI>Disable the device.</li>

<LI>Unmark its block in memory</li>

<LI>Use the MLI call that removes interrupt routines from the system.</li>

</OL>

<P><B>Warning:</B> Failure to follow these procedures in sequence may cause system error.</P>

<P>The use of interrupt driven devices is described in Chapter 6.</P>

<A NAME="1.1.5"></A>

<H3>1.1.5 - Use of Other Devices</H3>

<P>Other than disks, ProDOS communicates only with clock/calendar cards.  If your system has a clock/calendar card that follows ProDOS protocols (see Chapter 6), ProDOS automatically sets up a routine so that it can read from the clock before marking files with the time.  If you have some other type of clock, you must write your own routine, place it in memory, and tell ProDOS where the routine is located.</P>

<a name="page6"></a>

<A NAME="1.2"></A>

<H2>1.2 - Summary</H2>

<P>Figure 1-3 illustrates the entire mechanism used by ProDOS and shows the interaction between the levels of ProDOS.  A complete ProDOS system consists of the Machine Language Interface, a system program, and some external routines.  If you wish your system to operate with interrupt driven devices, a clock/calendar card, or other external devices, you must supply routines that communicate with these devices.</P>

<P>The system program takes commands from the user and issues them to the Command Dispatcher portion of the Machine Language Interface or to independently controlled devices.  The Command Dispatcher validates each command before passing it to the Block File Manager (which also manages memory) or to the Interrupt Receiver/Dispatcher.  The Block File Manager calls a disk driver routine and the clock/calendar routine if necessary; the Interrupt Receiver/Dispatcher calls the interrupt handling routines.</P>

<a name="page7"></a>

<A NAME="1-3"></A>

<P><B>Figure 1-3.  The Levels of ProDOS</B></P>

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

<P>The following chapters describe the implementation of this mechanism. After reading through Chapter 5, you will be ready to start writing your own system programs.  After reading through Chapter 6, you will be able to write your own external routines.</P>

<a name="page8"></a>

