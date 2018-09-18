---
layout:      page
title:       TechRef - File Use
description: ProDOS 8 Technical Reference Manual File Use
permalink:   /docs/techref/file-use/
---


<A NAME="2"></A>

<a name="page9"></a>

<P>Chapter 1 introduced you to the concepts of volumes and files.  This chapter explains how files are named, how they are created and used and a little about how they are organized on disks.  When you have finished reading this chapter you will be nearly ready to start using the ProDOS Machine Language Interface filing calls.</P>

<P>The technical details of file organization are given in Appendix B.</P>

<A NAME="2.1"></A>

<H2>2.1 - Using Files</H2>

<P>A ProDOS <B>filename</B> or <B>volume name</B> is up to 15 characters long.  It may contain capital letters (A-Z), digits (0-9), and periods (.), and it must begin with a letter.  Lowercase letters are automatically converted to uppercase.  A filename must be unique within its directory.  Some examples are</P>

{% highlight basic %}
 LETTERS
 JUNK1
 BASIC.SYSTEM
{% endhighlight %}

<P><B>By the Way:</B> On the Apple II, an ASCII character is read from the keyboard and printed to the screen with its high bit set.  ProDOS clears this high bit.</P>

<A NAME="2.1.1"></A>

<H3>2.1.1 - Pathnames</H3>

<P>A ProDOS <B>pathname</B> is a series of filenames, each preceded by a slash (/).  The first filename in a pathname is the name of a volume directory.  Successive filenames indicate the path, from the volume directory to the file, that ProDOS must follow to find a particular file. The maximum length for a pathname is 64 characters, including slashes.  Examples are</P>

{% highlight basic %}
 /PROFILE/GAMES/DISKWARS
 /PROFILE/JUNK1
 /PROFILE/SYSTEMPROGRAMS/FILER
{% endhighlight %}

<P>All calls that require you to name a file will accept either a pathname or a <B>partial pathname</B>.  A partial pathname is a portion of a pathname that doesn't begin with a slash or a volume name.  The maximum length for a partial pathname is 64 characters, including slashes.  These partial pathnames are all derived from the sample pathnames above.</P>

<a name="page10"></a>

<P>The partial pathnames are</P>

{% highlight basic %}
 DISKWARS
 JUNK1
 SYSTEMPROGRAMS/FILER
 FILER
{% endhighlight %}

<P>ProDOS automatically adds the <B>prefix</B> to the front of partial pathnames to form full pathnames.  The prefix is a pathname that indicates a directory; it is internally stored by ProDOS.  To locate a file by its pathname, ProDOS must look through each file in the path.  If you specify a partial pathname, however, ProDOS jumps straight to the prefix directory and starts searching from there.  Thus disk accesses are faster when you set the prefix and use partial pathnames.</P>

<P>For the partial pathnames listed above to indicate valid files, the prefix should be set to <B><TT>/PROFILE/GAMES/</TT></B>, <B><TT>/PROFILE/</TT></B>, <B><TT>/PROFILE/</TT></B>, and <B><TT>/PROFILE/SYSTEMPROGRAMS/</TT></B>, respectively.  The slashes at the end of these prefixes are optional; however, they are convenient reminders that prefixes indicate directory files.</P>

<P>The maximum length for a prefix is 64 characters.  The minimum length for a prefix is zero characters, known as a <B>null prefix</B>.  You set and read the prefix using the MLI calls, SET_PREFIX and GET_PREFIX, respectively.  The 64 character limits for the prefix and partial pathname combine to create a maximum pathname of 128 characters.</P>

<P>Figure 2-1 illustrates a typical directory structure; it contains all the files mentioned above.</P>

<a name="page11"></a>

<A NAME="2-1"></A>

<P><B>Figure 2-1.  A Typical ProDOS Directory Structure</B></P>

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

<A NAME="2.1.2"></A>

<H3>2.1.2 - Creating Files</H3>

<P>A file is placed on a disk by the CREATE call.  When you create a file, you assign it the following properties:</P>

<UL>

<LI>A pathname.  This pathname is a unique path by which the file can be identified and accessed.  This pathname must place the file within an existing directory.</li>

<LI>An access byte.  The value of this byte determines whether or not the file can be written to, read from, destroyed, or renamed.</li>

<LI>A file_type.  This byte indicates to other system programs the type of information to be stored in the file.  It does not affect, in any way, the contents of the file.</li>

<LI>A storage_type.  This byte determines the physical format of the file on the disk.  There are only two different formats: one is used for directory files, the other for non-directory files.</li>

<LI>A creation_date and a creation_time.</li>

</UL>

<P>When you create a file, these properties are placed on the disk.  The file's name can be changed using the RENAME call; other properties can be altered using the SET_FILE_INFO call.  The disk storage format of these properties is given in Appendix B.</P>

<P>Once a file has been created, it remains on the disk until it is destroyed (using the DESTROY call).</P>

<A NAME="2.1.3"></A>

<H3>2.1.3 - Opening Files</H3>

<P>Before you can read information from or write information to a file you must use the OPEN call to open the file for access.  When you open a file you specify:</P>

<UL>

<LI>A pathname.  This pathname must indicate a previously created file that is on a disk mounted in a disk drive.</li>

<LI>The starting address in memory of an I/O buffer.  Each open file requires its own 1024-byte buffer for the transfer of information to and from the file.</li>

</UL>

<P>The OPEN call returns a reference number (ref_num).  All subsequent references to the open file must use this reference number.  The file remains open until you use the CLOSE call.</P>

<a name="page13"></a>

<P>Each open file's I/O buffer is used by the system the entire time the file is open.  Thus it is wise to keep as few files open as possible.  A maximum of eight files can be open at a time.</P>

<P>When you open a file, some of the file's characteristics are placed into a region of memory called a <B>file control block</B>.  Several of these characteristics -- the location in memory of the file's buffer, a pointer to the end of the file (the EOF), and a pointer to the current position in the file (the file's MARK) -- are accessible to system programs via MLI calls, and may be changed while the file is open.</P>

<P>It is important to be aware of the differences between a file on the disk and an open file in memory.  Although some of the file's characteristics and some of its data may be in memory at any given time, the file itself still resides on the disk.  This allows ProDOS to manipulate files that are much larger than the computer's memory capacity.  As a system program writes to the file and changes its characteristics, new data and characteristics are written to the disk.</P>

<P><B>Warning</B> In is crucial that you close all files before turning off the computer or pressing [CONTROL]-[RESET].  This is the only way than you can ensure that all written data has been placed on the disk.  See also the FLUSH call.</P>

<A NAME="2.1.4"></A>

<H3>2.1.4 - The EOF and MARK</H3>

<P>To aid the tasks of reading from and writing to files, each open file has one pointer indicating the end of the file, the EOF, and another defining the current position in the file, the MARK.  Both are moved automatically by ProDOS, but can also be independently moved by the system program.</P>

<P>The EOF is the number of readable bytes in the file.  Since the first byte in a file has number 0, the EOF, when treated as a pointer, points one position past the last character in the file.</P>

<P>When a file is opened, the MARK is set to indicate the first byte in the file.  In is automatically moved forward one byte for each byte written to or read from the file.  The MARK, then, always indicates the next byte to be read from the file, or the next byte position in which to write new data.  It cannot exceed the EOF.</P>

<a name="page14"></a>

<P>If during a write operation the MARK meets the EOF both the MARK and the EOF are moved forward one position for every additional byte written to the file.  Thus, adding bytes to the end of the file automatically advances the EOF to accommodate the new information. Figure 2-2 illustrates the relationship between the MARK and the EOF.</P>

<A NAME="2-2"></A>

<P><B>Figure 2-2.  Automatic Movement of EOF and MARK</B></P>

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

<P>A system program can place the EOF anywhere, from the current MARK position to the maximum possible byte position.  The MARK can be placed anywhere from the first byte in the file to the EOF.  These two functions can be accomplished using the SET_EOF and SET_MARK calls.  The current values of the EOF and the MARK can be determined using the GET_EOF and GET_MARK calls.</P>

<A NAME="2.1.5"></A>

<H3>2.1.5 Reading and Writing Files</H3>

<P>READ and WRITE calls to the MLI transfer data between memory and a file.  For both calls, the system program must specify three things:</P>

<UL>

<LI>The reference number of the file (assigned when the file was opened).</li>

<LI>The location in memory of a buffer (data_buffer) that contains, or is to contain, the transferred data.  Note that this cannot be the same buffer that was specified when the file was opened.</li>

<LI>The number of bytes to be transferred.</li>

</UL>

<P>When the request has been carried out, the MLI passes back to the system program the number of bytes that it actually transferred.</P>

<a name="page15"></a>

<P>A read or write request starts at the current MARK, and continues until the requested number of bytes has been transferred (or, on a read, until the end of file has been reached).  Read requests can also terminate when a specified character is read.  You turn on this feature and set the character(s) on which reads will terminate using the NEWLINE call.  It is typically used for reading lines of text that are terminated by carriage returns.</P>

<P><B>By the Way:</B> Neither a READ nor a WRITE call necessarily causes a disk access.  It is only when a read or write crosses a 512-byte (block) boundary that a disk access occurs.</P>

<A NAME="2.1.6"></A>

<H3>2.1.6 - Closing and Flushing Files</H3>

<P>When you finish reading from or writing to a file, you must use the CLOSE call to close the file.  When you use this call, you specify the reference number of the file (assigned when the file was opened).</p>



<P>CLOSE writes any unwritten data to the file, and it updates the file's size in the directory, if necessary.  Then it frees the 1024-byte io_buffer for other uses and releases the file's reference number.</P>

<P>Information in the file's directory, such as the file's size, is normally updated only when the file is closed.  If you were to press [CONTROL]-[RESET]  (typically halting the current program) while a file is open, data written to the file since it was opened could be lost and the integrity of the disk could be damaged.  This can be prevented by using the FLUSH call.  To use FLUSH you specify the reference number of the file (assigned when the file was opened).</p>



<P>If you press [CONTROL]-[RESET] while an open but flushed file is in memory, there is no loss of data and no damage to the disk. Both the CLOSE and FLUSH calls, when used with a reference number of 0, normally cause all open files to be closed or flushed.  Specific groups of files can be closed or flushed using the <B>system level</B>.</P>

<a name="page16"></a>

<A NAME="2.1.7"></A>

<H3>2.1.7 - File Levels</H3>

<P>When a file is opened, it is assigned a level, according to the value of a specific byte in memory (the system level).  If the system level is never changed, the CLOSE and FLUSH calls, when used with a reference number of 0, cause all open files to be closed or flushed.  But if the level has been changed since the first file was opened, only the files having a file level greater than or equal to the current system level are closed or flushed.</P>

<P>The system level feature is used, for example, by the BASIC system program to implement the EXEC command.  An EXEC file is opened with a level of 0, then the level is set to 7.  A BASIC CLOSE command (intended to close all files opened within the EXEC program) closes all files at or above level 7, but the EXEC file itself remains open.</P>

<A NAME="2.2"></A>

<H2>2.2 - File Organization</H2>

<P>This portion of the chapter describes in general terms the organization of files on a disk.  It does not attempt to teach you everything about file organization: its purpose is to familiarize you with the terms and concepts required by the filing calls.</P>

<P>Appendix B elaborates on the subject of file organization.</P>

<A NAME="2.2.1"></A>

<H3>2.2.1 - Directory Files and Standard Files</H3>

<P>Every ProDOS file is a named, ordered sequence of bytes that can be read from, and to which the rules of MARK and EOF apply.  However, there are two types of files: <B>directory files</B> and <B>standard files</B>. Directory files are special files that describe and point to other files on the disk.  They may be read from, but not written to (except by ProDOS).  All nondirectory files are standard files.  They may be read from and written to.</P>

<P>A directory file contains a number of similar elements, called <B>entries</B>. The first entry in a directory file is the header entry: it holds the name and other properties (such as the number of files stored in that directory) of the directory file.  Each subsequent entry in the file describes and points to some other file on the disk.  Figure 2-3 represents the structure of a directory file.</P>

<a name="page17"></a>

<A NAME="2-3"></A>

<P><B>Figure 2-3.  Directory File Structure</B></P>

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

<P>The files described and pointed to by the entries in a directory file can be standard files or other directory files.</P>

<P>A system program does not need to know the details of directory structure to access files with known names.  Only operations on unknown files (such as listing the files in a directory) require the system program to examine a directory's entries.  For such tasks, refer to Appendix B.</P>

<P>Standard files have no such predefined internal structure: the format of the data depends on the specific file type.</P>

<A NAME="2.2.2"></A>

<H3>2.2.2 - File Structure</H3>

<P>Because directory files are generally smaller than standard files, and because they are sequentially accessed, ProDOS uses a simpler form of storage for directory files.  Both types of files are stored as a set of 512-byte blocks, but the way in which the blocks are arranged on the disk differs.</P>

<P>A directory file is a linked list of blocks: each block in a directory file contains a pointer to the next block in the directory file as well as a pointer to the previous block in the directory.  Figure 2-4 illustrates this structure.</P>

<a name="page18"></a>

<A NAME="2-4"></A>

<P><B>Figure 2-4.  Block Organization of a Directory File</B></P>

<PRE>

 +------------+       +------------+       +------------+
 | Key Block  |&#60;------|            |&#60;-...&#60;-| Last Block |
 |            |------&#62;|            |-&#62;...-&#62;|            |
 |            |       |            |       |            |
 |            |       |            |       |            |
 |            |       |            |       |            |
 +------------+       +------------+       +------------+

</PRE>

<P>Data files, on the other hand, are often quite large, and their contents may be randomly accessed.  It would be very slow to access such large files if they were organized sequentially.  Instead ProDOS stores standard files using a <B>tree structure</B>.  The largest possible standard file has a <B>master index block</B> that points to 128 <B>index blocks</B>.  Each index block points to 256 <B>data blocks</B> and each data block can hold 512 bytes of data.  The block organization of the largest possible standard file is shown in Figure 2-5.</P>

<A NAME="2-5"></A>

<P><B>Figure 2-5.  Block Organization of a Standard File</B></P>

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

<P>Most standard files do not have this exact organization.  ProDOS only writes a subset of this structure to the file, depending on the amount of data written to the file.  This technique produces three distinct forms of standard file: seedling, sapling, and tree files.</P>

<P>Appendix B describes the three forms of standard file.</P>

<a name="page19"></a>

<A NAME="2.2.3"></A>

<H3>2.2.3 - Sparse Files</H3>

<P>In most instances a program writes data sequentially into a file.  By writing data, moving the EOF and MARK, and then writing more data, a program can also write nonsequential data to a file.  For example, a program can open a file, write ten characters of data, and then move the EOF and MARK (thereby making the file bigger) to $3FE0 before writing ten more bytes of data.  The file produced takes up only three blocks on the disk (a total of 1536 bytes), yet over 16,000 bytes can be read from the file.  Such files are known as <B>sparse files</B>.</P>

<BLOCKQUOTE>

<B>Important!</B> The fact that more data can be read from the file than actually resides on the disk can cause a problem.  Suppose that you were trying to copy a sparse file from one disk to another.  If you were to read data from one file and write it to another, the new file would be much larger than the original because data that is not actually on the disk can be read from the file.  Thus if your system program is going to transfer sparse files, you must use the information in <a href="/docs/techref/file-organization/">Appendix B</a> to determine which data segments should be copied, and which should not.
<br /><br />
The ProDOS Filer automatically preserves the structure of sparse files on a copy.

</BLOCKQUOTE>

<a name="page20"></a>


