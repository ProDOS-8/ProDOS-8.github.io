---
layout:      page
title:       TechRef - Appendix - ProDOS, the Apple III, and SOS
description: ProDOS 8 Technical Reference Manual ProDOS, the Apple III, and SOS
permalink:   /docs/techref/prodos-the-appleiii-and-sos/
---


<A NAME="C"><H1>Appendix C<br />ProDOS, the Apple III, and SOS</H1></A><a name="page175"></a>

<P>This appendix explains the relationships between ProDOS, the<br />
Apple III, and SOS.  It should be helpful to those already familiar with<br />
SOS and to those thinking about developing assembly-language<br />
programs concurrently for SOS and ProDOS.</P><A NAME="C.1"><H2>C.1 - ProDOS, the Apple III, and SOS</H2></A><P>As explained earlier in the manual, blocks 0 and 1 of a<br />
<B>ProDOS-formatted</B> disk contain the boot code -- the code that reads the<br />
operating system from the disk and runs it.  Not explained was that<br />
this boot code runs on either an Apple II or an Apple III.</P><P>When you start up either an Apple II or an Apple III system with a<br />
ProDOS disk, the boot code is loaded at $800, and executed.  The first<br />
thing it does is look to see whether it is running on an Apple II or<br />
Apple III.  If it is running on an Apple II, it tries to load in the file<br />
PRODOS.  If it is running on an Apple III, it tries to load in the file<br />
SOS.KERNEL.  In either case, if the proper file is not found, it displays<br />
the appropriate error message.</P><P>This means that two versions of an application could be written, one<br />
for the Apple II, the other for the Apple III, and packaged together on<br />
the same disk.  This single disk could be sold to both Apple II and<br />
Apple III owners.</P><A NAME="C.2"><H2>C.2 - File Compatibility</H2></A><P>SOS and ProDOS use the same directory structure: no exceptions.<br />
Every file on a ProDOS disk can be read by a SOS program and vice<br />
versa.</P><P>The file types that are used by both systems are directory files, text<br />
files, and binary files.  These three types are adequate for the sharing<br />
of data between SOS and ProDOS versions of the same program.</P><P>File types that are intended for one system, but encountered on the<br />
other (as when you CATALOG a ProDOS disk using Business BASIC)<br />
are not inherently different from recognized file types; they just might<br />
cause a number to be displayed as their type instead of a name.  The<br />
ProDOS BASIC system program, Filer, Conversion program, and<br />
Editor/Assembler all recognize and display names for all currently<br />
defined SOS file types.  The abbreviations displayed when Apple III file<br />
types are encountered using ProDOS are shown in the quick reference<br />
section of this manual.</P><a name="page176"></a>

<A NAME="C.3"><H2>C.3 - Operating System Compatibility</H2></A><P>Because of the larger amount of memory available to SOS, it is a much<br />
more complete operating system than is ProDOS.  SOS has a complete<br />
and well defined file manager, device manager, memory manager, and<br />
interrupt and event handler.  ProDOS has a file manager and simplified<br />
interrupt and memory calls.</P><A NAME="C.3.1"><H3>C.3.1 - Comparison of Input/Output</H3></A><P>SOS communicates with all devices -- the console, printers, disk drives,<br />
and so on -- by making open, read, write, and close calls to the<br />
appropriate device; writing to one device is essentially the same as<br />
writing to another.  ProDOS can perform these operations on files only.<br />
Apple II peripherals generally have their driver code in ROM on the<br />
peripheral card.  There is no consistent method for communicating with<br />
them.  Thus the protocol for using any particular device must be known<br />
by the system program that is currently running.</P><A NAME="C.3.2"><H3>C.3.2 - Comparison of Filing Calls</H3></A><P>The set of calls to the ProDOS operating system is essentially a subset<br />
of the calls to SOS.  All filing calls shared by the two systems have the<br />
same call number and nearly identical sets of parameters.  Some<br />
differences are:</P><UL>

<LI>With ProDOS you don't specify the file size when you create a file.<br />
Files are automatically extended when necessary.

<LI>With SOS the GET_FILE_INFO call returns the size of the file in<br />
bytes (the EOF).  In ProDOS you must OPEN the file and then use<br />
the GET_EOF call.

</UL>

<a name="page177"></a>

<UL>

<LI>The SOS VOLUME command corresponds to the ProDOS ON_LINE<br />
command.  When given a device name, VOLUME returns the volume<br />
name for that device.  When given a unit number (derived from the<br />
slot and drive), ON_LINE returns the volume name.

<LI>For SOS, SET_MARK and SET_EOF can use a displacement from<br />
the current position.  ProDOS uses only an absolute position in the<br />
file.

</UL>

<A NAME="C.3.3"><H3>C.3.3 - Memory Handling Techniques</H3></A><P>SOS has a fairly sophisticated memory manager: a system program<br />
requests memory from SOS, either by location or by amount needed.  If<br />
the request can be satisfied, SOS grants it.  That portion of memory is<br />
then the sole responsibility of the requestor until it is released.</P><P>A ProDOS system program is responsible for its own memory<br />
management.  It must find free memory, and then allocate it by<br />
marking it off in a memory bit map.  If a page of memory is marked in<br />
the bit map, ProDOS will not write data into that page.  ProDOS can<br />
thus prevent users from destroying protected areas of memory<br />
(presumably all data is brought into memory using the ProDOS READ<br />
call).</P><A NAME="C.3.4"><H3>C.3.4 - Comparison of Interrupts</H3><P>In SOS, any device capable of generating an interrupt must have a<br />
device driver capable of handling the interrupt; the device driver and<br />
the interrupt handler are inseparable.  ProDOS does not have device<br />
drivers; thus, interrupt handling routines are installed separately using<br />
the ALLOC_INTERRUPT call.  Also, whereas SOS has a distinct<br />
interrupt priority for each device in the system, ProDOS must poll the<br />
routines one by one until someone claims the interrupt.</P><a name="page178"></a>
