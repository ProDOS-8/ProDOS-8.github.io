---
layout:      page
title:       TechRef - Preface
description: ProDOS 8 Technical Reference Manual Preface
permalink:   /docs/techref/preface/
---


<A NAME="P"><H1>Preface</H1></A>

<P>The <I>ProDOS Technical Reference Manual</I> is the last of three<br />
manuals that describe ProDOS(TM), the most powerful disk operating<br />
system available for the Apple II.</P>

<UL>
<LI>The <I>ProDOS User's Manual</I> tells how to copy, rename, and remove<br />
ProDOS files using the ProDOS Filer program, and how to move files<br />
from DOS disks to ProDOS disks using the DOS-ProDOS Conversion<br />
program.

<LI><I>BASIC Programming With ProDOS</I> describes ProDOS to a user of<br />
the BASIC system program.  It explains how to store information on<br />
ProDOS disks and to retrieve information from ProDOS disks using<br />
Applesoft BASIC.

<LI>This manual, the <I>ProDOS Technical Reference Manual</I>, explains<br />
how to use the machine-language routines upon which the Filer<br />
program, the DOS-ProDOS Conversion program, and the BASIC<br />
system program are based.  Appendix A reveals a more technical side<br />
of the BASIC system program.
</UL>

<A NAME="P1"><H2>About ProDOS</H2></A>

<P>The set of machine-language routines described in this manual provides<br />
a consistent and interruptible interface to any of the disk devices<br />
manufactured by Apple Computer, Inc.  for the Apple II.  They are<br />
designed to be used in programs written in the 6502 machine language.<br />

<a name="pagexv"></a>

<P>This manual</P>

<UL>

<LI>describes the files that these routines create and access

<LI>tells how each of the routines is used

<LI>explains how to combine the routines into an application program

<LI>tells how to write and install routines to be used when an interrupt<br />
is detected

<LI>tells how to write a routine that automatically reads the date from a<br />
clock/calendar card when a file is created or modified

<LI>explains how to attach other devices to ProDOS.

</UL>

<P>Some advantages of programs written using these ProDOS<br />
machine-language routines are:</P>

<UL>

<LI>They store information on disks using a hierarchical directory<br />
structure.

<LI>They are able to access all disk devices manufactured by Apple<br />
Computer, Inc. for the Apple II.

<LI>They can read data from a Disk II drive at a rate of approximately<br />
eight kilobytes per second (compared to one kilobyte per second for<br />
DOS).

<LI>They are interruptible.

<LI>They have the same disk and directory format as Apple III SOS<br />
disks.

<LI>Calls to ProDOS are very similar to calls to SOS; programs can be<br />
readily developed for both the Apple II and the Apple III.<br />
Appendix C explains the similarities and differences between ProDOS<br />
and SOS.

</UL>

<A NAME="P2"><H2>About This Manual</H2></A>

<P><B>Apple II</B><br />
In this manual the name <I>Apple II</I> implies the Apple II Plus, the<br />
Apple IIe, and the Apple IIc, as well as the Apple II, unless it<br />
specifically states otherwise.</P>

<P>This manual is written to serve as a learning tool and a reference tool.<br />
It assumes that you have had some experience with the 6502 assembly<br />
language, and that you are familiar with the Apple II's internal<br />
structure.</P>

<a name="pagexvi"></a>

<P>If you have read <I>BASIC Programming With ProDOS</I> and you want to<br />
find out more about how the BASIC system program works, refer first<br />
to Appendix A.  If you still want more details, Chapters 1 through 3 tell<br />
what ProDOS is and how it works.  If you plan to write<br />
machine-language programs that use ProDOS, you will also need to<br />
read Chapters 4 and 5.  Chapter 6 shows techniques for adding various<br />
devices to the ProDOS system.</P>

<P>This manual does not explain 6502 assembly language.  If you plan to<br />
read beyond Chapter 3, you should be familiar with the 6502 assembly<br />
language and with the ProDOS Editor/Assembler.</P>

<A NAME="P3"><H2>What These Mean</H2></A>

<P><B>By the Way:</B> Text set off in this manner presents sidelights or<br />
interesting points of information.</P>

<P><B>Important!</B><br />
Text set off in this manner -- and with a tag in the margin -- presents<br />
important information.</P>

<P><B>Warning</B><br />
Warnings like this indicate potential problems or disasters.</P>

<A NAME="P4"><H2>About the Apple IIc</H2></A>

<P>Although the Apple IIc has no slots for peripheral cards, it is<br />
configured as if it were an Apple IIe with</P>

<UL>

<LI>128 Kbytes of RAM

<LI>serial I/O cards in slots 1 and 2

<LI>an 80-column text card in slot 3

<LI>a mouse (or joystick) card in slot 4

<LI>a disk controller (for two disk drives) in slot 6.

</UL>