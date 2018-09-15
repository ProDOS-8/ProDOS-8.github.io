---
layout:      page
title:       TechRef - File Use
description: ProDOS 8 Technical Reference Manual File Use
permalink:   /docs/techref/file-use/
---


<A NAME="2"><H1>Chapter 2<br />File Use</H1></A>

<a name="page9"></a>

<P>Chapter 1 introduced you to the concepts of volumes and files.  This<br />
chapter explains how files are named, how they are created and used<br />
and a little about how they are organized on disks.  When you have<br />
finished reading this chapter you will be nearly ready to start using<br />
the ProDOS Machine Language Interface filing calls.</P>

<P>The technical details of file organization<br />
are given in Appendix B.</P>

<A NAME="2.1"><H2>2.1 - Using Files</H2></A>

<P>A ProDOS <B>filename</B> or <B>volume name</B> is up to 15 characters long.  It<br />
may contain capital letters (A-Z), digits (0-9), and periods (.), and it<br />
must begin with a letter.  Lowercase letters are automatically converted<br />
to uppercase.  A filename must be unique within its directory.  Some<br />
examples are</P>

<B><PRE>
 LETTERS
 JUNK1
 BASIC.SYSTEM
</PRE></B>

<P><B>By the Way:</B> On the Apple II, an ASCII character is read from the<br />
keyboard and printed to the screen with its high bit set.  ProDOS clears<br />
this high bit.</P>

<A NAME="2.1.1"><H3>2.1.1 - Pathnames</H3></A>

<P>A ProDOS <B>pathname</B> is a series of filenames, each preceded by a<br />
slash (/).  The first filename in a pathname is the name of a volume<br />
directory.  Successive filenames indicate the path, from the volume<br />
directory to the file, that ProDOS must follow to find a particular file.<br />
The maximum length for a pathname is 64 characters, including<br />
slashes.  Examples are</P>

<B><PRE>
 /PROFILE/GAMES/DISKWARS
 /PROFILE/JUNK1
 /PROFILE/SYSTEMPROGRAMS/FILER
</PRE></B>

<P>All calls that require you to name a file will accept either a pathname<br />
or a <B>partial pathname</B>.  A partial pathname is a portion of a pathname<br />
that doesn't begin with a slash or a volume name.  The maximum<br />
length for a partial pathname is 64 characters, including slashes.  These<br />
partial pathnames are all derived from the sample pathnames above.</P>

<a name="page10"></a>

<P>The partial pathnames are</P>

<B><PRE>
 DISKWARS
 JUNK1
 SYSTEMPROGRAMS/FILER
 FILER
</PRE></B>

<P>ProDOS automatically adds the <B>prefix</B> to the front of partial pathnames<br />
to form full pathnames.  The prefix is a pathname that indicates a<br />
directory; it is internally stored by ProDOS.  To locate a file by its<br />
pathname, ProDOS must look through each file in the path.  If you<br />
specify a partial pathname, however, ProDOS jumps straight to the<br />
prefix directory and starts searching from there.  Thus disk accesses are<br />
faster when you set the prefix and use partial pathnames.</P>

<P>For the partial pathnames listed above to indicate valid files, the prefix<br />
should be set to <B><TT>/PROFILE/GAMES/</TT></B>, <B><TT>/PROFILE/</TT></B>,<br />
<B><TT>/PROFILE/</TT></B>, and <B><TT>/PROFILE/SYSTEMPROGRAMS/</TT></B>,<br />
respectively.  The slashes at the end of these prefixes are optional;<br />
however, they are convenient reminders that prefixes indicate directory<br />
files.</P>

<P>The maximum length for a prefix is 64 characters.  The minimum<br />
length for a prefix is zero characters, known as a <B>null prefix</B>.  You set<br />
and read the prefix using the MLI calls, SET_PREFIX and<br />
GET_PREFIX, respectively.  The 64 character limits for the prefix and<br />
partial pathname combine to create a maximum pathname of<br />
128 characters.</P>

<P>Figure 2-1 illustrates a typical directory structure; it contains all the<br />
files mentioned above.</P>

<a name="page11"></a>

<A NAME="2-1"><P><B>Figure 2-1.  A Typical ProDOS Directory Structure</B></P></A>

<PRE>
                                                     +---------------+
                            +-----------------+  +--&#62;| VIDEOBALL     |
                      +----&#62;| PROGRAMS/       |  |   +---------------+
                      |     |-----------------|  |
                      |     | VIDEOBALL      -|--+   +---------------+
                      |     | DISKWARS       -|-----&#62;| DISKWARS      |
                      |     |                 |      +---------------+
                      |     +-----------------+
 +-----------------+  |
 | /PROFILE/       |  |
 |-----------------|  |                              +---------------+
 | PROGRAMS/       |--+     +-----------------+  +--&#62;| MOM           |
 | LETTERS/        |-------&#62;| LETTERS/        |  |   +---------------+
 | SYSTEMPROGRAMS/ |----+   |-----------------|  |
 | JUNK/           |--+ |   | MOM            -|--+   +---------------+
 +-----------------+  | |   | DAD            -|-----&#62;| DAD           |
                      | |   | SPOT           -|--+   +---------------+
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
                      |     | BASIC.SYSTEM   -|--+   +---------------+
                      |     | FILER          -|-----&#62;| FILER         |
                      |     | CONVERT        -|--+   +---------------+
                      |     +-----------------+  |
                      |                          |   +---------------+
                      |                          +--&#62;| CONVERT       |
                      |                              +---------------+
                      |
                      |     +-----------------+
                      +----&#62;| JUNK            |
                            +-----------------+
</PRE>

<a name="page12"></a>

<A NAME="2.1.2"><H3>2.1.2 - Creating Files</H3></A>

<P>A file is placed on a disk by the CREATE call.  When you create a file,<br />
you assign it the following properties:</P>

<UL>

<LI>A pathname.  This pathname is a unique path by which the file can<br />
be identified and accessed.  This pathname must place the file within<br />
an existing directory.

<LI>An access byte.  The value of this byte determines whether or not<br />
the file can be written to, read from, destroyed, or renamed.

<LI>A file_type.  This byte indicates to other system programs the type<br />
of information to be stored in the file.  It does not affect, in any<br />
way, the contents of the file.

<LI>A storage_type.  This byte determines the physical format of the file<br />
on the disk.  There are only two different formats: one is used for<br />
directory files, the other for non-directory files.

<LI>A creation_date and a creation_time.

</UL>

<P>When you create a file, these properties are placed on the disk.  The<br />
file's name can be changed using the RENAME call; other properties<br />
can be altered using the SET_FILE_INFO call.  The disk storage<br />
format of these properties is given in Appendix B.</P>

<P>Once a file has been created, it remains on the disk until it is<br />
destroyed (using the DESTROY call).</P>

<A NAME="2.1.3"><H3>2.1.3 - Opening Files</H3></A>

<P>Before you can read information from or write information to a file<br />
you must use the OPEN call to open the file for access.  When you<br />
open a file you specify:</P>

<UL>

<LI>A pathname.  This pathname must indicate a previously created file<br />
that is on a disk mounted in a disk drive.

<LI>The starting address in memory of an I/O buffer.  Each open file<br />
requires its own 1024-byte buffer for the transfer of information to<br />
and from the file.

</UL>

<P>The OPEN call returns a reference number (ref_num).  All subsequent<br />
references to the open file must use this reference number.  The file<br />
remains open until you use the CLOSE call.</P>

<a name="page13"></a>

<P>Each open file's I/O buffer is used by the system the entire time the<br />
file is open.  Thus it is wise to keep as few files open as possible.  A<br />
maximum of eight files can be open at a time.</P>

<P>When you open a file, some of the file's characteristics are placed into<br />
a region of memory called a <B>file control block</B>.  Several of these<br />
characteristics -- the location in memory of the file's buffer, a pointer to<br />
the end of the file (the EOF), and a pointer to the current position in<br />
the file (the file's MARK) -- are accessible to system programs via MLI<br />
calls, and may be changed while the file is open.</P>

<P>It is important to be aware of the differences between a file on the<br />
disk and an open file in memory.  Although some of the file's<br />
characteristics and some of its data may be in memory at any given<br />
time, the file itself still resides on the disk.  This allows ProDOS to<br />
manipulate files that are much larger than the computer's memory<br />
capacity.  As a system program writes to the file and changes its<br />
characteristics, new data and characteristics are written to the disk.</P>

<P><B>Warning</B><br />
In is crucial that you close all files before turning off the<br />
computer or pressing [CONTROL]-[RESET].  This is the only way<br />
than you can ensure that all written data has been placed on the<br />
disk.  See also the FLUSH call.</P>

<A NAME="2.1.4"><H3>2.1.4 - The EOF and MARK</H3></A>

<P>To aid the tasks of reading from and writing to files, each open file<br />
has one pointer indicating the end of the file, the EOF, and another<br />
defining the current position in the file, the MARK.  Both are moved<br />
automatically by ProDOS, but can also be independently moved by the<br />
system program.</P>

<P>The EOF is the number of readable bytes in the file.  Since the first<br />
byte in a file has number 0, the EOF, when treated as a pointer, points<br />
one position past the last character in the file.</P>

<P>When a file is opened, the MARK is set to indicate the first byte in the<br />
file.  In is automatically moved forward one byte for each byte written<br />
to or read from the file.  The MARK, then, always indicates the next<br />
byte to be read from the file, or the next byte position in which to<br />
write new data.  It cannot exceed the EOF.</P>

<a name="page14"></a>

<P>If during a write operation the MARK meets the EOF both the MARK<br />
and the EOF are moved forward one position for every additional byte<br />
written to the file.  Thus, adding bytes to the end of the file<br />
automatically advances the EOF to accommodate the new information.<br />
Figure 2-2 illustrates the relationship between the MARK and the EOF.</P>

<A NAME="2-2"><P><B>Figure 2-2.  Automatic Movement of EOF and MARK</B></P></A>

<PRE>
             EOF                  EOF               Old EOF  EOF
              |                    |                      \  |
              v                    v                       v v
   +---------+ +        +---------+ +           +------------ +
   | | | | | | |        | | | | | | |           | | | | | | | |
   +---------+ +        +---------+ +           +------------ +
        ^                    ^   ^                       ^   ^
        |                    |   |                       |   |
       MARK           Old MARK  MARK              Old MARK  MARK

 <B>Beginning Position   After Reading Two Bytes   After Writing Two Bytes</B>
</PRE>

<P>A system program can place the EOF anywhere, from the current<br />
MARK position to the maximum possible byte position.  The MARK can<br />
be placed anywhere from the first byte in the file to the EOF.  These<br />
two functions can be accomplished using the SET_EOF and<br />
SET_MARK calls.  The current values of the EOF and the MARK can<br />
be determined using the GET_EOF and GET_MARK calls.</P>

<A NAME="2.1.5"><H3>2.1.5 Reading and Writing Files</H3></A>

<P>READ and WRITE calls to the MLI transfer data between memory and<br />
a file.  For both calls, the system program must specify three things:</P>

<UL>

<LI>The reference number of the file (assigned when the file was<br />
opened).

<LI>The location in memory of a buffer (data_buffer) that contains, or<br />
is to contain, the transferred data.  Note that this cannot be the<br />
same buffer that was specified when the file was opened.

<LI>The number of bytes to be transferred.

</UL>

<P>When the request has been carried out, the MLI passes back to the<br />
system program the number of bytes that it actually transferred.</P>

<a name="page15"></a>

<P>A read or write request starts at the current MARK, and continues<br />
until the requested number of bytes has been transferred (or, on a<br />
read, until the end of file has been reached).  Read requests can also<br />
terminate when a specified character is read.  You turn on this feature<br />
and set the character(s) on which reads will terminate using the<br />
NEWLINE call.  It is typically used for reading lines of text that are<br />
terminated by carriage returns.</P>

<P><B>By the Way:</B> Neither a READ nor a WRITE call necessarily causes a<br />
disk access.  It is only when a read or write crosses a 512-byte (block)<br />
boundary that a disk access occurs.</P>

<A NAME="2.1.6"><H3>2.1.6 - Closing and Flushing Files</H3></A>

<P>When you finish reading from or writing to a file, you must use the<br />
CLOSE call to close the file.  When you use this call, you specify</P>

<UL>

<LI>the reference number of the file (assigned when the file was<br />
opened).

</UL>

<P>CLOSE writes any unwritten data to the file, and it updates the file's<br />
size in the directory, if necessary.  Then it frees the 1024-byte<br />
io_buffer for other uses and releases the file's reference number.</P>

<P>Information in the file's directory, such as the file's size, is normally<br />
updated only when the file is closed.  If you were to press<br />
[CONTROL]-[RESET] (typically halting the current program) while a<br />
file is open, data written to the file since it was opened could be lost<br />
and the integrity of the disk could be damaged.  This can be prevented<br />
by using the FLUSH call.  To use FLUSH you specify</P>

<UL>

<LI>the reference number of the file (assigned when the file was<br />
opened).

</UL>

<P>If you press [CONTROL]-[RESET] while an open but flushed file is in<br />
memory, there is no loss of data and no damage to the disk.<br />
Both the CLOSE and FLUSH calls, when used with a reference number<br />
of 0, normally cause all open files to be closed or flushed.  Specific<br />
groups of files can be closed or flushed using the <B>system level</B>.</P>

<a name="page16"></a>

<A NAME="2.1.7"><H3>2.1.7 - File Levels</H3></A>

<P>When a file is opened, it is assigned a level, according to the value of<br />
a specific byte in memory (the system level).  If the system level is<br />
never changed, the CLOSE and FLUSH calls, when used with a<br />
reference number of 0, cause all open files to be closed or flushed.  But<br />
if the level has been changed since the first file was opened, only the<br />
files having a file level greater than or equal to the current system<br />
level are closed or flushed.</P>

<P>The system level feature is used, for example, by the BASIC system<br />
program to implement the EXEC command.  An EXEC file is opened<br />
with a level of 0, then the level is set to 7.  A BASIC CLOSE command<br />
(intended to close all files opened within the EXEC program) closes all<br />
files at or above level 7, but the EXEC file itself remains open.</P>

<A NAME="2.2"><H2>2.2 - File Organization</H2></A>

<P>This portion of the chapter describes in general terms the organization<br />
of files on a disk.  It does not attempt to teach you everything about<br />
file organization: its purpose is to familiarize you with the terms and<br />
concepts required by the filing calls.</P>

<P>Appendix B elaborates on the subject of<br />
file organization.</P>

<A NAME="2.2.1"><H3>2.2.1 - Directory Files and Standard Files</H3></A>

<P>Every ProDOS file is a named, ordered sequence of bytes that can be<br />
read from, and to which the rules of MARK and EOF apply.  However,<br />
there are two types of files: <B>directory files</B> and <B>standard files</B>.<br />
Directory files are special files that describe and point to other files on<br />
the disk.  They may be read from, but not written to (except by<br />
ProDOS).  All nondirectory files are standard files.  They may be read<br />
from and written to.</P>

<P>A directory file contains a number of similar elements, called <B>entries</B>.<br />
The first entry in a directory file is the header entry: it holds the<br />
name and other properties (such as the number of files stored in that<br />
directory) of the directory file.  Each subsequent entry in the file<br />
describes and points to some other file on the disk.  Figure 2-3<br />
represents the structure of a directory file.</P>

<a name="page17"></a>

<A NAME="2-3"><P><B>Figure 2-3.  Directory File Structure</B></P></A>

<PRE>

<B>  Directory File           Other Files</B>

 +--------------+        +--------------+
 |              |  +----&#62;|     File     |
 | Header Entry |  |     +--------------+
 |              |  |
 |--------------|  |     +--------------+
 |              |  | +--&#62;|     File     |
 |    Entry    -|--+ |   +--------------+
 |              |    |
 |--------------|    |
 |             -|----+
 |             -|---&#62;
 | More Entries-|--&#62;
 |             -|---&#62;    +--------------+
 |             -|-------&#62;|     File     |
 |--------------|        +--------------+
 |              |
 |    Entry    -|---+    +--------------+
 |              |   +---&#62;|     File     |
 |--------------|        +--------------+
 |              |
 |    Entry    -|---+    +--------------+
 |              |   +---&#62;|     File     |
 +--------------+        +--------------+

</PRE>

<P>The files described and pointed to by the entries in a directory file can<br />
be standard files or other directory files.</P>

<P>A system program does not need to know the details of directory<br />
structure to access files with known names.  Only operations on<br />
unknown files (such as listing the files in a directory) require the<br />
system program to examine a directory's entries.  For such tasks, refer<br />
to Appendix B.</P>

<P>Standard files have no such predefined internal structure: the format of<br />
the data depends on the specific file type.</P>

<A NAME="2.2.2"><H3>2.2.2 - File Structure</H3></A>

<P>Because directory files are generally smaller than standard files, and<br />
because they are sequentially accessed, ProDOS uses a simpler form of<br />
storage for directory files.  Both types of files are stored as a set of<br />
512-byte blocks, but the way in which the blocks are arranged on the<br />
disk differs.</P>

<P>A directory file is a linked list of blocks: each block in a directory file<br />
contains a pointer to the next block in the directory file as well as a<br />
pointer to the previous block in the directory.  Figure 2-4 illustrates this<br />
structure.</P>

<a name="page18"></a>

<A NAME="2-4"><P><B>Figure 2-4.  Block Organization of a Directory File</B></P></A>

<PRE>

 +------------+       +------------+       +------------+
 | Key Block  |&#60;------|            |&#60;-...&#60;-| Last Block |
 |            |------&#62;|            |-&#62;...-&#62;|            |
 |            |       |            |       |            |
 |            |       |            |       |            |
 |            |       |            |       |            |
 +------------+       +------------+       +------------+

</PRE>

<P>Data files, on the other hand, are often quite large, and their contents<br />
may be randomly accessed.  It would be very slow to access such large<br />
files if they were organized sequentially.  Instead ProDOS stores<br />
standard files using a <B>tree structure</B>.  The largest possible standard file<br />
has a <B>master index block</B> that points to 128 <B>index blocks</B>.  Each index<br />
block points to 256 <B>data blocks</B> and each data block can hold 512<br />
bytes of data.  The block organization of the largest possible standard<br />
file is shown in Figure 2-5.</P>

<A NAME="2-5"><P><B>Figure 2-5.  Block Organization of a Standard File</B></P></A>

<PRE>
                    +---------------------+
                    |     Master Index    |
                    |        Block        |
                    +---------------------+
                     | | | | | | | | | | |
                     | v v v v | v v v v |
          +----------+         |         +----------+
          |                    |                    |
          v                    v                    v
   +-------------+      +-------------+      +-------------+
   |    Index    |      |    Index    |      |    Index    |
   |   Block 0   |      |   Block n   |      |  Block 127  |
   +-------------+      +-------------+      +-------------+
     | | | | | |          | | | | | |          | | | | | |
     | v v v v |          | v v v v |          | v v v v |
     |         |          |         |          |         |
     v         v          v         v          v         v
 +-------+ +-------+  +-------+ +-------+  +-------+ +-------+
 | Data  | | Data  |  | Data  | | Data  |  | Data  | | Data  |
 | Block | | Block |  | Block | | Block |  | Block | | Block |
 |   0   | |  255  |  |   0   | |  255  |  |   0   | |  255  |
 +-------+ +-------+  +-------+ +-------+  +-------+ +-------+
</PRE>

<P>Most standard files do not have this exact organization.  ProDOS only<br />
writes a subset of this structure to the file, depending on the amount<br />
of data written to the file.  This technique produces three distinct forms<br />
of standard file: seedling, sapling, and tree files.</P>

<P>Appendix B describes the three forms of<br />
standard file.</P>

<a name="page19"></a>

<A NAME="2.2.3"><H3>2.2.3 - Sparse Files</H3></A>

<P>In most instances a program writes data sequentially into a file.  By<br />
writing data, moving the EOF and MARK, and then writing more data,<br />
a program can also write nonsequential data to a file.  For example, a<br />
program can open a file, write ten characters of data, and then move<br />
the EOF and MARK (thereby making the file bigger) to $3FE0 before<br />
writing ten more bytes of data.  The file produced takes up only three<br />
blocks on the disk (a total of 1536 bytes), yet over 16,000 bytes can be<br />
read from the file.  Such files are known as <B>sparse files</B>.</P>

<BLOCKQUOTE>

<P><B>Important!</B><br />
The fact that more data can be read from the file than actually resides<br />
on the disk can cause a problem.  Suppose that you were trying to copy<br />
a sparse file from one disk to another.  If you were to read data from<br />
one file and write it to another, the new file would be much larger<br />
than the original because data that is not actually on the disk can be<br />
read from the file.  Thus if your system program is going to transfer<br />
sparse files, you must use the information in Appendix B to determine<br />
which data segments should be copied, and which should not.</P>

<P>The ProDOS Filer automatically preserves the structure of sparse files<br />
on a copy.</P>

</BLOCKQUOTE>

<a name="page20"></a>
