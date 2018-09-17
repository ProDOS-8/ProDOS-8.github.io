---
layout:      page
title:       TechRef - Preface
description: ProDOS 8 Technical Reference Manual Preface
permalink:   /docs/techref/preface/
---


<A NAME="P"></A>


<P>The <I>ProDOS Technical Reference Manual</I> is the last of three manuals that describe ProDOS(TM), the most powerful disk operating system available for the Apple II.</P>

<UL>
<LI>The <I>ProDOS User's Manual</I> tells how to copy, rename, and remove ProDOS files using the ProDOS Filer program, and how to move files from DOS disks to ProDOS disks using the DOS-ProDOS Conversion program.</li>

<LI><I>BASIC Programming With ProDOS</I> describes ProDOS to a user of the BASIC system program.  It explains how to store information on ProDOS disks and to retrieve information from ProDOS disks using Applesoft BASIC.</li>

<LI>This manual, the <I>ProDOS Technical Reference Manual</I>, explains how to use the machine-language routines upon which the Filer program, the DOS-ProDOS Conversion program, and the BASIC system program are based.  Appendix A reveals a more technical side of the BASIC system program.</li>

</UL>

<A NAME="P1"></A>

<H2>About ProDOS</H2>

<P>The set of machine-language routines described in this manual provides a consistent and interruptible interface to any of the disk devices manufactured by Apple Computer, Inc.  for the Apple II.  They are designed to be used in programs written in the 6502 machine language.</P>


<a name="pagexv"></a>

<P>This manual</P>

<UL>

<LI>describes the files that these routines create and access</li>

<LI>tells how each of the routines is used</li>

<LI>explains how to combine the routines into an application program</li>

<LI>tells how to write and install routines to be used when an interrupt is detected</li>

<LI>tells how to write a routine that automatically reads the date from a clock/calendar card when a file is created or modified</li>

<LI>explains how to attach other devices to ProDOS.</li>

</UL>

<P>Some advantages of programs written using these ProDOS machine-language routines are:</P>

<UL>

<LI>They store information on disks using a hierarchical directory structure.</li>

<LI>They are able to access all disk devices manufactured by Apple Computer, Inc. for the Apple II.</li>

<LI>They can read data from a Disk II drive at a rate of approximately eight kilobytes per second (compared to one kilobyte per second for DOS).</li>

<LI>They are interruptible.</li>

<LI>They have the same disk and directory format as Apple III SOS disks.</li>

<LI>Calls to ProDOS are very similar to calls to SOS; programs can be readily developed for both the Apple II and the Apple III. Appendix C explains the similarities and differences between ProDOS and SOS.</li>

</UL>

<A NAME="P2"></A>

<H2>About This Manual</H2>

<P><B>Apple II</B> In this manual the name <I>Apple II</I> implies the Apple II Plus, the Apple IIe, and the Apple IIc, as well as the Apple II, unless it specifically states otherwise.</P>

<P>This manual is written to serve as a learning tool and a reference tool. It assumes that you have had some experience with the 6502 assembly language, and that you are familiar with the Apple II's internal structure.</P>

<a name="pagexvi"></a>

<P>If you have read <I>BASIC Programming With ProDOS</I> and you want to find out more about how the BASIC system program works, refer first to Appendix A.  If you still want more details, Chapters 1 through 3 tell what ProDOS is and how it works.  If you plan to write machine-language programs that use ProDOS, you will also need to read Chapters 4 and 5.  Chapter 6 shows techniques for adding various devices to the ProDOS system.</P>

<P>This manual does not explain 6502 assembly language.  If you plan to read beyond Chapter 3, you should be familiar with the 6502 assembly language and with the ProDOS Editor/Assembler.</P>

<A NAME="P3"></A>

<H2>What These Mean</H2>

<P><B>By the Way:</B> Text set off in this manner presents sidelights or interesting points of information.</P>

<P><B>Important!</B> Text set off in this manner -- and with a tag in the margin -- presents important information.</P>

<P><B>Warning</B> Warnings like this indicate potential problems or disasters.</P>

<A NAME="P4"></A>

<H2>About the Apple IIc</H2>

<P>Although the Apple IIc has no slots for peripheral cards, it is configured as if it were an Apple IIe with</P>

<UL>

<LI>128 Kbytes of RAM</li>

<LI>serial I/O cards in slots 1 and 2</li>

<LI>an 80-column text card in slot 3</li>

<LI>a mouse (or joystick) card in slot 4</li>

<LI>a disk controller (for two disk drives) in slot 6.</li>

</UL>


<a name="pagexvii"></a>

<a name="pagexviii"></a>
