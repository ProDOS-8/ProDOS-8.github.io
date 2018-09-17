---
layout:      page
title:       TechRef - Appendix - ProDOS, the Apple III, and SOS
description: ProDOS 8 Technical Reference Manual ProDOS, the Apple III, and SOS
permalink:   /docs/techref/prodos-the-appleiii-and-sos/
---


<A NAME="C"></A>

<a name="page175"></a>

<P>This appendix explains the relationships between ProDOS, the Apple III, and SOS.  It should be helpful to those already familiar with SOS and to those thinking about developing assembly-language programs concurrently for SOS and ProDOS.</P>

<A NAME="C.1"></A>

<H2>C.1 - ProDOS, the Apple III, and SOS</H2>

<P>As explained earlier in the manual, blocks 0 and 1 of a <B>ProDOS-formatted</B> disk contain the boot code -- the code that reads the operating system from the disk and runs it.  Not explained was that this boot code runs on either an Apple II or an Apple III.</P>

<P>When you start up either an Apple II or an Apple III system with a ProDOS disk, the boot code is loaded at $800, and executed.  The first thing it does is look to see whether it is running on an Apple II or Apple III.  If it is running on an Apple II, it tries to load in the file PRODOS.  If it is running on an Apple III, it tries to load in the file SOS.KERNEL.  In either case, if the proper file is not found, it displays the appropriate error message.</P>

<P>This means that two versions of an application could be written, one for the Apple II, the other for the Apple III, and packaged together on the same disk.  This single disk could be sold to both Apple II and Apple III owners.</P>

<A NAME="C.2"></A>

<H2>C.2 - File Compatibility</H2>


<P>SOS and ProDOS use the same directory structure: no exceptions. Every file on a ProDOS disk can be read by a SOS program and vice versa.</P>

<P>The file types that are used by both systems are directory files, text files, and binary files.  These three types are adequate for the sharing of data between SOS and ProDOS versions of the same program.</P>


<P>File types that are intended for one system, but encountered on the other (as when you CATALOG a ProDOS disk using Business BASIC) are not inherently different from recognized file types; they just might cause a number to be displayed as their type instead of a name.  The ProDOS BASIC system program, Filer, Conversion program, and Editor/Assembler all recognize and display names for all currently defined SOS file types.  The abbreviations displayed when Apple III file types are encountered using ProDOS are shown in the quick reference section of this manual.</P>

<A name="page176"></a>

<A NAME="C.3"></A>

<H2>C.3 - Operating System Compatibility</H2>


<P>Because of the larger amount of memory available to SOS, it is a much more complete operating system than is ProDOS.  SOS has a complete and well defined file manager, device manager, memory manager, and interrupt and event handler.  ProDOS has a file manager and simplified interrupt and memory calls.</P>

<A NAME="C.3.1"></A>

<H3>C.3.1 - Comparison of Input/Output</H3>


<P>SOS communicates with all devices -- the console, printers, disk drives, and so on -- by making open, read, write, and close calls to the appropriate device; writing to one device is essentially the same as writing to another.  ProDOS can perform these operations on files only. Apple II peripherals generally have their driver code in ROM on the peripheral card.  There is no consistent method for communicating with them.  Thus the protocol for using any particular device must be known by the system program that is currently running.</P>

<A NAME="C.3.2"></A>

<H3>C.3.2 - Comparison of Filing Calls</H3>


<P>The set of calls to the ProDOS operating system is essentially a subset of the calls to SOS.  All filing calls shared by the two systems have the same call number and nearly identical sets of parameters.  Some differences are:</P>

<UL>

<LI>With ProDOS you don't specify the file size when you create a file. Files are automatically extended when necessary.</li>

<LI>With SOS the GET_FILE_INFO call returns the size of the file in bytes (the EOF).  In ProDOS you must OPEN the file and then use the GET_EOF call.</li>

</UL>

<a name="page177"></a>

<UL>

<LI>The SOS VOLUME command corresponds to the ProDOS ON_LINE command.  When given a device name, VOLUME returns the volume name for that device.  When given a unit number (derived from the slot and drive), ON_LINE returns the volume name.</li>

<LI>For SOS, SET_MARK and SET_EOF can use a displacement from the current position.  ProDOS uses only an absolute position in the file.</li>

</UL>

<A NAME="C.3.3"></A>

<H3>C.3.3 - Memory Handling Techniques</H3>

<P>SOS has a fairly sophisticated memory manager: a system program requests memory from SOS, either by location or by amount needed.  If the request can be satisfied, SOS grants it.  That portion of memory is then the sole responsibility of the requestor until it is released.</P>

<P>A ProDOS system program is responsible for its own memory management.  It must find free memory, and then allocate it by marking it off in a memory bit map.  If a page of memory is marked in the bit map, ProDOS will not write data into that page.  ProDOS can thus prevent users from destroying protected areas of memory (presumably all data is brought into memory using the ProDOS READ call).</P>

<A NAME="C.3.4"></a>

<H3>C.3.4 - Comparison of Interrupts</H3>

<P>In SOS, any device capable of generating an interrupt must have a device driver capable of handling the interrupt; the device driver and the interrupt handler are inseparable.  ProDOS does not have device drivers; thus, interrupt handling routines are installed separately using the ALLOC_INTERRUPT call.  Also, whereas SOS has a distinct interrupt priority for each device in the system, ProDOS must poll the routines one by one until someone claims the interrupt.</P>

<A name="page178"></a>



