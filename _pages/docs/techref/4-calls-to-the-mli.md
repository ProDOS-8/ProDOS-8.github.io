---
layout:      page
title:       TechRef - Calls to the Machine Language Interface (MLI)
description: ProDOS 8 Technical Reference Manual Calls to the MLI
permalink:   /docs/techref/calls-to-the-mli/
---

<A NAME="4"></A>

<a name="page27"></a>

<P>This chapter is about the ProDOS Machine Language Interface (MLI), which provides a simple way to use disk files from machine-language programs.  This chapter describes</P>

<UL>

<LI>the organization of the MLI on a functional basis</li>

<LI>how to make calls to the MLI from machine-language programs</li>

<LI>the MLI calls themselves</li>

<LI>the MLI error codes.</li>

</UL>

<A NAME="4.1"></A>

<H2>4.1 - The Machine Language Interface</H2>

<P>The ProDOS MLI is a complete, consistent, and interruptible interface between the machine-language programmer and files on disks.  It is entirely independent of the ProDOS BASIC system program; thus, it serves as a base upon which other system programs can be written.  Its filename is PRODOS.  It consists of:</P>

<UL>

<LI>the <B>Command Dispatcher</B>, which accepts and dispatches calls from a machine-language program.  It validates each call's parameters, updates the system global page, and then jumps to the appropriate routine of the Block File Manager.</li>

<LI>the <B>Block File Manager</B>, which carries out all valid calls to the MLI.  The Block File Manager keeps track of all mounted disks, manages the condition of all opened files, and does some simple memory management.  It performs all disk access (reads and writes) via calls to disk-driver routines.</li>

<LI><B>Disk Driver Routines</B>, which perform the reading and writing of data.</li>

<LI>the <B>Interrupt Handler</B>, which allows up to four interrupt handling routines to be attached to ProDOS.  The Interrupt Handler keeps four vectors to interrupt routines.  When an interrupt occurs, these routines are called, in sequence, until one of them claims the interrupt.</li>

</UL>

<a name="page28"></a>

<A NAME="4.2"></A>

<H2>4.2 - Issuing a Call to the MLI</H2>

<P>A program sends a call to the Machine Language Interface by executing a JSR (jump to subroutine) to address $BF00 (referred to below as MLI).  The call number and a two-byte pointer (low byte first) to the call's parameter list must immediately follow the call.  Here is an example of a call to the MLI:</P>

{% highlight basic %}
SYSCALL  JSR MLI         ;Call Command Dispatcher
         DB  CMDNUM      ;This determines which call is being made
         DW  CMDLIST     ;A two-byte pointer to the parameter list
         BNE ERROR       ;Error if nonzero
{% endhighlight %}

<P>Upon completion of the call, the MLI returns to the address of the JSR plus 3 (in the above example, the BNE statement); the call number and parameter list pointer are skipped.  If the call is successful, the C-flag is cleared and the Accumulator is set to zero.  If the call is unsuccessful, the C-flag is set and the Accumulator is set to the error code.  The register status upon call completion is summarized below. Note that the value of the N-flag is determined by the Accumulator and that the value of the V-flag is undefined.</P>

<PRE>
                    N  Z  C  D  V   Acc    PC    X  Y  SP
Successful call:    0  1  0  0  x    0    JSR+3  unchanged
Unsuccessful call:  x  0  1  0  x  error  JSR+3  unchanged
                                   code
</PRE>

<a name="page29"></a>

<P>Here is an example of a small program that issues calls to the MLI.  It tries to create a text file named NEWFILE on a volume named TESTMLI.  If an error occurs, the Apple II beeps and prints the error code on the screen.  Both the source and the object are given so you can enter it from the Monitor if you wish (remember to use a formatted disk named /TESTMLI).</P>

------------------------------------------------------------------------

{% highlight nasm %}
 SOURCE   FILE #01 =&#62;TESTCMD
 ----- NEXT OBJECT FILE NAME IS TESTCMD.0
 2000:        2000    1         ORG  $2000
 2000:        2000    1         ORG  $2000
 2000:                2 *
 2000:        FF3A    3 BELL    EQU  $FF3A     ;Monitor BELL routine
 2000:        FD8E    4 CROUT   EQU  $FD8E     ;Monitor CROUT routine
 2000:        FDDA    5 PRBYTE  EQU  $FDDA     ;Monitor PRBYTE routine
 2000:        BF00    6 MLI     EQU  $BF00     ;ProDOS system call
 2000:        00C0    7 CRECMD  EQU  $C0       ;CREATE command number
 2000:                8 *
 2000:20 06 20        9 MAIN    JSR  CREATE    ;CREATE "/TESTMLI/NEWFILE"
 2003:D0 08   200D   10         BNE  ERROR     ;If error, display it
 2005:60             11         RTS            ;Otherwise done
 2006:               12 *
 2006:20 00 BF       13 CREATE  JSR  MLI       ;Perform call
 2009:C0             14         DFB  CRECMD    ;CREATE command number
 200A:17 20          15         DW   CRELIST   ;Pointer to parameter list
 200C:60             16         RTS
 200D:               17 *
 200D:20 DA FD       18 ERROR   JSR  PRBYTE    ;Print error code
 2010:20 3A FF       19         JSR  BELL      ;Ring the bell
 2013:20 8E FD       20         JSR  CROUT     ;Print a carriage return
 2016:60             21         RTS
 2017:               22 *
 2017:07             23 CRELIST DFB  7         ;Seven parameters
 2018:23 20          24         DW   FILENAME  ;Pointer to filename
 201A:C3             25         DFB  $C3       ;Normal file access permitted
 201B:04             26         DFB  $04       ;Make it a text file
 201C:00 00          27         DFB  $00,$00   ;AUX_TYPE, not used
 201E:01             28         DFB  $01       ;Standard file
 201F:00 00          29         DFB  $00,$00   ;Creation date (unused)
 2021:00 00          30         DFB  $00,$00   ;Creation time (unused)
 2023:               31 *
 2023:10             32 FILENAME DFB ENDNAME-NAME ;Length of name
 2024:2F 54 45 53    33 NAME    ASC  "/TESTMLI/NEWFILE" ;followed by the name
 2034:        2034   34 ENDNAME EQU  *
{% endhighlight %}

------------------------------------------------------------------------

<P>The parameters used in <B><TT>TESTCMD</TT></B> are explained in the following sections.  The MLI error codes are summarized in Section 4.7.</P>

<a name="page30"></a>

<A NAME="4.2.1"></A>

<H3>4.2.1 - Parameter Lists</H3>

As defined above, each MLI call has a two-byte pointer to a parameter list.  A parameter list contains information to be used by the call and space for information to be returned by the call.  There are three types of elements used in parameter lists: values, results, and pointers.</P>

<P>A <B>value</B> is a one or more byte quantity that is passed to the Block File Manager (BFM).  Values help determine the action taken by the BFM.</P>

<P>A <B>result</B> is a one or more byte space in the parameter list into which the Block File Manager will place a value.  From results, programs can get information about the status of a volume, file, or interrupt, or about the success of the call just completed.</P>

<P>A <B>pointer</B> is a two-byte memory address that indicates the location of data, code, or a space in which the Block File Manager can place or receive data.  All pointers are arranged low byte first, high byte second.</P>

<P>The first element in every parameter list is the <B>parameter count</B>, a one-byte value that indicates the number of parameters used by the call (not including the parameter count).  This byte is used to verify that the call was not accidental.</P>

<A NAME="4.2.2"></A>

<H3>4.2.2 - The ProDOS Machine Language Exerciser</H3>

<P>To help you learn to use the ProDOS Machine Language Interface, there is a useful little program called the ProDOS Machine Language Exerciser.  It allows you to execute MLI calls from a menu; it has a hexadecimal memory editor for reviewing and altering the contents of buffers; and it has a catalog command.</P>

<P>Instructions for using the Machine Language Exerciser program are in Appendix D.</P>

<P>When you use it to make an MLI call, you request the call by its call number, then you specify its parameter list, just as if you were coding the call in a program.  When you press [RETURN], the call is executed. Using the Exerciser, you can try out sequences of MLI calls before actually coding them.</P>

<a name="page31"></a>

<A NAME="4.3"></A>

<H2>4.3 - The MLI Calls</H2>

<P>The MLI calls can be divided into three groups: housekeeping calls, filing calls, and system calls.</P>

<A NAME="4.3.1"></A>

<H3>4.3.1 - Housekeeping Calls</H3>

<P>The housekeeping calls perform operations such as creating, deleting, and renaming, which cannot be used on open files.  They are used to change a file's status, but not the information that is in the file.  They refer to files by their pathnames, and each requires a temporary buffer, which is used during execution of the call.  The housekeeping calls are:</P>

<DL>
  <DT>CREATE</DT>
  <DD>Creates either a standard file or a directory file.  An entry for the file is placed in the proper directory on the disk, and one block of disk space is allocated to the file.</DD>
</DL>

<DL>
  <DT>DESTROY</DT>
  <DD>Removes a standard file or directory file.  The entry for the file is removed from the directory and all the file's disk space is released.  If a directory is to be destroyed, it must be empty.  A volume directory cannot be destroyed except by reformatting the volume.</DD>
</DL>

<DL>
  <DT>RENAME</DT>
  <DD>Changes the name of a file.  The new name must be in the same directory as the old name.  This call changes the name in the entry that describes that file, and if it is a directory file, also the name in its header entry.</DD>
</DL>

<DL>
  <DT>SET_FILE_INFO</DT>
  <DD>Sets the file's type, the way it may be accessed, and/or its modification date and time.</DD>
</DL>

<DL>
  <DT>GET_FILE_INFO</DT>
  <DD>Returns the file's type, the way it may be accessed, the way it is stored on the disk, its size in blocks, and the date and time at which it was created and last modified.</DD>
</DL>

<a name="page32"></a>

<DL>
  <DT>ON_LINE</DT>
  <DD>Returns the slot number, drive number, and volume name of one or all mounted volumes.  This information is placed in a user-supplied buffer.</DD>
</DL>

<DL>
  <DT>SET_PREFIX</DT>
  <DD>Sets the pathname that is used by the operating system as a prefix.  The prefix must indicate an existing directory on a mounted volume.</DD>
</DL>

<DL>
  <DT>GET_PREFIX</DT>
  <DD>Returns the value of the current system prefix.</DD>
</DL>

<A NAME="4.3.2"></A>

<H3>4.3.2 - Filing Calls</H3>

<P>The filing calls cause the transfer of data to or from files.  The first filing call, OPEN, must be used before any of the others can be used. The OPEN call specifies a file by its pathname; the other filing calls refer to files by the reference number returned by the OPEN call.  In addition, an input/output buffer (io_buffer), is allocated to the open file; subsequent data transfers go through this buffer.  The reference number remains assigned and the buffer remains allocated until the file is closed.  The filing calls are:</P>

<DL>
  <DT>OPEN</DT>
  <DD>Prepares a file to be accessed.  This call causes a file control block (FCB) to be allocated to the file, and a reference number to be returned (A reference number is really a file control block number).  In addition, an input/output buffer is allocated for data transfers to and from the file.</DD>
</DL>

<DL>
  <DT>NEWLINE</DT>
  <DD>Sets conditions for reading from the file.  This call turns on and turns off the capability of read requests to terminate when a particular character (such as a carriage return) is read.</DD>
</DL>

<DL>
  <DT>READ</DT>
  <DD>Causes the transfer of a requested number of characters from a file to a specified memory buffer, and updates the current position (MARK) in the file. Characters are read according to the rules set by the NEWLINE call.</DD>
</DL>

<a name="page33"></a>

<DL>
  <DT>WRITE</DT>
  <DD>Causes the transfer of a requested number of characters from a specified buffer to a file, and updates the current position (MARK) in the file and the end of file (EOF), if necessary.</DD>
</DL>

<DL>
  <DT>CLOSE</DT>
  <DD>Transfers any unwritten data from a file's input/output buffer to the file, releases the file's io_buffer and file control block, and updates the file's directory entry, if necessary.  The file's reference number is released for use by subsequently opened files.</DD>
</DL>

<DL>
  <DT>FLUSH</DT>
  <DD>Transfers any unwritten data from a file's input/output buffer to the file, and updates the file's directory entry, if necessary.</DD>
</DL>

<DL>
  <DT>SET_MARK</DT>
  <DD>Changes the current position in the file.  The current position is the absolute position in the file of the next character to be read or written.</DD>
</DL>

<DL>
  <DT>GET_MARK</DT>
  <DD>Returns the current position in the file. The current position is the absolute position in the file of the next character to be read or written.</DD>
</DL>

<DL>
  <DT>SET_EOF</DT>
  <DD>Changes the logical size of the file (the end of file).</DD>
</DL>

<DL>
  <DT>GET_EOF</DT>
  <DD>Returns the logical size of the file.</DD>
</DL>

<DL>
  <DT>SET_BUF</DT>
  <DD>Assigns a new location for the input/output buffer of an open file.</DD>
</DL>

<DL>
  <DT>GET_BUF</DT>
  <DD>Returns the current location of the input/output buffer of an open file.</DD>
</DL>

<a name="page34"></a>

<A NAME="4.3.3"></A>

<H3>4.3.3 - System Calls</H3>

<P>System calls are those calls that are neither housekeeping nor filing calls.  They are used for getting the current date and time, for installing and removing interrupt routines, and for reading and writing specific blocks of a disk.  The system calls are:</P>

<DL>
  <DT>GET_TIME</DT>
  <DD>If your system has a clock/calendar card, and if a routine that can read from the clock is installed, then it places the current date and time in the system date and time locations.</DD>
</DL>

<DL>
  <DT>ALLOC_INTERRUPT</DT>
  <DD>Places a pointer to an interrupt-handling routine into the system interrupt vector table.</DD>
</DL>

<DL>
  <DT>DEALLOC_INTERRUPT</DT>
  <DD>Removes a pointer to an interrupt handling routine from the system interrupt vector table.</DD>
</DL>

<DL>
  <DT>READ_BLOCK</DT>
  <DD>Reads one specific block (512 bytes) of information from a disk into a user specified data buffer.  This call is file independent.</DD>
</DL>

<DL>
  <DT>WRITE_BLOCK</DT>
  <DD>Writes a block of information from a user specified data buffer to a specific block of a disk.  This call is file independent.</DD>
</DL>

<a name="page35"></a>

<A NAME="4.4"></A>

<H2>4.4 - Housekeeping Calls</H2>

<P>Each of the following sections contains a description of a housekeeping call, including its parameters and the possible errors that may be returned.</P>

<A NAME="4.4.1"></A>

<H3>4.4.1 - CREATE ($C0)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 7               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | access         (1-byte value) |
    +---+---+---+---+---+---+---+---+
  4 | file_type      (1-byte value) |
    +---+---+---+---+---+---+---+---+
  5 | aux_type               (low)  |
  6 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  7 | storage_type   (1-byte value) |
    +---+---+---+---+---+---+---+---+
  8 | create_date          (byte 0) |
  9 | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+
  A | create_time          (byte 0) |
  B | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Every disk file except the volume directory file must be created using this call.  There are two organizationally distinct types of file storage: tree structure (storage_type = $1), used for standard files; and linked list (storage_type = $D), used for directory files.</P>

<P>Pathname specifies the name of the file to be created and the directory in which to insert an entry for the new file.  One block (512 bytes) of disk space is allocated, and the entry's key_pointer field is set to indicate that block.  Access, in most cases, should be set to $E3 (full access permitted).  File_type and aux_type may be anything, but it is strongly recommended that conventions be followed (see below).</P>

<a name="page36"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</DT>
  <DD>Parameter count: 7 for this call.</DD>
</DL>

<DL>
  <DT>pathname (2-byte pointer)</DT>
  <DD>Pathname pointer: A two-byte address (low byte first) that points to an ASCII string.  The string consists of a count byte, followed by the pathname (up to 64 characters).  If the pathname begins with a slash ( / ), it is treated as a full pathname.  If not, it is treated as a partial pathname and the prefix is attached to the front to make a full pathname.  The pathname string is not changed.</DD>
</DL>

<DL>
  <DT>access (1-byte value)</DT>
  <DD>Access permitted: This byte defines how the file will be accessible.  Its format is</DD>
  :</P>

<PRE>
   7  6  5  4  3  2  1  0
 +--+--+--+--+--+--+--+--+
 |D |RN|B |Reserved|W |R |
 +--+--+--+--+--+--+--+--+

 D:   Destroy enable bit
 RN:  Rename enable bit
 B:   Backup needed bit
 W:   Write enable bit
 R:   Read enable bit
</PRE>

For all bits, 1 = enabled, 0 = disabled.  Bits 2 through 4 are reserved for future definition and must always be disabled.  Usually access should be set to $C3. 
If the file is destroy, rename, and write enabled, it is <B>unlocked</B>.  If all three are disabled, it is <B>locked</B>.  Any other combination of access bits is called <B>restricted access</B>. 
The backup bit (B) is always set by this call.<br /></DL>

<DL>
  <DT>file_type (1-byte value)</DT>
  <DD>File type: This byte describes the contents of the file.  The currently defined file types are listed below.</DD>
</DL>

<a name="page37"></a>

<PRE>
 <B>File Type       Preferred Use</B>

 $00             Typeless file (SOS and ProDOS)
 $01             Bad block file
 $02 *           Pascal code file
 $03 *           Pascal text file
 $04             ASCII text file (SOS and ProDOS)
 $05 *           Pascal data file
 $06             General binary file (SOS and ProDOS)
 $07 *           Font file
 $08             Graphics screen file
 $09 *           Business BASIC program file
 $0A *           Business BASIC data file
 $0B *           Word Processor file
 $0C *           SOS system file
 $0D,$0E *       SOS reserved
 $0F             Directory file (SOS and ProDOS)
 $10 *           RPS data file
 $11 *           RPS index file
 $12 *           AppleFile discard file
 $13 *           AppleFile model file
 $14 *           AppleFile report format file
 $15 *           Screen library file
 $16-$18 *       SOS reserved
 $19             AppleWorks Data Base file
 $1A             AppleWorks Word Processor file
 $1B             AppleWorks Spreadsheet file
 $1C-$EE         Reserved
 $EF             Pascal area
 $F0             ProDOS added command file
 $F1-$F8         ProDOS user defined files 1-8
 $F9             ProDOS reserved
 $FA             Integer BASIC program file
 $FB             Integer BASIC variable file
 $FC             Applesoft program file
 $FD             Applesoft variables file
 $FE             Relocatable code file (EDASM)
 $FF             ProDOS system file
</PRE>

<P><B>Note:</B> The file types marked with a * in the above list apply to Apple III SOS only; they are not used by ProDOS.  For the file_types used by Apple III SOS only, refer to the <I>SOS Reference Manual</I>.</P>

<a name="page38"></a>

<DL>
  <DT>aux_type (2-byte value)</DT>
  <DD>Auxiliary type: This two-byte field is used by the system program.  The BASIC system program uses it (low byte first) to store text-file record size or binary-file load address, depending on the file_type.</DD>
</DL>

<DL>
  <DT>storage_type (1-byte value)</DT>
  <DD>File kind: This byte describes the physical organization of the file.  storage_type = $0D is a linked directory file; storage_type = $01 is a standard file.</DD>
</DL>

<DL>
  <DT>create_date (2-byte value)</DT>
  <DD>This 2-byte field may contain the date on which the file was created.  Its forma</DD>
  t is:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |    Year     |  Month  |   Day   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<DL>
  <DT>create_time (2-byte value)</DT>
  <DD>This 2-byte field may contain the time at which the file was created.  Its forma</DD>
  t is:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |0 0 0|  Hour   | |0 0|  Minute   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<P>See Chapter 6 for information about the use of ProDOS with a clock/calendar card.</P>

<a name="page39"></a>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $2B - Disk write protected $40 - Invalid pathname syntax $44 - Path not found $45 - Volume directory not found $46 - File not found $47 - Duplicate filename $48 - Overrun error: not enough disk space $49 - Directory full -- ProDOS can have no more than 51 files in a volume directory. $4B - Unsupported storage_type $53 - Invalid parameter $5A - Bit map disk address is impossible</P>

<A NAME="4.4.2"></A>

<H3>4.4.2 - DESTROY ($C1)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Deletes the file specified by pathname by removing its entry from the directory that owns it, and by returning its blocks to the volume bit map.  Volume directory files and open files cannot be destroyed. Subdirectory files must be empty before they can be destroyed.</P>

<a name="page40"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</DT>
  <DD>Parameter count: 1 for this call.</DD>
</DL>

<DL>
  <DT>pathname (2-byte pointer)</DT>
  <DD>Pathname pointer: A two-byte address (low byte first) that points to an ASCII string.  The string consists of a count byte, followed by the pathname (up to 64 characters).  If the pathname begins with a slash ( / ), it is treated as a full pathname.  If not, it is treated as a partial pathname and the prefix is attached to the front to make a full pathname.</DD>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $2B - Disk write protected $40 - Invalid pathname syntax $44 - Path not found $45 - Volume directory not found $46 - File not found $4A - Incompatible file format $4B - Unsupported storage_type $4E - Access error: destroy not enabled $50 - File is open: request denied $5A - Bit map disk address is impossible</P>

<a name="page41"></a>

<A NAME="4.4.3"></A>

<H3>4.4.3 - RENAME ($C2)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | new_pathname           (low)  |
  4 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Changes the name of the file specified by pathname to that specified by new_pathname.  Both pathname and new_pathname must be identical except for the rightmost filename (they must indicate files in the same directory).  For example, the path /EGG/ROLL can be renamed /EGG/PLANT, but not /JELLY/ROLL or /EGG/DRUM/ROLL.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</DT>
  <DD>Parameter count: 2 for this call.</DD>
</DL>

<DL>
  <DT>pathname (2-byte pointer)</DT>
  <DD>Pathname pointer: A two-byte address (low byte first) that points to an ASCII string.  The string consists of a count byte, followed by the pathname (up to 64 characters).  If the pathname begins with a slash ( / ), it is treated as a full pathname.  If not, it is treated as a partial pathname and the prefix is attached to the front to make a full pathname.</DD>
</DL>

<DL>
  <DT>new_pathname (2-byte pointer)</DT>
  <DD>New pathname pointer: This two-byte pointer (low byte first) indicates the location of the new pathname.  It has the same syntax as pathname.</P></DD>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $2B - Disk write protected $40 - Invalid pathname syntax $44 - Path not found $45 - Volume directory not found $46 - File not found</P>

<a name="page42"></a>

<P>$47 - Duplicate filename $4A - Incompatible file format $4B - Unsupported storage_type $4E - Access error: rename not enabled $50 - File is open: request denied $57 - Duplicate volume</P>

<A NAME="4.4.4"></A>

<H3>4.4.4 - SET_FILE_INFO ($C3)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 7               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | access         (1-byte value) |
    +---+---+---+---+---+---+---+---+
  4 | file_type      (1-byte value) |
    +---+---+---+---+---+---+---+---+
  5 | aux_type               (low)  |
  6 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  7 |                               |
  8 | null_field          (3 bytes) |
  9 |                               |
    +---+---+---+---+---+---+---+---+
  A | mod_date             (byte 0) |
  B | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+
  C | mod_time             (byte 0) |
  D | (2-byte value)       (byte 1) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Modifies information in the specified file's entry field.  This call can be performed when the file is either open or closed.  However, new access attributes are not used by an open file until the next time the file is opened (that is, this call doesn't modify existing file control blocks).</P>

<P>You should use the GET_FILE_INFO call to read a file's attributes into a parameter list, modify them as needed, and then use the same parameter list for the SET_FILE_INFO call.</P>

<a name="page43"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</DT>
  <DD>Parameter count: 7 for this call.</DD>
</DL>

<DL>
  <DT>pathname (2-byte pointer)</DT>
  <DD>Pathname pointer: A two-byte address (low byte first) that points to an ASCII string.  The string consists of a count byte, followed by the pathname (up to 64 characters).  If the pathname begins with a slash ( / ), it is treated as a full pathname.  If not, it is treated as a partial pathname and the prefix is attached to the front to make a full pathname.</DD>
</DL>

<DL>
  <DT>access (1-byte value)</DT>
  <DD>Access permitted: This byte determines how the file may be accessed.  Its forma</DD>
  t is:

<PRE>
   7  6  5  4  3  2  1  0
 +--+--+--+--+--+--+--+--+
 |D |RN|B |Reserved|W |R |
 +--+--+--+--+--+--+--+--+

 D:   Destroy enable bit
 RN:  Rename enable bit
 B:   Backup needed bit
 W:   Write enable bit
 R:   Read enable bit
</PRE>

<P>For all bits, 1 = enabled, 0 = disabled.  Bits 2 through 4 are used internally and should be set to 0.  Usually access should be set to $C3. 
If the file is destroy, rename, and write enabled it is <B>unlocked</B>.  If all three are disabled, it is <B>locked</B>.  Any other combination of access bits is called <B>restricted access</B>. 
The backup bit (B) is set by this call.</DL>

<DL>
  <DT>file_type (1-byte value)</DT>
  <DD>File type: This byte describes the contents of a file.  The currently defined file types are listed below.</DD>
</DL>

<a name="page44"></a>

<PRE>
 <B>File Type       Preferred Use</B>

 $00             Typeless file (SOS and ProDOS)
 $01             Bad block file
 $02 *           Pascal code file
 $03 *           Pascal text file
 $04             ASCII text file (SOS and ProDOS)
 $05 *           Pascal data file
 $06             General binary file (SOS and ProDOS)
 $07 *           Font file
 $08             Graphics screen file
 $09 *           Business BASIC program file
 $0A *           Business BASIC data file
 $0B *           Word Processor file
 $0C *           SOS system file
 $0D,$0E *       SOS reserved
 $0F             Directory file (SOS and ProDOS)
 $10 *           RPS data file
 $11 *           RPS index file
 $12 *           AppleFile discard file
 $13 *           AppleFile model file
 $14 *           AppleFile report format file
 $15 *           Screen library file
 $16-$18 *       SOS reserved
 $19             AppleWorks Data Base file
 $1A             AppleWorks Word Processor file
 $1B             AppleWorks Spreadsheet file
 $1C-$EE         Reserved
 $EF             Pascal area
 $F0             ProDOS added command file
 $F1-$F8         ProDOS user defined files 1-8
 $F9             ProDOS reserved
 $FA             Integer BASIC program file
 $FB             Integer BASIC variable file
 $FC             Applesoft program file
 $FD             Applesoft variables file
 $FE             Relocatable code file (EDASM)
 $FF             ProDOS system file
</PRE>

<P><B>Note:</B> The file types marked with a * in the above list apply to Apple III SOS only; they are not used by ProDOS.  For the file_types used by Apple III SOS only, refer to the <I>SOS Reference Manual</I>.</P>

<a name="page45"></a>

<DL>
  <DT>aux_type (2-byte value)</DT>
  <DD>Auxiliary type: This two-byte field is used by the system program.  The BASIC system program uses it (low byte first) to store record size or load address, depending on the file_type.</DD>
</DL>

<DL>
  <DT>null_field (3 bytes)</DT>
  <DD>Null field: These three bytes preserve symmetry between this and the GET_FILE_INFO call.</DD>
</DL>

<DL>
  <DT>mod_date (2-byte value)</DT>
  <DD>This 2-byte field should contain the current date. It has this fo</DD>
  rmat:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |    Year     |  Month  |   Day   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<DL>
  <DT>mod_time (2-byte value)</DT>
  <DD>This 2-byte field should contain the current time. It has this fo</DD>
  rmat:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |0 0 0|  Hour   | |0 0|  Minute   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<P>See Chapter 6 for information about the use or ProDOS with a clock/calendar card.</P>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $2B - Disk write protected $40 - Invalid pathname syntax $44 - Path not found $45 - Volume directory not found $46 - File not found $4A - Incompatible file format $4B - Unsupported storage_type $4E - Access error: file not write enabled $53 - Invalid value in parameter list $5A - Bit map disk address is impossible</P>

<a name="page46"></a>

<A NAME="4.4.5"></A>

<H3>4.4.5 - GET_FILE_INFO ($C4)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = $A              |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | access        (1-byte result) |
    +---+---+---+---+---+---+---+---+
  4 | file_type     (1-byte result) |
    +---+---+---+---+---+---+---+---+
  5 | aux_type               (low)  | *
  6 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+
  7 | storage_type  (1-byte result) |
    +---+---+---+---+---+---+---+---+
  8 | blocks used            (low)  | *
  9 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+
  A | mod_date             (byte 0) |
  B | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+
  C | mod_time             (byte 0) |
  D | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+
  E | create_date          (byte 0) |
  F | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+
 10 | create_time          (byte 0) |
 11 | (2-byte result)      (byte 1) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>* When file information about a volume directory is requested, the total number of blocks on the volume is returned in the aux_type field and the total blocks for all files is returned in blocks_used.</P>

<P>GET_FILE_INFO returns the information that is stored in the specified file's entry field.  This call can be performed whether the file is open or closed.  If the SET_FILE_INFO call is used to change the access while the file is open, the change does not take effect until the file has been closed and reopened.</P>

<a name="page47"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</DT>
  <DD>Parameter count: $A for this call.</DD>
</DL>

<DL>
  <DT>pathname (2-byte pointer)</DT>
  <DD>Pathname pointer: A two-byte address (low byte first) that points to an ASCII string.  The string consists of a count byte, followed by the pathname (up to 64 characters).  If the pathname begins with a slash ( / ), it is treated as a full pathname.  If not, it is treated as a partial pathname and the prefix is attached to the front to make a full pathname.</DD>
</DL>

<DL>
  <DT>access (1-byte result)</DT>
  <DD>Access permitted: This byte determines how the file may be accessed.  Its forma</DD>
  t is:

<PRE>
   7  6  5  4  3  2  1  0
 +--+--+--+--+--+--+--+--+
 |D |RN|B |Reserved|W |R |
 +--+--+--+--+--+--+--+--+

 D:   Destroy enable bit
 RN:  Rename enable bit
 B:   Backup needed bit
 W:   Write enable bit
 R:   Read enable bit
</PRE>

<P>For all bits, 1 = enabled, 0 = disabled.  Bits 2 through 4 are not used.  Usually access should be set to $C3. 
If the file is destroy, rename, and write enabled it is <B>unlocked</B>.  If all three are disabled, it is <B>locked</B>.  Any other combination of access bits is called <B>restricted access</B>.</DL>

<DL>
  <DT>file_type (1-byte result)</DT>
  <DD>File type: This byte describes the contents of a file.  The currently defined file types are listed below.</P></DD>
</DL>

<a name="page48"></a>

<PRE>
 <B>File Type       Preferred Use</B>

 $00             Typeless file (SOS and ProDOS)
 $01             Bad block file
 $02 *           Pascal code file
 $03 *           Pascal text file
 $04             ASCII text file (SOS and ProDOS)
 $05 *           Pascal data file
 $06             General binary file (SOS and ProDOS)
 $07 *           Font file
 $08             Graphics screen file
 $09 *           Business BASIC program file
 $0A *           Business BASIC data file
 $0B *           Word Processor file
 $0C *           SOS system file
 $0D,$0E *       SOS reserved
 $0F             Directory file (SOS and ProDOS)
 $10 *           RPS data file
 $11 *           RPS index file
 $12 *           AppleFile discard file
 $13 *           AppleFile model file
 $14 *           AppleFile report format file
 $15 *           Screen library file
 $16-$18 *       SOS reserved
 $19             AppleWorks Data Base file
 $1A             AppleWorks Word Processor file
 $1B             AppleWorks Spreadsheet file
 $1C-$EE         Reserved
 $EF             Pascal area
 $F0             ProDOS added command file
 $F1-$F8         ProDOS user defined files 1-8
 $F9             ProDOS reserved
 $FA             Integer BASIC program file
 $FB             Integer BASIC variable file
 $FC             Applesoft program file
 $FD             Applesoft variables file
 $FE             Relocatable code file (EDASM)
 $FF             ProDOS system file
</PRE>

<P><B>Note:</B> The file types marked with a * in the above list apply to Apple III SOS only; they are not used by ProDOS.  For the file_types used by Apple III SOS only, refer to the <I>SOS Reference Manual</I>.</P>

<a name="page49"></a>

<DL>
  <DT>aux_type (2-byte result)</DT>
  <DD>Auxiliary type: This two-byte field is used by the system program.  The BASIC system program uses it (low byte first) to store record size or load address, depending on the file_type.  If this call is used on a volume directory file, aux_type will contain the total number of blocks on the volume.</DD>
</DL>

<DL>
  <DT>storage_type (1-byte result)</DT>
  <DD>File kind: This byte describes the physical organization of the file.  storage_type = $0F is a volume directory file; storage_type = $0D is a directory file; storage_type = $01, $02, and $03 are seedling, sapling, and tree files, respectively (see Appendix B).  All other values are reserved for future use.</DD>
</DL>

<DL>
  <DT>blocks_used (2-byte result)</DT>
  <DD>Blocks used by the file: These two bytes contain the total number of blocks used by the file, as stored in the blocks_used parameter of the file's entry.  If this call is used on a volume directory file blocks_used contains the total number of blocks used by all the files on the volume.</DD>
</DL>

<DL>
  <DT>mod_date (2-byte result)</DT>
  <DD>This 2-byte field returns the date on which the file was last modified.  It has this fo</DD>
  rmat:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |    Year     |  Month  |   Day   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<DL>
  <DT>mod_time (2-byte result)
  <DD>This 2-byte field returns the time at which the file was last modified.  It has this format:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |0 0 0|  Hour   | |0 0|  Minute   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<a name="page50"></a>

<DL>
  <DT>create_date (2-byte result)</DT>
  <DD>This 2-byte field returns the date on which the file was created.  It has this fo</DD>
  rmat:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |    Year     |  Month  |   Day   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<DL>
  <DT>create_time (2-byte result)</DT>
  <DD>This 2-byte field returns the time at which the file was created.  It has this fo</DD>
  rmat:

<PRE>
       byte 1            byte 0

  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 |0 0 0|  Hour   | |0 0|  Minute   |
 +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
</PRE></DL>

<P>See Chapter 6 for information about the use of ProDOS with a clock/calendar card.</P>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $40 - Invalid pathname syntax $44 - Path not found $45 - Volume directory not found $46 - File not found $4A - Incompatible file format $4B - Unsupported storage_type $53 - Invalid value in parameter list $5A - Bit map address is impossible</P>

<A NAME="4.4.6"></A>

<H3>4.4.6 - ON_LINE ($C5)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | unit_num       (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This command can be used to determine the names of all ProDOS (or SOS) volumes that are currently mounted (such as disks in disk drives), or it can be used to determine the name of a disk in a specified slot and drive.</P>

<a name="page51"></a>

<P>When unit_num is 0, this command places a list of the volume names, slot numbers, and drive numbers of all mounted disks into the 256 byte buffer pointed to by data_buffer.  When a specific unit_num is requested, only 16 bytes need be set aside for the buffer.  The format of the returned information is described below.</P>

<P>The volume names are placed in the list in volume search order, as described in section 3.2.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</DT>
  <DD>Parameter count: Must be 2 for this call.</DD>
</DL>

<DL>
  <DT>unit_num (1-byte value)</DT>
  <DD>Device slot and drive number: This one-byte value specifies the hardware slot location of a disk device.  The forma</DD>
  t is:

<PRE>
   7  6  5  4  3  2  1  0
 +--+--+--+--+--+--+--+--+
 |Dr|  Slot  |  Unused   |
 +--+--+--+--+--+--+--+--+
</PRE>

<P>For drive 1, Dr = 0; for drive 2, Dr = 1.  Slot specifies the device's slot number (1-7).  If unit_num is 0, all mounted disks are scanned. Here are possible values for unit_num:</P>

<PRE>
 <B>Slot:      7   6   5   4   3   2   1</B>
 Drive 1:  70  60  50  40  30  20  10
 Drive 2:  F0  E0  D0  C0  B0  A0  90
</PRE></DL>

<DL>
  <DT>data_buffer (2-byte pointer)</DT>
  <DD>Data address pointer: This two-byte address (low byte first) points to a buffer for returned data, which is organized into 16 byte records.  If unit_num is 0, the buffer should be 256 bytes long, otherwise 16 bytes is enough.<br /></DD>
</DL>

<a name="page52"></a>

<DL>
  <DT><DD>The first byte of a record identifies the device and the length of its volume name: 
<PRE>
   7  6  5  4  3  2  1  0
 +--+--+--+--+--+--+--+--+
 |dr|  slot  | name_len  |
 +--+--+--+--+--+--+--+--+
</PRE>

Bit 7 specifies drive 1 (Dr = 0) or drive 2 (Dr = 1).  Bits 6-4 specify the slot number (1 through 7). Bits 3-0 specify a valid name_length if nonzero. The next 15 bytes of the record are for a volume name. 
If name_length = 0, then an error was detected in the specified slot and drive.  The error code is present in the second byte of the record.  If error $57 (duplicate volume) is encountered, the third byte contains the unit number of the duplicate. When multiple records are returned, the last valid record is followed by one that has unit_num and name_length set to 0.</DL>

<P><B>Remember:</B> ON_LINE returns volume names that are not preceded by slashes.  Remember to put a slash in front of the name before you use it in a pathname.</P>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $28 - Device not connected $2E - Disk switched: File still open on other disk $45 - Volume directory not found $52 - Not a ProDOS disk $55 - Volume Control Block full $56 - Bad buffer address $57 - Duplicate volume</P>

<P>When an error pertains to a specific drive, the error code is returned in the second byte of the record corresponding to that drive, as described above.  In such cases, the call completes with the accumulator set to 0, and the carry flag clear.  Only errors $55 and $56 are not drive specific.</P>

<a name="page53"></a>

<A NAME="4.4.7"></A>

<H3>4.4.7 - SET_PREFIX ($C6)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Sets the system prefix to the indicated directory.  The pathname may be a full pathname or a partial pathname.  The system prefix can be set to null by indicating a pathname with a count of zero.  The prefix must be no longer than 64 characters.  When ProDOS is started up, the system prefix is set to the name of the volume in the startup drive.</P>

<P>The MLI verifies that the requested prefix directory is on an on-line volume before accepting it.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: 1 for this call.</DL>

<DL>
  <DT>pathname (2-byte pointer)
  <DD>Pathname pointer: A two-byte address (low byte first) that points to an ASCII string.  The string consists of a count byte, followed by the pathname (up to 64 characters).  If the pathname begins with a slash ( / ), it is treated as a full pathname.  If not, it is treated as a partial pathname and the current prefix is attached to the front to make a full pathname.  A slash at the end of the pathname is optional.</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $40 - Invalid pathname syntax $44 - Path not found $45 - Volume directory not found $46 - File not found $4A - Incompatible file format $4B - Unsupported storage_type $5A - Bit map disk address is impossible</P>

<a name="page54"></a>

<A NAME="4.4.8"></A>

<H3>4.4.8 - GET_PREFIX ($C7)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | data_buffer            (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Returns the current system prefix.  If the system prefix is set to null (no prefix), then a count of 0 is returned.  Otherwise the returned prefix is preceded by a length byte and bracketed by slashes.  Examples are $7/APPLE/ and $D/APPLE/BYTES/.  Each character in the prefix is returned with its high bit cleared.</P>

<P>The buffer pointed to by data_buffer is assumed to be 64 bytes long.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: Must be 1 for this call.</DL>

<DL>
  <DT>data_buffer (2-byte pointer)
  <DD>Data address pointer: This two-byte address (low
byte first) points to the buffer into which the prefix should be placed.  It should be at least 64 bytes long.</DL>

<P><B>Possible Error</B></P>

<P>$56 - Bad buffer address</PRE><a name="page55"></a>

<A NAME="4.5"></A>

<H2>4.5 - Filing Calls</H2>

<P>Each of the following sections contains a description of a filing command, including its parameters and the possible errors that may be returned.</P>

<a name="4.5.1"></A>

<H3>4.5.1 - OPEN ($C8)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | pathname               (low)  |
  2 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  3 | io_buffer              (low)  |
  4 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  5 | ref_num       (1-byte result) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>OPEN prepares a file to be read or written.  It creates a file control block that keeps track of the current (open) characteristics of the file specified by pathname, it sets the current position in the file to zero, and it returns a reference number by which the other commands in this section must refer to the file.</P>

<P>The I/O buffer is used by the system for the entire time the file is open.  It contains information about the file's structure on the disk, and it contains the current 512-byte block being read or written.  It is used until the file is closed, and therefore should not be modified directly by the user.  A maximum of eight files can be open at a time.</P>

<P>When a file is opened it is assigned a <B>level</B>, from 0 to $F, depending on the current value of the LEVEL location ($BF94) in the system global page.  When the CLOSE command is issued with a ref_num of 0, all files at or above the current level are closed.  Thus, a CLOSE with a ref_num of 0 and a level of 0 will close all open files.</P>

<P>Refer to Section 2.1.7, "File Levels," for an example of the use of level.</P>

<P><B>Warning</B> Once a file has been opened, that file's disk must not be removed from its drive and replaced by another.  The system does not check the identity of a volume before writing on it.  A system program should check a volume's identity before writing to it.</P>

<a name="page56"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: 3 for this call.</DL>

<DL>
  <DT>pathname (2-byte pointer)
  <DD>Pathname pointer: A two-byte address (low byte first) that points to an ASCII string.  The string consists of a count byte, followed by the pathname (up to 64 characters).  If the pathname begins with a slash ( / ), it is treated as a full pathname.  If not, it is treated as a partial pathname and the prefix is attached to the front to make a full pathname.</DL>

<DL>
  <DT>io_buffer (2-byte pointer)
  <DD>Buffer address pointer: This two byte-address (low byte first) indicates the starting address of a 1024-byte input/output buffer.  The buffer must start on a page boundary (a multiple of $100) that is not already used by the system. If a standard file is being accessed, the first 512 bytes of io_buffer contain the current block of data being read or written; the second 512 bytes contain the current index block, if there is one.  If a directory file is being accessed, the first 512 bytes contain the current directory file block; the rest are unused.</DL>

<DL>
  <DT>ref_num (2-byte result)
  <DD>Reference number: When a file is opened, the filing system assigns this one-byte value.  All subsequent commands to the open file use this reference number.</DL>

<P>Refer to Appendix B for more information on directory file blocks, index blocks, and data blocks.</P>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $40 - Invalid pathname syntax $42 - File Control Block table full $44 - Path not found $45 - Volume directory not found $46 - File not found $4B - Unsupported storage_type $50 - File is open $53 - Invalid value in parameter list $56 - Bad buffer address $5A - Bit map disk address is impossible</P>

<a name="page57"></a>

<A NAME="4.5.2"></A>

<H3>4.5.2 - NEWLINE ($C9)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | enable_mask    (1-byte value) |
    +---+---+---+---+---+---+---+---+
  3 | newline_char   (1-byte value) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This call allows you to enable or disable newline read mode for any open file.  When newline is disabled, a read request terminates when the requested number of characters has been read, or when the end of file is encountered.  When newline is enabled, a read request will also terminate if the newline character (newline_char) is read.</P>

<P>Each character read is first transferred to the user's data buffer.  Next it is ANDed with the enable_mask and compared to the newline_char. If there is a match, the read is terminated.  For example, if enable_mask is $7F and newline_char is $0D (ASCII CR), either a $0D or $8D matches and terminates input.  This process does not change the character.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: 3 for this call.</DL>

<DL>
  <DT>ref_num (1-byte value)
  <DD>Reference number: This is the filing reference number that was assigned to the file when it was opened.</DL>

<DL>
  <DT>enable_mask (1-byte value)
  <DD>Newline enable and mask: A value of $00 disables newline mode; a nonzero value enables it.  When the mode is enabled, each incoming byte is ANDed with this byte before it is compared to newline_char (below).  A match causes the read request to terminate.  A value of $FF makes all bits significant, a value of $7F causes only bits 0 through 6 to be tested, etc.</DL>

<DL>
  <DT>newline_char (1-byte value)
  <DD>Newline character: When newline is enabled, a read request terminates if the input character, having been ANDed with the enable_mask equals this value.</DL>

<P><B>Possible Error</B></P>

<P>$43 - Invalid reference number</P>

<a name="page58"></a>

<A NAME="4.5.3"></A>

<H3>4.5.3 - READ ($CA)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 4               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | request_count          (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  6 | trans_count            (low)  |
  7 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Tries to transfer the requested number of bytes (request_count), starting at the current position (MARK) of the file specified by ref_num to the buffer pointed to by data_buffer.  The number of bytes actually transferred is returned in trans_count.</P>

<P>If newline read mode is enabled and a newline character is encountered before request_count bytes have been read, then the trans_count parameter is set to the number of bytes transferred, including the newline byte.</P>

<P>If the end of file is encountered before request_count bytes have been read, then trans_count is set to the number of bytes transferred.  The end of file error ($4C) is returned if and only if zero bytes were transferred (trans_count = 0).</P>

<a name="page59"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count<br />(1-byte value)</dt>
  <DD>Parameter count: 4 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: This is the filing reference number that was assigned to the file when it was opened.</dd>
</DL>

<DL>
  <DT>data_buffer (2-byte pointer)</dt>
  <DD>Data address pointer: This two-byte address (low byte first) points to the destination for the data to be read from the file.</dd>
</DL>

<DL>
  <DT>request_count (2-byte value)</dt>
  <DD>Transfer request count: This two-byte value (low byte first) specifies the maximum number of bytes to be transferred to the data buffer pointed to by data_buffer.  The maximum value is limited to the number of bytes between the start of data_buffer and the nearest used page of memory.</dd>
</DL>

<DL>
  <DT>trans_count (2-byte result)</dt>
  <DD>Transferred: This two-byte value (low byte first) indicates the number of bytes actually read.  It will be less than request_count only if EOF was encountered, if the newline character was read while newline mode was enabled, or if some other error occurred during the request.</dd>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $43 - Invalid reference number $4C - End of file has been encountered $4E - Access error: file not read enabled $56 - Bad buffer address $5A - Bit map address is impossible</P>

<a name="page60"></a>

<A NAME="4.5.4"></A>

<H3>4.5.4 - WRITE ($CB)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 4               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | request_count          (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
  6 | trans_count            (low)  |
  7 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Tries to transfer a specified number of bytes (request_count) from the buffer pointed to by data_buffer to the file specified by ref_num starting at the current position (MARK) in the file.  The actual number of bytes transferred is returned in trans_count.</P>

<P>The file position is updated to position + trans_count.  If necessary, additional data and index blocks are allocated to the file, and EOF is extended.</P>

<P>See Appendix B for an explanation of data and index blocks.</P>

<a name="page61"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: 4 for this call.</DL>

<DL>
  <DT>ref_num (1-byte value)
  <DD>Reference number: This is the filing reference number that was assigned when the file was opened.</DL>

<DL>
  <DT>data_buffer (2-byte pointer)
  <DD>Data address pointer: This two-byte address (low byte first) points to the beginning of the data to be transferred to the file.</DL>

<DL>
  <DT>request_count (2-byte value)
  <DD>Transfer request count: This two-byte value (low byte first) specifies the maximum number of bytes to be transferred from the buffer pointed to by data_buffer to the file.</DL>

<DL>
  <DT>trans_count (2-byte result)
  <DD>Bytes transferred: This two-byte value (low byte first), indicates the number of bytes actually transferred.  If no error occurs, this value should always be equal to request_count.</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $2B - Disk write protected $43 - Invalid reference number $48 - Overrun error: not enough disk space $4E - Access error: file not write enabled $56 - Bad buffer address $5A - Bit map disk address is impossible</P>

<a name="page62"></a>

<A NAME="4.5.5"></A>

<H3>4.5.5 - CLOSE ($CC)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This call is used to release all resources used by an open file.  The file control block is released.  If necessary, the file's buffer (io_buffer) is emptied to the file and the directory entry for the file is updated.  Until that ref_num is assigned to another open file, subsequent filing calls using that ref_num will fail.</P>

<P>If ref_num equals zero ($0), all open files at or above the current level are closed.  For example, if you open files at levels 0, 1, and 2, set the level to 1, and then use CLOSE with ref_num set to 0, the files at level 1 and 2 are closed, but the ones at level 0 are not.</P>

<P>The level is a value from 0 to $F that is stored in the LEVEL location ($BFD8) of the system global page.  It is only changed by system programs, and it is used by OPEN and CLOSE.</P>

<P>This call causes the backup bit to be set.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 1 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: The filing reference number that was assigned to the file when it was opened. CLOSE releases this reference number.  If ref_num = 0, all open files at or above the current level are closed.</dd>
</DL>


<P><B>Possible Errors</B></P>

<P>$27 - I/O error $2B - Disk write protected $43 - Invalid reference number $5A - Bit map disk address is impossible</P>

<a name="page63"></a>

<A NAME="4.5.6"></A>

<H3>4.5.6 - FLUSH ($CD)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>The file's write buffer (io_buffer) is emptied to the file, and the file's directory is updated.  If ref_num equals zero ($0), then all open files at or above the current level are flushed.</P>

<P>The backup bit is set by this call.</P>

<P>FLUSH is further explained in Chapter 2, section "Closing and Flushing Files."</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 1 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: This is the filing reference number that was assigned to the file when it was opened.  If ref_num = 0 all open files at or above the current level are flushed.</dd>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $2B - Disk write protected $43 - Invalid reference number $5A - Bit map disk address is impossible</P>

<a name="page64"></a>

<A NAME="4.5.7"></A>

<H3>4.5.7 - SET_MARK ($CE)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | position       (3-byte value) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Changes the current position (MARK) in the file to that specified by the position parameter.  Position may not exceed the end of file (EOF) value.</P>

<P>See the example of SET_MARK in Chapter 2, section "The EOF and MARK."</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 2 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: The filing reference number that was assigned to the file when it was opened.</dd>
</DL>

<DL>
  <DT>position (3-byte value)</dt>
  <DD>File position: This three-byte value (low bytes first) specifies to the File Manager the absolute position in the file at which the next read or write should begin (the MARK).  The file position cannot exceed the file's EOF.</dd>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $43 - Invalid reference number $4D - Position out of range $5A - Bit map disk address is impossible</P>

<a name="page65"></a>

<A NAME="4.5.8"></A>

<H3>4.5.8 - GET_MARK ($CF)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | position      (3-byte result) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Returns the current position (MARK) in an open file.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 2 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: The filing reference number that was assigned to the file when it was opened.</dd>
</DL>

<DL>
  <DT>position (3-byte result)</dt>
  <DD>File position: This three-byte value (low bytes first) is the absolute position in the file at which the next read or write will begin, unless it is changed by a subsequent SET_MARK call.</dd>
</DL>


<P><B>Possible Error</B></P>

<P>$43 - Invalid reference number</P>

<a name="page66"></a>

<A NAME="4.5.9"></A>

<H3>4.5.9 - SET_EOF ($D0)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | EOF            (3-byte value) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Sets the logical size of the file specified by ref_num to EOF.  If the new EOF is less than the current EOF, then blocks past the new EOF are released to the system.  If the new EOF is greater than or equal to the current EOF, no blocks are allocated.  If the new EOF is less than the current position, the value of the position is set to the EOF.  The EOF cannot be changed unless the file is write enabled.</P>

<P>The <B>logical size</B> of a file is the number of bytes that can be read from it.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 2 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: The filing reference number that was assigned to the file when it was opened.</dd>
</DL>

<DL>
  <DT>EOF (3-byte value)</dt>
  <DD>End Of File: This three-byte value (low bytes first) represents the logical end of a file.  It can be greater or less than the current value of EOF. If it is less, blocks past the new EOF are released to the system.</dd>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $43 - Invalid reference number $4D - Position out of range $4E - Access error: File not write enabled $5A - Bit map disk address is impossible</P>

<a name="page67"></a>

<A NAME="4.5.10"></A>

<H3>4.5.10 - GET_EOF ($D1)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 |                        (low)  |
  3 | EOF           (3-byte result) |
  4 |                        (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Returns the number of bytes that can be read from the open file.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 2 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: The filing reference number that was assigned to the file when it was opened.</dd>
</DL>

<DL>
  <DT>EOF (3-byte result)</dt>
  <DD>End Of File: This three-byte result (low bytes first) contains the value of the logical end of file. This value is the maximum number of bytes that can be read from the file.</dd>
</DL>

<P><B>Possible Error</B></P>

<P>$43 - Invalid reference number</P>

<a name="page68"></a>

<A NAME="4.5.11"></A>

<H3>4.5.11 - SET_BUF ($D2)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | io_buffer              (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This call allows you to reassign the address of the input/output buffer that is used by the file specified by ref_num (assigned when the file was opened).  The MLI checks to see that the specified buffer is not already used by the system, then it moves the contents of the old buffer into the new buffer.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 2 for this call.</dd>
</DL>

<DL>
  <DT>ref_num (1-byte value)</dt>
  <DD>Reference number: The filing reference number that was assigned to the file when it was opened.</dd>
</DL>

<DL>
  <DT>io_buffer (2-byte pointer)</dt>
  <DD>Buffer address pointer: This two-byte address (low byte first) indicates the starting address of a 1024 byte I/O buffer.  The buffer must start on a page boundary (multiple of $100) and it must not already be used by the system.</dd>
</DL>

<P><B>Possible Errors</B></P>

<P>$43 - Invalid reference number $56 - Bad buffer address</P>

<a name="page69"></a>

<A NAME="4.5.12"></A>

<H3>4.5.12 - GET_BUF ($D3)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | ref_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | io_buffer              (low)  |
  3 | (2-byte result)        (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>Returns the address of the input/output buffer currently being used by the file specified by ref_num.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count<br />(1-byte value)</dt>
  <DD>Parameter count: 2 for this call.</dd>
</DL>

<DL>
  <DT>ref_num<br />(1-byte value)</dt>
  <DD>Reference number: The filing reference number that was assigned to the file when it was opened.</dd>
</DL>

<DL>
  <DT>io_buffer<br />(2-byte result)</dt>
  <DD>Buffer address pointer: This two-byte address (low byte first) indicates the starting address of a 1024 byte I/O buffer.  The buffer starts on a page boundary (multiple of $100).</dd>
</DL>

<P><B>Possible Error</B></P>

<P>$43 - Invalid reference number</P>

<a name="page70"></a>

<A NAME="4.6"></A>

<H2>4.6 - System Calls</H2>

<P>Each of the following sections describes a system command, including any parameters and possible errors.</P>

<a name="4.6.1"></A>

<H3>4.6.1 - GET_TIME ($82)</H3>

<P>This call has no parameter list, and it cannot generate an error.  It calls a clock/calendar routine, if there is one, which returns the current date and time to the system date and time locations ($BF90-BF93).  If there is no clock/calendar routine, the system date and time locations are left unchanged.</P>

<P>Here is the layout of the four bytes that make up the system date and time.</P><PRE>
          49041 ($BF91)     49040 ($BF90)

         7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 DATE:  |    year     |  month  |   day   |
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

         7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 TIME:  |    hour       | |    minute     |
        +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

          49043 ($BF93)     49042 ($BF92)
</PRE>

<P>When ProDOS starts up, it looks for a clock/calendar card in one of the Apple II's slots.  If it recognizes one, ProDOS installs a routine that can read the date and time from the card and place them in the system date and time locations.  Otherwise, no routine is installed.</P>

<P>Note that the GET_TIME call number for ProDOS is different from the GET_TIME call number for SOS.</P>

<P>Chapter 5 explains the use of the date and time locations by the system.</P>

<P>Chapter 6 explains the installation of clock/calendar routines.</P>

<a name="page71"></a>

<A NAME="4.6.2"></A>

<H3>4.6.2 - ALLOC_INTERRUPT ($40)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 2               |
    +---+---+---+---+---+---+---+---+
  1 | int_num       (1-byte result) |
    +---+---+---+---+---+---+---+---+
  2 | int_code               (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This call places the address of an interrupt receiving routine int_code into the interrupt vector table.  It should be made before you enable the hardware that could cause this interrupt.  It is your responsibility to make sure that the routine is installed at the proper location and that it follows interrupt conventions.</P>

<P>The int_num that is returned gives an indication of what priority the interrupt is given (1, 2, 3, or 4).  Routines that are installed first are given the highest priority.  You must use this number when you remove the routine from the system.</P>

<P>Interrupt receiving routines are described in Chapter 6.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: 2 for this call.</DL>

<DL>
  <DT>int_num (1-byte result)
  <DD>Interrupt vector number: This value, from 1 to 4 is assigned by the MLI to int_num when this call is made.  This number must be retained by the calling routine and used when removing an interrupt routine.</DL>

<DL>
  <DT>int_code (2-byte pointer)
  <DD>Interrupt handler code entry address: This is a pointer (low byte first) to the first byte of a routine that is to be called when the system is polling in response to an interrupt.</DL>

<P><B>Possible Errors</B></P>

<P>$25 - Interrupt vector table full $53 - Invalid parameter</P>

<a name="page72"></a>

<A NAME="4.6.3"></A>

<H3>4.6.3 - DEALLOC_INTERRUPT ($41)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 1               |
    +---+---+---+---+---+---+---+---+
  1 | int_num        (1-byte value) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This call clears the entry for int_num from the interrupt vector table. You must disable interrupt hardware before you make this call.  If you don't, and the hardware interrupts after the vector table has been updated, a <B><TT>SYSTEM FAILURE</TT></B> will occur (see Section 4.8.1).</P>

<P>Interrupt receiving routines are described in Chapter 6.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: 1 for this call.</DL>

<DL>
  <DT>int_num (1-byte value)
  <DD>Interrupt vector number: A value from 1 to 4 that was assigned by the MLI to int_num when ALLOC_INTERRUPT was called.</DL>

<P><B>Possible Error</B></P>

<P>$53 - Invalid parameter</P>

<a name="4.7"></A>

<H2>4.7 - Direct Disk Access Calls</H2>

<P>The direct disk access commands READ_BLOCK and WRITE_BLOCK, allow you to read from or write to any logical block on a disk.  They are intended to be used by utility (such as copying) and diagnostic programs.</P>

<P><B>Warning</B> Application programs should <I>not</I> use these commands: they can very easily damage the data integrity of the ProDOS file structure.  All necessary functions can be performed without these calls.</P>

<P>These calls will also read and write blocks (not tracks and sectors) from DOS 3.3 disks.  A mapping of tracks and sectors on a DOS 3.3 disk to blocks read or written by ProDOS is given in Section B.5.</P>

<P>ProDOS BLOCK_READ and BL0CK_WRITE calls can access DOS 3.3 disks: see Appendix B, Section "DOS 3.3 Disk Organization."</P>

<a name="page73"></a>

<A NAME="4.7.1"></A>

<H3>4.7.1 - READ_BLOCK ($80)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | unit_num       (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | block_num              (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This call reads one block from the disk device specified by unit_num into memory starting at the address indicated by data_buffer.  The buffer must be 512 or more bytes in length.</P>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)
  <DD>Parameter count: 3 for this call.</DL>

<DL>
  <DT>unit_num (1-byte value)
  <DD>Device slot and drive number: This one-byte value specifies the hardware slot location of a disk device.  The format is:
<br />
<PRE>
   7  6  5  4  3  2  1  0
 +--+--+--+--+--+--+--+--+
 |Dr|  Slot  |  Unused   |
 +--+--+--+--+--+--+--+--+
</PRE>
<br />
<br />
The Dr bit specifies either drive 1 (Dr = 0) or drive 2 (Dr = 1).
<br />
<br />
Slot must contain a slot number between 1 and 7, inclusive.
</dd>
</DL>

<DL>
  <DT>data_buffer (2-byte pointer)</dt>
  <DD>Data address pointer: This two-byte address (low byte first) points to the destination for data.  The buffer must be at least 512 bytes long.</dd>
</DL>

<a name="page74"></a>

<DL>
  <DT>block_num (2-byte value)</dt>
  <DD>Logical block number: This two-byte value (low byte first) specifies the logical address of a block of data to be read.  Disk II's, for example, have block addresses ranging from $0 to $117.  There is no general connection between block numbers and the layout of tracks and sectors on the disk. The translation from logical to physical block is done by the device driver.</dd>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $28 - No device connected</P>

<a name="4.7.2"></A>

<H3>4.7.2 - WRITE_BLOCK ($81)</H3>

<PRE>
      7   6   5   4   3   2   1   0
    +---+---+---+---+---+---+---+---+
  0 | param_count = 3               |
    +---+---+---+---+---+---+---+---+
  1 | unit_num       (1-byte value) |
    +---+---+---+---+---+---+---+---+
  2 | data_buffer            (low)  |
  3 | (2-byte pointer)       (high) |
    +---+---+---+---+---+---+---+---+
  4 | block_num              (low)  |
  5 | (2-byte value)         (high) |
    +---+---+---+---+---+---+---+---+
</PRE>

<P>This call transfers one block of data from the memory buffer indicated by data_buffer to the disk device specified by unit_num.  The block of data is placed in the logical block specified by block_num.  It is assumed that the data buffer is at least 512 bytes long.</P>

<a name="page75"></a>

<P><B>Parameters</B></P>

<DL>
  <DT>param_count (1-byte value)</dt>
  <DD>Parameter count: 3 for this call.</dd>
</DL>

<DL>
  <DT>unit_num (1-byte value)</dt>
  <DD>Device slot and drive number: This one-byte value specifies the hardware slot location of a disk device.  The format is:
<br /><br />
<PRE>
   7  6  5  4  3  2  1  0
 +--+--+--+--+--+--+--+--+
 |Dr|  Slot  |  Unused   |
 +--+--+--+--+--+--+--+--+
</PRE>
<br /><br />
The Dr bit specifies either drive 1 (Dr = 0) or drive 2 (Dr = 1).  Slot must contain a slot number between 1 and 7, inclusive.</dd>
</DL>

<DL>
  <DT>data_buffer (2-byte pointer)</dt>
  <DD>Data address pointer: This two-byte address (low byte first) points to the source of data to be transferred.  It is assumed that the data buffer is at least 512 bytes in length.</dd>
</DL>

<DL>
  <DT>block_num (2-byte value)</dt>
  <DD>Logical block number: This two-byte value (low byte first) specifies the logical address on a disk of the block to be written.  Disk II's, for example, have block addresses ranging from $0 to $117. There is no general connection between block numbers and the layout of tracks and sectors on the disk.  The translation from logical to physical block is done by the device driver. An out-of-range block_num returns an I/O error. The number of blocks on a volume is returned in the aux_type field of the GET_FILE_INFO call of a volume directory file.</dd>
</DL>

<P><B>Possible Errors</B></P>

<P>$27 - I/O error $28 - No device connected $2B - Disk write protected</P>

<a name="page76"></a>

<A NAME="4.8"></A>

<H2>4.8 - MLI Error Codes</H2>

<P>This is a summary of the ProDOS error codes.  If there is no error, the C-flag is clear, and the Accumulator contains $00.  If there is an error, the C-flag is set, and the Accumulator contains the error code.</P>

<P><B>$00</B> - No error.</P>

<P><B>$01</B> - Bad system call number.  A non-existent command was issued.</P>

<P><B>$04</B> - Bad system call parameter count.  This error will occur only if the call parameter list is not properly constructed.</P>

<P><B>$25</B> - Interrupt vector table full.  Only four routines can be activated for interrupt processing at a time.  One must be deactivated before another one may be enabled.</P>

<P><B>$27</B> - I/O error.  This catch-all error is reported when some hardware failure prevents proper transfer of data to/from the disk device.</P>

<P><B>$28</B> - No device detected/connected.  Will occur if, for example, drive 2 is specified for Disk II when only one drive is connected.</P>

<P><B>$2B</B> - Disk write protected.  Hardware write-inhibit is enabled, write request cannot be processed.</P>

<P><B>$2E</B> - Disk switched: A WRITE, FLUSH, or CLOSE operation cannot be accomplished because a disk containing an open file has been removed from its drive.</P>

<P><B>$40</B> - Invalid pathname syntax.  The pathname contains illegal characters.</P>

<P><B>$42</B> - File Control Block table full.  The FCB can contain a maximum of eight entries.  Thus, a maximum of eight files can be open concurrently.</P>

<P><B>$43</B> - Invalid reference number.  The value parameter given as a reference number does not match the reference number of any currently open file.</P>

<P><B>$44</B> - Path not found.  A filename in the specified pathname (which refers to a subdirectory) does not exist.  The pathname's syntax is legal.</P>

<P><B>$45</B> - Volume directory not found.  The volume name in the specified pathname does not exist.  The pathname's syntax is otherwise legal.</P>

<a name="page77"></a>

<P><B>$46</B> - File not found.  The last filename of the pathname does not exist.  The syntax of the pathname is legal.</P>

<P><B>$47</B> - Duplicate filename.  An attempt was made to create a file that already exists or to rename a file with an already used name.</P>

<P><B>$48</B> - Overrun error.  An attempt to allocate blocks on a block device during a CREATE or WRITE operation failed due to lack of space on the device.  This error also is returned on an invalid EOF parameter. Data is written until the disk is full, but you will always be able to close the file.</P>

<P><B>$49</B> - Volume directory full.  No more entries are left in the volume directory.  In ProDOS 1.0, a volume directory can hold no more than 51 entries.  No more files can be added (using CREATE) in this directory until others are destroyed.</P>

<P><B>$4A</B> - Incompatible file format.  The file is not backward compatible with this version of ProDOS. Storage_type is recognized, but the File Manager may not support that storage_type in a fully compatible fashion.  This error is likely to occur when data written by a future version of the BFM is read back using an earlier version of the BFM.</P>

<P><B>$4B</B> - Unsupported storage_type.  File is of an organization unknown to the executing File Manager.  This error may be reported if the directory is tampered with by the user.  This error is also returned if you attempt to set the prefix to a nondirectory file.</P>

<P><B>$4C</B> - End of file has been encountered.  This error is returned after a READ call when the file position is equal to EOF and no data can be read.</P>

<P><B>$4D</B> - Position out of range.  Returned when the position parameter is greater than current EOF.</P>

<P><B>$4E</B> - Access error.  The file's access attribute forbids the RENAME, DESTROY, READ or WRITE operation that was attempted.</P>

<P><B>$50</B> - File is open.  An attempt was made to OPEN, RENAME or DESTROY an open file.</P>

<P><B>$51</B> - Directory count error: The number of entries indicated in the directory header does not match the number of entries actually found in the file.</P>

<a name="page78"></a>

<P><B>$52</B> - Not a ProDOS disk.  The specified disk does not contain a ProDOS (or SOS) directory format.</P>

<P><B>$53</B> - Invalid parameter.  The value of one or more parameters in the parameter list is out of range.</P>

<P><B>$55</B> - Volume Control Block table full.  More than eight volumes on line.  The VCB table can contain a maximum of eight entries.  This error occurs only if eight files, on eight volumes, are open and the ON_LINE command is requested for a device having no open files.</P>

<P><B>$56</B> - Bad buffer address.  The data_buffer or io_buffer specified conflicts with memory currently in use by the MLI.</P>

<P><B>$57</B> - Duplicate volume.  This is a warning that two or more volume directory names are the same.</P>

<P><B>$5A</B> - Bit map disk address is impossible.  The volume bit map indicates that the volume contains blocks beyond the block count for that volume.</P><BLOCKQUOTE>

<P><B>Note:</B> <I>System failure</I> errors should never occur.  They indicate that the system has encountered a situation that should not have happened, and it has no available means of recovery.</P>

<P>Possible causes include</P>

<UL>
  <LI>bad RAM</li>
  <LI>disk failure</li>
  <LI>operating system bug</li>
  <LI>unclaimed interrupt.</li>
</UL>

</BLOCKQUOTE>

<a name="page79"></a>

<a name="page80"></a>
