---
layout:      page
title:       TechRef - Appendix - File Organization
description: ProDOS 8 Technical Reference Manual File Organization
permalink:   /docs/techref/file-organization/
---

<A NAME="B"><H1>Appendix B<br />File Organization</H1></A><a name="page145"></a>

<P>This appendix contains a detailed description of the way that ProDOS<br />
stores files on disks.  For most system program applications, the MLI<br />
insulates you from this level of detail.  However, you must use this<br />
information if you want</P><UL>

<LI>to list the files in a directory

<LI>to copy a sparse file without increasing the file's size

<LI>to compare two sparse files.

</UL>

<P>This appendix first explains the organization of information on<br />
volumes.  Next, it shows the storage of volume directories, directories,<br />
and the various stages of standard files.  Finally it presents a set of<br />
diagrams that summarize all the material in this appendix.  You can<br />
refer to these diagrams as you read the appendix.  They will become<br />
your most valuable tool for working with file organization.</P><A NAME="B.1"><H2>B.1 - Format of Information on a Volume</H2></A><P>When a volume is formatted for use with ProDOS, its surface is<br />
partitioned into an array of tracks and sectors.  In accessing a volume,<br />
ProDOS requests not a track and sector, but a logical block from the<br />
device corresponding to that volume.  That device's driver translates the<br />
requested block number into the proper track and sector number; the<br />
physical location of information on a volume is unimportant to ProDOS<br />
and to a system program that uses ProDOS.  This appendix discusses<br />
the organization of information on a volume in terms of logical blocks,<br />
numbered starting with zero, not tracks and sectors.</P><P>When the volume is formatted, information needed by ProDOS is<br />
placed in specific logical blocks.  A <B>loader program</B> is placed in<br />
blocks 0 and 1 of the volume.  This program enables ProDOS to be<br />
booted from the volume.  Block 2 of the volume is the <B>key block</B> (the<br />
first block) of the <B>volume directory file</B>; it contains descriptions of<br />
(and pointers to) all the files in the volume directory.  The volume<br />
directory occupies a number of consecutive blocks, typically four, and<br />
is immediately followed by the <B>volume bit map</B>, which records<br />
whether each block on the volume is used or unused.  The volume bit<br />
map occupies consecutive blocks, one for every 4,096 blocks, or fraction<br />
thereof, on the volume.  The rest of the blocks on the disk contain<br />
subdirectory file information, standard file information, or are empty.<br />
The first blocks of a volume look something like Figure B-1.</P><a name="page146"></a>

<A NAME="B-1"><P><B>Figure B-1.  Blocks on a Volume</B></P></A><PRE>
 +-----------------------------------&nbsp;&nbsp; ----------------------------------&nbsp;&nbsp; -------------------
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; Block 2&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; Block <I>n</I>&nbsp;&nbsp;&nbsp; |&nbsp; Block <I>n + 1</I>&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; Block <I>p</I>&nbsp;&nbsp;&nbsp; |
 | Block 0 | Block 1 |&nbsp;&nbsp; Volume&nbsp;&nbsp;&nbsp; | ... |&nbsp;&nbsp;&nbsp; Volume&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; Volume&nbsp;&nbsp;&nbsp;&nbsp; | ... |&nbsp;&nbsp;&nbsp; Volume&nbsp;&nbsp;&nbsp;&nbsp; | Other
 | Loader&nbsp; | Loader&nbsp; |&nbsp; Directory&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; Directory&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; Bit Map&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; Bit Map&nbsp;&nbsp;&nbsp; | Files
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | (Key Block) |&nbsp;&nbsp;&nbsp;&nbsp; | (Last Block) | (First Block) |&nbsp;&nbsp;&nbsp;&nbsp; | (Last Block)&nbsp; |
 +-----------------------------------&nbsp;&nbsp; ----------------------------------&nbsp;&nbsp; -------------------
</PRE><P>The precise format of the volume directory, volume bit map,<br />
subdirectory files and standard files are explained in the following<br />
sections.</P><A NAME="B.2"><H2>B.2 - Format of Directory Files</H2></A><P>The format of the information contained in volume directory and<br />
subdirectory files is quite similar.  Each consists of a <B>key block</B><br />
followed by zero or more blocks of additional directory information.  The<br />
fields in a directory's key block are: a pointer to the next block in the<br />
directory; a header entry that describes the directory; a number of file<br />
entries describing, and pointing to, the files in that directory; and zero<br />
or more unused bytes.  The fields in subsequent (non-key) blocks in a<br />
directory are: a number of entries describing, and pointing to, the files<br />
in that directory; and zero or more unused bytes.  The format of a<br />
directory file is represented in Figure B-2.</P><a name="page147"></a>

<A NAME="B-2"><P><B>Figure B-2.  Directory File Format</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           <B>Key Block&nbsp;&nbsp;&nbsp; Any Block&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Last Block</B>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; / +-------+&nbsp;&nbsp;&nbsp; +-------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |&nbsp;&nbsp; 0&nbsp;&nbsp; |&#60;---|Pointer|&#60;--...&#60;--|Pointer|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     <B>Blocks of a directory:</B>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |-------|&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp; Not necessarily contiguous,
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |Pointer|---&#62;|Pointer|--&#62;...--&#62;|&nbsp;&nbsp; 0&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; linked by <B>pointers</B>.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |-------|&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |Header |&nbsp;&nbsp;&nbsp; | Entry |&nbsp;&nbsp; ...&nbsp;&nbsp; | Entry |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |-------|&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     <B>Header</B> describes the
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; | Entry |&nbsp;&nbsp;&nbsp; | Entry |&nbsp;&nbsp; ...&nbsp;&nbsp; | Entry |&nbsp;&nbsp;&nbsp;&nbsp; directory file and its
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |-------|&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp; contents.
&nbsp; One&nbsp; /&nbsp;&nbsp; / More&nbsp; /&nbsp;&nbsp;&nbsp; / More&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; / More&nbsp; /
 Block \&nbsp;&nbsp; /Entries/&nbsp;&nbsp;&nbsp; /Entries/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /Entries/
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |-------|&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     <B>Entry</B> describes
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; | Entry |&nbsp;&nbsp;&nbsp; | Entry |&nbsp;&nbsp; ...&nbsp;&nbsp; | Entry |&nbsp;&nbsp;&nbsp;&nbsp; and points to a file
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |-------|&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp; (subdirectory or
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; | Entry |&nbsp;&nbsp;&nbsp; | Entry |&nbsp;&nbsp; ...&nbsp;&nbsp; | Entry |&nbsp;&nbsp;&nbsp;&nbsp; standard) in that
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |-------|&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-------|&nbsp;&nbsp;&nbsp;&nbsp; directory.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; |Unused |&nbsp;&nbsp;&nbsp; |Unused |&nbsp;&nbsp; ...&nbsp;&nbsp; |Unused |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \ +-------+&nbsp;&nbsp;&nbsp; +-------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------+
</PRE><P>The header entry is the same length as all other entries.  The only<br />
organizational difference between a volume directory file and a<br />
subdirectory file is in the header.</P><P>See the sections "Volume Directory<br />
Headers" and "Subdirectory Headers."</P><A NAME="B.2.1"><H2>B.2.1 Pointer Fields</H2></A><P>The first four bytes of each block used by a directory file contain<br />
pointers to the preceding and succeeding blocks in the directory file,<br />
respectively.  Each pointer is a two-byte logical block number, low byte<br />
first, high byte second.  The key block of a directory file has no<br />
preceding block: its first pointer is zero.  Likewise, the last block in a<br />
directory file has no successor: its second pointer is zero.</P><P><B>By the Way:</B> All block pointers used by ProDOS have the same format:<br />
low byte first, high byte second.</P><A NAME="B.2.2"><H3>B.2.2 - Volume Directory Headers</H3></A><P>Block 2 of a volume is the key block of that volume's directory file.<br />
The volume directory header is at byte position $0004 of the key block,<br />
immediately following the block's two pointers.  Thirteen fields are<br />
currently defined to be in a volume directory header: they contain all<br />
the vital information about that volume.  Figure B-3 illustrates the<br />
structure of a volume directory header.  Following Figure B-3 is a<br />
description of each of its fields.</P><a name="page148"></a>

<A NAME="B-3"><P><B>Figure B-3.  The Volume Directory Header</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
    <B>Field&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte of
&nbsp;&nbsp; Length&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Block</B>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------+
&nbsp; 1 byte&nbsp; | storage_type | name_length | $04
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $05
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;15 bytes /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $13
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $14
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
&nbsp; 8 bytes /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; reserved&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1B
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1C
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; creation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1D
&nbsp; 4 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; date &#38; time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1D
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1F
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; version&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $20
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; min_version&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $21
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $22
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; entry_length&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $23
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; entries_per_block&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $24
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $25
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_count&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $26
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $27
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bit_map_pointer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $28
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $29
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; total_blocks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $2A
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------+
</PRE><a name="page149"></a>

<P><B>storage_type</B> and <B>name_length</B> (1 byte): Two four-bit fields are<br />
packed into this byte.  A value of $F in the high four bits (the<br />
storage_type) identifies the current block as the key block of a volume<br />
directory file.  The low four bits contain the length of the volume's<br />
name (see the file_name field, below).  The name_length can be<br />
changed by a RENAME call.</P><P><B>file_name</B> (15 bytes): The first n bytes of this field, where n is<br />
specified by name_length, contain the volume's name.  This name must<br />
conform to the filename (volume name) syntax explained in Chapter 2.<br />
The name does not begin with the slash that usually precedes volume<br />
names.  This field can be changed by the RENAME call.</P><P>reserved (8 bytes): Reserved for future expansion of the file system.</P><P><B>creation</B> (4 bytes): The date and time at which this volume was<br />
initialized.  The format of these bytes is described in Section B.4.2.2.</P><P><B>version</B> (1 byte): The version number of ProDOS under which this<br />
volume was initialized.  This byte allows newer versions of ProDOS to<br />
determine the format of the volume, and adjust their directory<br />
interpretation to conform to older volume formats.  In ProDOS 1.0,<br />
version = 0.</P><P><B>min_version</B>: Reserved for future use.  In ProDOS 1.0, it is 0.</P><P><B>access</B> (1 byte): Determines whether this volume directory can be read<br />
written, destroyed, and renamed.  The format of this field is described<br />
in Section B.4.2.3.</P><P><B>entry_length</B> (1 byte): The length in bytes of each entry in this<br />
directory.  The volume directory header itself is of this length.<br />
entry_length = $27.</P><P><B>entries_per_block</B> (1 byte): The number of entries that are stored in<br />
each block of the directory file.  entries_per_block = $0D.</P><P><B>file_count</B> (2 bytes): The number of active file entries in this<br />
directory file.  An active file is one whose storage_type is not 0.  See<br />
Section B.2.4 for a description of file entries.</P><P><B>bit_map_pointer</B> (2 bytes): The block address of the first block of<br />
the volume's bit map.  The bit map occupies consecutive blocks, one for<br />
every 4,096 blocks (or fraction thereof) on the volume.  You can<br />
calculate the number of blocks in the bit map using the total_blocks<br />
field, described below.</P><a name="page150"></a>

<P>The bit map has one bit for each block on the volume: a value of 1<br />
means the block is free; 0 means it is in use.  If the number of blocks<br />
used by all files on the volume is not the same as the number<br />
recorded in the bit map, the directory structure of the volume has been<br />
damaged.</P><P><B>total_blocks</B> (2 bytes): The total number of blocks on the volume.</P><A NAME="B.2.3"><H3>B.2.3 - Subdirectory Headers</H3></A><P>The key block of every subdirectory file is pointed to by an entry in a<br />
parent directory; for example, by an entry in a volume directory<br />
(explained in Section B.2).  A subdirectory's header begins at byte<br />
position $0004 of the key block of that subdirectory file, immediately<br />
following the two pointers.</P><P>Its internal structure is quite similar to that of a volume directory<br />
header.  Fourteen fields are currently defined to be in a subdirectory.<br />
Figure B-4 illustrates the structure of a subdirectory header.  A<br />
description of all the fields in a subdirectory header follows Figure B-4.</P><a name="page151"></a>

<A NAME="B-4"><P><B>Figure B-4.  The Subdirectory Header</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
    <B>Field&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte of
&nbsp;&nbsp; Length&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Block</B>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------+
&nbsp; 1 byte&nbsp; | storage_type | name_length | $04
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $05
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
 15 bytes /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $13
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $14
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
&nbsp; 8 bytes /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; reserved&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1B
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1C
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; creation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1D
&nbsp; 4 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; date &#38; time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1D
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1F
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; version&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $20
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; min_version&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $21
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $22
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; entry_length&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $23
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; entries_per_block&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $24
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $25
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_count&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $26
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $27
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; parent_pointer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $28
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp; parent_entry_number&nbsp;&nbsp;&nbsp;&nbsp; | $29
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp; parent_entry_length&nbsp;&nbsp;&nbsp;&nbsp; | $2A
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------+
</PRE><a name="page152"></a>

<P><B>storage_type</B> and <B>name_length</B> (1 byte): Two four-bit fields are<br />
packed into this byte.  A value of $E in the high four bits (the<br />
storage_type) identifies the current block as the key block of a<br />
subdirectory file.  The low four bits contain the length of the<br />
subdirectory's name (see the file_name field, below).  The<br />
name_length can be changed by a RENAME call.</P><P><B>file_name</B> (15 bytes): The first name_length bytes of this field<br />
contain the subdirectory's name.  This name must conform to the<br />
filename syntax explained in Chapter 2.  This field can be changed by<br />
the RENAME call.</P><P><B>reserved</B> (8 bytes): Reserved for future expansion of the file system.</P><P><B>creation</B> (4 bytes): The date and time at which this subdirectory was<br />
created.  The format of these bytes is described in Section B.4.2.2.</P><P><B>version</B> (1 byte): The version number of ProDOS under which this<br />
subdirectory was created.  This byte allows newer versions of ProDOS<br />
to determine the format of the subdirectory, and to adjust their<br />
directory interpretations accordingly.  ProDOS 1.0: version = 0.</P><P><B>min_version</B> (1 byte): The minimum version number of ProDOS that<br />
can access the information in this subdirectory.  This byte allows older<br />
versions of ProDOS to determine whether they can access newer<br />
subdirectories.  min_version = 0.</P><P><B>access</B> (1 byte): Determines whether this subdirectory can be read,<br />
written, destroyed, and renamed, and whether the file needs to be<br />
backed up.  The format of this field is described in Section B.4.2.3.  A<br />
subdirectory's access byte can be changed by the SET_FILE_INFO<br />
call.</P><P><B>entry_length</B> (1 byte): The length in bytes of each entry in this<br />
subdirectory.  The subdirectory header itself is of this length.<br />
entry_length = $27.</P><P><B>entries_per_block</B> (1 byte): The number of entries that are stored in<br />
each block of the directory file.  entries_per_block = $0D.</P><P><B>file_count</B> (2 bytes): The number of active file entries in this<br />
subdirectory file.  An active file is one whose storage_type is not 0.  See<br />
Section "File Entries" for more information about file entries.</P><P><B>parent_pointer</B> (2 bytes): The block address of the directory file block<br />
that contains the entry for this subdirectory.  This two-byte pointer is<br />
stored low byte first, high byte second.</P><a name="page153"></a>

<P><B>parent_entry_number</B> (1 byte): The entry number for this<br />
subdirectory within the block indicated by parent_pointer.</P><P><B>parent_entry_length</B> (1 byte): The entry_length for the directory<br />
that owns this subdirectory file.  Note that with these last three fields<br />
you can calculate the precise position on a volume of this<br />
subdirectory's file entry.  parent_entry_length = $27.</P><A NAME="B.2.4"><H3>B.2.4 - File Entries</H3></A><P>Immediately following the pointers in any block of a directory file are<br />
a number of entries.  The first entry in the key block of a directory file<br />
is a header; all other entries are file entries.  Each entry has the length<br />
specified by that directory's entry_length field, and each file entry<br />
contains information that describes, and points to, a single subdirectory<br />
file or standard file.</P><P>An entry in a directory file may be active or inactive; that is, it may<br />
or may not describe a file currently in the directory.  If it is inactive,<br />
the first byte of the entry (storage_type and name_length) has the<br />
value zero.</P><P>The maximum number of entries, including the header, in a block of a<br />
directory is recorded in the entries_per_block field of that directory's<br />
header.  The total number of active file entries, not including the<br />
header, is recorded in the file_count field of that directory's header.</P><P>Figure B-5 describes the format of a file entry.</P><a name="page154"></a>

<A NAME="B-5"><P><B>Figure B-5.  The File Entry</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;
    <B>Field&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Entry
&nbsp;&nbsp; Length&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Offset</B>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------+
&nbsp; 1 byte&nbsp; | storage_type | name_length | $00
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $01
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
 15 bytes /&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $0F
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $10
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $11
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; key_pointer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $12
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $13
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; blocks_used&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $14
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $15
&nbsp; 3 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EOF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $17
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $18
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; creation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp; 4 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; date &#38; time&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1B
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; version&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1C
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; min_version&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1D
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp; 1 byte&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1E
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $1F
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; aux_type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $20
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $21
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp; 4 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; last mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $24
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |----------------------------|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $25
&nbsp; 2 bytes |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; header_pointer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | $26
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------+
</PRE><a name="page155"></a>

<P><B>storage_type</B> and <B>name_length</B> (1 byte): Two four-bit fields are<br />
packed into this byte.  The value in the high-order four bits (the<br />
storage_type) specifies the type of file pointed to by this file entry:</P><P>$1 = Seeding file<br />
$2 = Sapling file<br />
$3 = Tree file<br />
$4 = Pascal area<br />
$D = Subdirectory</P><P>Seedling, sapling, and tree files, the three forms of a standard file, are<br />
described in Section B.3.  The low four bits contain the length of the<br />
file's name (see the file_name field, below).  The name_length can be<br />
changed by a RENAME call.</P><P><B>file_name</B> (15 bytes): The first name_length bytes of this field<br />
contain the file's name.  This name must conform to the filename<br />
syntax explained in Chapter 2.  This field can be changed by the<br />
RENAME call.</P><P><B>file_type</B> (1 byte): A descriptor of the internal structure of the file.<br />
Section B.4.2.4 contains a list of the currently defined values of this<br />
byte.</P><P><B>key_pointer</B> (2 bytes): The block address of the master index block if<br />
a tree file, of the index block if a sapling file, and of the block if a<br />
seedling file.</P><P><B>blocks_used</B> (2 bytes): The total number of blocks actually used by<br />
the file.  For a subdirectory file, this includes the blocks containing<br />
subdirectory information, but not the blocks in the files pointed to.  For<br />
a standard file, this includes both informational blocks (index blocks)<br />
and data blocks.  Refer to Section B.3 for more information on standard<br />
files.</P><P><B>EOF</B> (3 bytes): A three-byte integer, lowest bytes first, that represents<br />
the total number of bytes readable from the file.  Note that in the case<br />
of sparse files, described in Section B.3.6, EOF may be greater than the<br />
number of bytes actually allocated on the disk.</P><P><B>creation</B> (4 bytes): The date and time at which the file pointed to by<br />
this entry was created.  The format of these bytes is described in<br />
Section B.4.2.2.</P><P><B>version</B> (1 byte): The version number of ProDOS under which the file<br />
pointed to by this entry was created.  This byte allows newer versions<br />
of ProDOS to determine the format of the file, and adjust their<br />
interpretation processes accordingly.  In ProDOS 1.0, version = 0.</P><a name="page156"></a>

<P><B>min_version</B> (1 byte): The minimum version number of ProDOS that<br />
can access the information in this file.  This byte allows older versions<br />
of ProDOS to determine whether they can access newer files.  In<br />
ProDOS 1.0, min_version = 0.</P><P><B>access</B> (1 byte): Determines whether this file can be read, written,<br />
destroyed, and renamed, and whether the file needs to be backed up.<br />
The format of this field is described in Section B.4.2.3.  The value of<br />
this field can be changed by the SET_FILE_INFO call.  You cannot<br />
delete a subdirectory that contains any files.</P><P><B>aux_type</B> (2 bytes): A general-purpose field in which a system<br />
program can store additional information about the internal format of a<br />
file.  For example, the ProDOS BASIC system program uses this field to<br />
record the load address of a BASIC program or binary file, or the<br />
record length of a text file.</P><P><B>last_mod</B> (4 bytes): The date and time that the last CLOSE operation<br />
after a WRITE was performed on this file.  The format of these bytes is<br />
described in Section B.4.2.2.  This field can be changed by the<br />
SET_FILE_INFO call.</P><P><B>header_pointer</B> (2 bytes): This field is the block address of the key<br />
block of the directory that owns this file entry.  This two-byte pointer is<br />
stored low byte first, high byte second.</P><A NAME="B.2.5"><H3>B.2.5 - Reading a Directory File</H3></A><P>This section deals with the techniques of reading from directory files,<br />
not with the specifics.  The ProDOS calls with which these techniques<br />
can be implemented are explained in Chapter 4.</P><P>Before you can read from a directory, you must know the directory's<br />
pathname.  With the directory's pathname, you can open the directory<br />
file, and obtain a reference number (<B><TT>RefNum</TT></B>) for that open file.<br />
Before you can process the entries in the directory, you must read<br />
three values from the directory header:</P><UL>

<LI>the length of each entry in the directory (entry_length)

<LI>the number of entries in each block of the directory<br />
(entries_per_block)

<LI>the total number of files in the directory (file_count).

</UL>

<a name="page157"></a>

<P>Using the reference number to identify the file, read the first 512 bytes<br />
from the file, and into a buffer (<B><TT>ThisBlock</TT></B>).  The buffer contains<br />
two two-byte pointers, followed by the entries; the first entry is the<br />
directory header.  The three values are at positions $1F through $22 in<br />
the header (positions $23 through $26 in the buffer).  In the example<br />
below, these values are assigned to the variables <B><TT>EntryLength</TT></B>,<br />
<B><TT>EntriesPerBlock</TT></B>, and <B><TT>FileCount</TT></B>.</P><PRE>
 Open(DirPathname, Refnum);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {Get reference number&nbsp;&nbsp;&nbsp; }
 ThisBlock&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; := Read512Bytes(RefNum); {Read a block into buffer}
 EntryLength&nbsp;&nbsp;&nbsp;&nbsp; := ThisBlock[$23];&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {Get directory info&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }
 EntriesPerBlock := ThisBlock[$24];
 FileCount&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; := ThisBlock[$25] + (256 * ThisBlock[$26]);
</PRE><P>Once these values are known, a system program can scan through the<br />
entries in the buffer, using a pointer to the beginning of the current<br />
entry <B><TT>EntryPointer</TT></B>, a counter <B><TT>BlockEntries</TT></B> that<br />
indicates the number of entries that have been examined in the<br />
current block, and a second counter <B><TT>ActiveEntries</TT></B> that<br />
indicates the number of active entries that have been processed.</P><P>An entry is active and is processed only if its first byte, the<br />
storage_type and name_length, is nonzero.  All entries have been<br />
processed when <B><TT>ActiveEntries</TT></B> is equal to <B><TT>FileCount</TT></B>.  If<br />
all the entries in the buffer have been processed, and<br />
<B><TT>ActiveEntries</TT></B> doesn't equal <B><TT>FileCount</TT></B>, then the next<br />
block of the directory is read into the buffer.</P><PRE>
 EntryPoint&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; := EntryLength + $04;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {Skip header entry}
 BlockEntries&nbsp;&nbsp;&nbsp; := $02;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {Prepare to process entry two}
 ActiveEntries&nbsp;&nbsp; := $00;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {No active entries found yet }

 while ActiveEntries &#60; FileCount do begin
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ThisBlock[EntryPointer] &#60;&#62; $00 then begin&nbsp; {Active entry}
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ProcessEntry(ThisBlock[EntryPointer]);
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ActiveEntries := ActiveEntries + $01
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; end;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ActiveEntries &#60; FileCount then&nbsp; {More entries to process}
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if BlockEntries = EntriesPerBlock
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; then begin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {ThisBlock done. Do next one}
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ThisBlock&nbsp;&nbsp;&nbsp; := Read512Bytes(RefNum);
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BlockEntries := $01;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EntryPointer := $04
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; end
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else begin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {Do next entry in ThisBlock }
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EntryPointer := EntryPointer + EntryLength;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BlockEntries := BlockEntries + $01
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; end
 end;
 Close(RefNum);
</PRE><a name="page158"></a>

<P>This algorithm processes entries until all expected active entries have<br />
been found.  If the directory structure is damaged, and the end of the<br />
directory file is reached before the proper number of active entries has<br />
been found, the algorithm fails.</P><A NAME="B.3"><H2>B.3 - Format of Standard Files</H2></A><P>Each active entry in a directory file points to the key block (the first<br />
block) of a file.  As shown below, the key block of a standard file may<br />
have several types of information in it.  The storage_type field in that<br />
file's entry must be used to determine the contents of the key block.<br />
This section explains the structure of the three stages of standard file:<br />
seedling, sapling, and tree.  These are the files in which all programs<br />
and data are stored.</P><A NAME="B.3.1"><H3>B.3.1 - Growing a Tree File</H3></A><P>The following scenario demonstrates the <I>growth</I> of a tree file on a<br />
volume.  This scenario is based on the block allocation scheme used by<br />
ProDOS 1.0 on a 280-block flexible disk that contains four blocks of<br />
volume directory, and one block of volume bit map.  Larger capacity<br />
volumes might have more blocks in the volume bit map, but the<br />
process would be identical.</P><P>A formatted, but otherwise empty, ProDOS volume is used like this:</P><P>Blocks 0-1 - Loader<br />
Blocks 2-5 - Volume directory<br />
Block 6 - Volume bit map<br />
Blocks 7-279 - Unused</P><a name="page159"></a>

<P>If you open a new file of a nondirectory type, one data block is<br />
immediately allocated to that file.  An entry is placed in the volume<br />
directory, and it points to block 7, the new data block, as the key<br />
block for the file.  The key block is indicated below by an arrow.</P><P>The volume now looks like this:</P><PRE>
 Data Block 0
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 0-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Loader
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 2-5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Volume directory
&nbsp;&nbsp;&nbsp;&nbsp; Block 6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Volume bit map
 --&#62; Block 7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data block 0
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 8-279&nbsp;&nbsp;&nbsp; Unused
</PRE><P>This is a <B>seedling file</B>: its key block contains up to 512 bytes of data.<br />
If you write more than 512 bytes of data to the file, the file <I>grows</I><br />
into a <B>sapling file</B>.  As soon as a second block of data becomes<br />
necessary, an <B>index block</B> is allocated, and it becomes the file's key<br />
block: this index block can point to up to 256 data blocks (two-byte<br />
pointers).  A second data block (for the data that won't fit in the first<br />
data block) is also allocated.  The volume now looks like this:</P><PRE>
 Index Block 0
 Data Block 0
 Data Block 1
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 0-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Loader
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 2-5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Volume directory
&nbsp;&nbsp;&nbsp;&nbsp; Block 6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Volume bit map
&nbsp;&nbsp;&nbsp;&nbsp; Block 7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data block 0
 --&#62; Block 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Index block 0
&nbsp;&nbsp;&nbsp;&nbsp; Block 9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data block 1
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 10-279&nbsp;&nbsp; Unused
</PRE><P>This sapling file can hold up to 256 data blocks: 128K of data.  If the<br />
file becomes any bigger than this, the file <I>grows</I> again, this time into a<br />
<B>tree file</B>.  A <B>master index block</B> is allocated, and it becomes the file's<br />
key block: the master index block can point to up to 128 index blocks<br />
and each of these can point to up to 256 data blocks.  Index block G<br />
becomes the first index block pointed to by the master index block.  In<br />
addition, a new index block is allocated, and a new data block to<br />
which it points.</P><a name="page160"></a>

<P>Here's a new picture of the volume:</P><PRE>
 Master Index Block
 Index Block 0
 Index Block 1
 Data Block 0
 Data Block 255
 Data Block 256
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 0-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Loader
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 2-5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Volume directory
&nbsp;&nbsp;&nbsp;&nbsp; Block 6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Volume bit map
&nbsp;&nbsp;&nbsp;&nbsp; Block 7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data block 0
&nbsp;&nbsp;&nbsp;&nbsp; Block 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Index block 0
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 9-263&nbsp;&nbsp;&nbsp; Data blocks 1-255
 --&#62; Block 264&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Master index block
&nbsp;&nbsp;&nbsp;&nbsp; Block 265&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Index block 1
&nbsp;&nbsp;&nbsp;&nbsp; Block 266&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Data block 256
&nbsp;&nbsp;&nbsp;&nbsp; Blocks 267-279&nbsp; Unused
</PRE><P>As data is written to this file, additional data blocks and index blocks<br />
are allocated as needed, up to a maximum of 129 index blocks (one a<br />
master index block), and 32,768 data blocks, for a maximum capacity<br />
of 16,777,215 bytes of data in a file.  If you did the multiplication, you<br />
probably noticed that a byte was lost somewhere.  The last byte of the<br />
last block of the largest possible file cannot be used because <B>EOF</B><br />
cannot exceed 16,777,216.  If you are wondering how such a large file<br />
might fit on a small volume such as a flexible disk, refer to<br />
Section B.3.6 on sparse files.</P><P>This scenario shows the growth of a single file on an otherwise empty<br />
volume.  The process is a bit more confusing when several files are<br />
growing -- or being deleted -- simultaneously.  However, the block<br />
allocation scheme is always the same: when a new block is needed<br />
ProDOS always allocates the first unused block in the volume bit map.</P><A NAME="B.3.2"><H3>B.3.2 Seedling Files</H3></A><P>A <B>seedling file</B> is a standard file that contains no more than 512 data<br />
bytes ($0 &#60;= <B>EOF</B> &#60;= $200).  This file is stored as one block on the<br />
volume, and this data block is the file's key block.</P><P>The structure of such a seedling file appears in Figure B-6.</P><a name="page161"></a>

<A NAME="B-6"><P><B>Figure B-6.  Structure of a Seedling File</B></P></A><PRE>
 key_pointer ----&#62; +-------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Data&nbsp; | Data Block
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Block | 512 bytes long
 $0 &#60;= EOF &#60;= $200 +-------+
</PRE><P>The file is called a seedling file because, if more than 512 data bytes<br />
are written to it, it grows into a sapling file, and thence into a tree<br />
file.</P><P>The <B>storage_type</B> field of an entry that points to a seedling file has<br />
the value $1.</P><A NAME="B.3.3"><H3>B.3.3 - Sapling Files</H3></A><P>A <B>sapling file</B> is a standard file that contains more than 512 and no<br />
more than 128K bytes ($200 &#60; <B>EOF</B> &#60;= $20000).  A sapling file<br />
comprises an index block and 1 to 256 data blocks.  The index block<br />
contains the block addresses of the data blocks.  See Figure B-7.</P><A NAME="B-7"><P><B>Figure B-7.  Structure of a Sapling File</B></P></A><PRE>
 key_pointer ------&#62; +-------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; | Index Block:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |$00 $01&nbsp;&nbsp;&nbsp;&nbsp; $FE $FF| Up to 256 2-Byte
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |-&nbsp;&nbsp; Index Block&nbsp;&nbsp; -| Pointers to Data Blocks
 $0 &#60;= EOF &#60;= $20000 |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +---------------+&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; +-------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +---+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v
 +-----------+&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-----------+&nbsp;&nbsp; +-----------+
 |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; | ..... |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; |
 | Block $00 |&nbsp;&nbsp; | Block $01 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Block $FE |&nbsp;&nbsp; | Block $FF |
 +-----------+&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-----------+&nbsp;&nbsp; +-----------+
</PRE><P>The key block of a sapling file is its index block.  ProDOS retrieves<br />
data blocks in the file by first retrieving their addresses in the index<br />
block.</P><P>The <B>storage_type</B> field of an entry that points to a sapling file has<br />
the value $2.</P><a name="page162"></a>

<A NAME="B.3.4"><H3>B.3.4 - Tree Files</H3></A><P>A <B>tree file</B> contains more than 128K bytes, and less than 16M bytes<br />
($20000 &#60; <B>EOF</B> &#60; $1000000).  A tree file consists of a master index<br />
block, 1 to 128 index blocks, and 1 to 32,768 data blocks.  The master<br />
index block contains the addresses of the index blocks, and each index<br />
block contains the addresses of up to 256 data blocks.  The structure of<br />
a tree file is shown in Figure B-8.</P><A NAME="B-8"><P><B>Figure B-8.  The Structure of a Tree File</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; key_pointer ------&#62; +----------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; | Master Index Block:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |- Master Index Block -| Up to 128 2-Byte Pointers
 $20000 &#60; EOF &#60; $10000000 |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; | to Index Blocks
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +------------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------------------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |- Index Block $00 -| ....... |- Index Block $7F -|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------------------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp; +---------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ++&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ++
&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp; v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v
&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp; +-----------+
&nbsp;&nbsp; |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; | .... |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; | ... |&nbsp;&nbsp; Data&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp; | Block $00 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Block $FF |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Block $00 |&nbsp;&nbsp;&nbsp;&nbsp; | Block $FF |
&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-----------+&nbsp;&nbsp;&nbsp;&nbsp; +-----------+
</PRE><P>The key block of a tree file is the master index block.  By looking at<br />
the master index block, ProDOS can find the addresses of all the index<br />
blocks; by looking at those blocks, it can find the addresses of all the<br />
data blocks.</P><P>The <B>storage_type</B> field of an entry that points to a tree file has the<br />
value $3.</P><A NAME="B.3.5"><H3>B.3.5 - Using Standard Files</H3></A><P>A system program or application program operates the same on all<br />
three types of standard files, although the <B>storage_type</B> in the file's<br />
entry can be used to distinguish between the three.  A program rarely<br />
reads index blocks or allocates blocks on a volume: ProDOS does that.<br />
The program need only be concerned with the data stored in the file,<br />
not with how they are stored.</P><P>All types of standard files are read as a sequence of bytes, numbered<br />
from 0 to <B>EOF</B>-1, as explained in Chapter 4.</P><a name="page163"></a>

<A NAME="B.3.6"><H3>B.3.6 - Sparse Files</H3></A><P>A <B>sparse file</B> is a sapling or tree file in which the number of data<br />
bytes that can be read from the file exceeds the number of bytes<br />
physically stored in the data blocks allocated to the file.  ProDOS<br />
implements sparse files by allocating only those data blocks that have<br />
had data written to them, as well as the index blocks needed to point<br />
to them.</P><P>For example, you can define a file whose <B>EOF</B> is 16K, that uses only<br />
three blocks on the volume, and that has only four bytes of data<br />
written to it.  If you create a file with an  <B>EOF</B> of $0, ProDOS allocates<br />
only the key block (a data block) for a seedling file, and fills it with<br />
null characters (ASCII $00).</P><P>If you then set the <B>EOF</B> and <B>MARK</B> to position $0565, and write four<br />
bytes, ProDOS calculates that position $0565 is byte $0165<br />
($0564-($0200*2)) of the third block (block $2) of the file.  It then<br />
allocates an index block, stores the address of the current data block<br />
in position 0 of the index block, allocates another data block, stores the<br />
address of that data block in position 2 of the index block, and stores<br />
the data in bytes $0165 through $0168 of that data block.  The <B>EOF</B><br />
is $0569.</P><P>If you now set the <B>EOF</B> to $4000 and close the file, you have a<br />
16K file that takes up three blocks of space on the volume: two data<br />
blocks and an index block.  You can read 16384 bytes of data from the<br />
file, but all the bytes before $0565 and after $0568 are nulls.<br />
Figure B-9 shows how the file is organized.</P><a name="page164"></a>

<A NAME="B-9"><P><B>Figure B-9.  A Sparse File</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 1 2
 key_pointer --&#62; +--------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Key_Block | | | |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +--------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +---------+&nbsp;&nbsp; +-------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EOF = $4000
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; v Block $0&nbsp;&nbsp; Block $1 v Block $2&nbsp;&nbsp; Block $3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Block $1F v
&nbsp;&nbsp; Data +-------------------------------------------+&nbsp;&nbsp; +-----------+
 Blocks |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; | |&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------------------------------------------+&nbsp;&nbsp; +-----------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $1FF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $400&nbsp;&nbsp;&nbsp; ^&nbsp; $5FF
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bytes $565..$568
</PRE><P>Thus ProDOS allocates volume space only for those blocks in a file<br />
that actually contain data.  For tree files, the situation is similar: if<br />
none of the 256 data blocks assigned to an index block in a tree file<br />
have been allocated, the index block itself is not allocated.</P><P>On the other hand, if you CREATE a file with an <B>EOF</B> of $4000<br />
(making it 16K bytes, or 32 blocks, long), ProDOS allocates an index<br />
block and 32 data blocks for a sapling file, and fills the data blocks<br />
with nulls.</P><P><B>By the Way:</B> The first data block of a standard file, be it a seedling,<br />
sapling, or tree file, is always allocated.  Thus there is always a data<br />
block to be read in when the file is opened.</P><a name="page165"></a>

<A NAME="B.3.7"><H3>B.3.7 - Locating a Byte in a File</H3></A><P>The algorithm for finding a specific byte within a standard file is given<br />
below.</P><P>The MARK is a three-byte value that indicates an absolute byte<br />
position within a file.</P><PRE>
 Byte #&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 0

 bit #&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 MARK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |Index Number |Data Block Number|&nbsp;&nbsp; Byte of Block&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 Used by:&nbsp;&nbsp;&nbsp; Tree only&nbsp;&nbsp;&nbsp; Tree and sapling&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All three
</PRE><P>If the file is a tree file, then the high seven bits of the MARK<br />
determine the number (0 to 127) of the index block that points to the<br />
byte.  The value of the seven bits indicate the location of the low byte<br />
of the index block address within the master index block.  The location<br />
of the high byte of the index block address is indicated by the value of<br />
these seven bits plus 256.</P><a name="page166"></a>

<P>If the file is a tree file or a sapling file, then the next eight bits of the<br />
MARK determine the number (0-255) of the data block pointed to by<br />
the indicated index block.  This 8-bit value indicates the location of the<br />
low byte of the data block address within the index block.  The high<br />
byte of the index block address is found at this offset plus 256.</P><P>For tree, sapling, and seedling files, the low nine bits of the MARK are<br />
the absolute position of the byte within the selected data block.</P><A NAME="B.4"><H2>B.4 - Disk Organization</H2></A><P>Figure B-10 presents an overall view of block organization on a volume.<br />
Figure B-11 shows the complete structures of the three standard files<br />
types.  Figure B-12 is a summary of header and entry field information.</P><a name="page167"></a>

<A NAME="B-10"><P><B>Figure B-10.  Disk Organization</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +--------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | BLOCKS ON A VOLUME |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; Figure B-1&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +--------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vv
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; BLOCKS OF A DIRECTORY FILE&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |=================| VOLUME DIRECTORY OR SUBDIRECTORY |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Figure B-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |============================|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vv
 +----------------------+&nbsp;&nbsp;&nbsp; +----------------------+&nbsp;&nbsp;&nbsp; +------------------------------------+
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; HEADER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; HEADER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FILE ENTRY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 |&nbsp;&nbsp; VOLUME DIRECTORY&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; SUBDIRECTORY&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SUBDIRECTORY OR&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 |&nbsp; Found in key block&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp; Found in key block&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STANDARD FILE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |===&#62;&#62;to Figure B-11
 | of volume directory. |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; of subdirectory.&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; | Found in any directory file block. |
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Figure B-3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Figure B-4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Figure B-5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 +----------------------+&nbsp;&nbsp;&nbsp; +----------------------+&nbsp;&nbsp;&nbsp; +------------------------------------+
</PRE><a name="page168"></a>

<A NAME="B.4.1"><H3>B.4.1 - Standard Files</H3></A><A NAME="B-11"><P><B>Figure B-11.  Standard Files</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +---------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |===&#62;&#62;|&nbsp;&nbsp; KEY BLOCK&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; | Standard File |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; +---------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |===&#62;&#62;| SEEDLING FILE: storage_type = $1 |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Figure B-6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |===&#62;&#62;| SAPLING FILE: storage_type = $2&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Figure B-7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |===&#62;&#62;| TREE FILE: storage_type = $3&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Figure B-8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||&nbsp;&nbsp;&nbsp; +----------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ||
 ======|
 from Figure B-10
</PRE><a name="page169"></a>

<A NAME="B.4.2"><H3>B.4.2 - Header and Entry Fields</H3></A><A NAME="B-12"><P><B>Figure B-12.  Header and Entry Fields</B></P></A><PRE>
 +-------------+
 | CREATE_DATE |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 0
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | MOD_DATE&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 6&nbsp;&nbsp; 5&nbsp;&nbsp; 4&nbsp;&nbsp; 3&nbsp;&nbsp; 2&nbsp;&nbsp; 1&nbsp;&nbsp; 0 | 7&nbsp;&nbsp; 6&nbsp;&nbsp; 5&nbsp;&nbsp; 4&nbsp;&nbsp; 3&nbsp;&nbsp; 2&nbsp;&nbsp; 1&nbsp;&nbsp; 0
 +-------------+ ----> +---------------------------------------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Year&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; Month&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Day&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +---------------------------------------------------------------+
 +-------------+
 | CREATE_TIME |
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 | MOD_TIME&nbsp;&nbsp;&nbsp; |
 +-------------+ ----> +---------------------------------------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 0&nbsp;&nbsp; 0&nbsp;&nbsp; 0 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Hour&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 0&nbsp;&nbsp; 0 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Minute&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +---------------------------------------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 0




&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------- Write-Enable
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; +---- Read-Enable
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |
 +--------------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------+&nbsp;&nbsp; +-------------------------------+
 | storage_type |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; access&nbsp; | = | D | RN | B | Reserved | W | R |
 |&nbsp;&nbsp; (4 bits)&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | (1 byte) |&nbsp;&nbsp; +-------------------------------+
 +--------------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +----------+&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; +----------------------- Backup
 $0 = inactive file entry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; +---------------------------- Rename-Enable
 $1 = seedling file entry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------------------------------- Destroy-Enable
 $2 = sapling file entry
 $3 = tree file entry
 $D = subdirectory file entry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; name_length = length of file_name ($1-$F)
 $E = subdirectory header&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_name = $1-$F ASCII characters: first = letters
 $F = volume directory header&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rest are letters, digits, periods.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; key_pointer = block address of file's key block
 +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; blocks_used = total blocks for file
 | file_type |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; EOF = byte number for end of file ($0-$FFFFFF)
 | (1 byte)&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; version, min_version = 0 for ProDOS 1.0
 +-----------+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; entry_length = $27 for ProDOS 1.0
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; entries_per_block = $0D for ProDOS 1.0
 See section B.4.2.4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; aux_type = defined by system program
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; file_count = total files in directory
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bit_map_pointer = block address of bit map
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; total_blocks = total blocks on volume
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; parent_pointer = block address containing entry
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; parent_entry_number = number in that block
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; parent_entry_length = $27 for ProDOS 1.0
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; header pointer = block address of key block
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; of entry's directory
</PRE><a name="page170"></a>

<A NAME="B.4.2.1"><H4>B.4.2.1 - The storage_type Attribute</H4></A><P>The storage_type, the high-order four bits of the first byte of an entry,<br />
defines the type of header (if the entry is a header) or the type of file<br />
described by the entry.</P><P>$0 indicates an inactive file entry<br />
$1 indicates a seedling file entry (EOF &#60;= 256 bytes)<br />
$2 indicates a sapling file entry (256 &#60; EOF &#60;= 128K bytes)<br />
$3 indicates a tree file entry (128K &#60; EOF &#60; 16M bytes)<br />
$4 indicates Pascal area<br />
$D indicates a subdirectory file entry<br />
$E indicates a subdirectory header<br />
$F indicates a volume directory header</P><P>The name_length, the low-order four bits of the first byte, specifies<br />
the number of characters in the file_name field.</P><P>ProDOS automatically changes a seedling file to a sapling file and a<br />
sapling file to a tree file when the file's EOF grows into the range for<br />
a larger type.  If a file's EOF shrinks into the range for a smaller type,<br />
ProDOS changes a tree file to a sapling file and a sapling file to a<br />
seedling file.</P><A NAME="B.4.2.2"><H4>B.4.2.2 - The creation and last_mod Fields</H4></A><P>The date and time of the creation and last modification of each file<br />
and directory is stored as two four-byte values, as shown in<br />
Figure B-13.</P><A NAME="B-13"><P><B>Figure B-13.  Date and Time Format</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 0

&nbsp;&nbsp; 7&nbsp;&nbsp; 6&nbsp;&nbsp; 5&nbsp;&nbsp; 4&nbsp;&nbsp; 3&nbsp;&nbsp; 2&nbsp;&nbsp; 1&nbsp;&nbsp; 0 | 7&nbsp;&nbsp; 6&nbsp;&nbsp; 5&nbsp;&nbsp; 4&nbsp;&nbsp; 3&nbsp;&nbsp; 2&nbsp;&nbsp; 1&nbsp;&nbsp; 0
 +---------------------------------------------------------------+
 |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Year&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp; Month&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Day&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
 +---------------------------------------------------------------+

 +---------------------------------------------------------------+
 |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
 | 0&nbsp;&nbsp; 0&nbsp;&nbsp; 0 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Hour&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 0&nbsp;&nbsp; 0 |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Minute&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
 |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp; |
 +---------------------------------------------------------------+
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Byte 0
</PRE><P>The values for the year, month, day, hour, and minute are stored as<br />
binary integers, and may be unpacked for analysis.</P><a name="page171"></a>

<A NAME="B.4.2.3"><H4>B.4.2.3 - The access Attribute</H4></A><P>The access attribute field (Figure B-14) determines whether the file<br />
can be read from, written to, deleted, or renamed.  It also contains a bit<br />
that can be used to indicate whether a backup copy of the file has<br />
been made since the file's last modification.</P><A NAME="B-14"><P><B>Figure B-14.  The access Attribute Field</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +-------- Write-Enable
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; +---- Read-Enable
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; |
 +-------------------------------+
 | D | RN | B | Reserved | W | R |
 +-------------------------------+
&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; |
&nbsp;&nbsp; |&nbsp;&nbsp; |&nbsp;&nbsp;&nbsp; +----------------------- Backup
&nbsp;&nbsp; |&nbsp;&nbsp; +---------------------------- Rename-Enable
&nbsp;&nbsp; +-------------------------------- Destroy-Enable
</PRE><P>A bit set to 1 indicates that the operation is enabled; a bit cleared to 0<br />
indicates that the operation is disabled.  The reserved bits are always 0.</P><P>ProDOS sets bit 5, the <B>backup bit</B>, of the access field to 1 whenever<br />
the file is changed (that is, after a CREATE, RENAME, CLOSE after<br />
WRITE, or SET_FILE_INFO operation).  This bit should be reset to 0<br />
whenever the file is duplicated by a backup program.</P><P><b>Note:</B> Only ProDOS may change bits 2-4; only backup programs should<br />
clear bit 5, using SET_FILE_INFO.</P>

<A NAME="B.4.2.4"><H4>B.4.2.4 - The file_type Attribute</H4></A>

<P>The file_type attribute within an entry field identifies the type of file<br />
described by that entry.  This field should be used by system programs<br />
to guarantee file compatibility from one system program to the next.<br />
The values of this byte are shown in Table B-1.</P><a name="page172"></a>

<A NAME="B-1T"><P><B>Table B-1.  The ProDOS File_Types</B></P></A><P><I>The file types marked with a * apply to Apple III only; they are not<br />
ProDOS compatible.  For the file types used by Apple III SOS only, refer<br />
to the SOS Reference Manual.</I></P><PRE>































 <B>File Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Preferred Use</B>
 $00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Typeless file (SOS and ProDOS)
 $01&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bad block file
 $02 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Pascal code file
 $03 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Pascal text file
 $04&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASCII text file (SOS and ProDOS)
 $05 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Pascal data file
 $06&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; General binary file (SOS and ProDOS)
 $07 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Font file
 $08&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Graphics screen file
 $09 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Business BASIC program file
 $0A *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Business BASIC data file
 $0B *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Word Processor file
 $0C *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SOS system file
 $0D,$0E *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SOS reserved
 $0F&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Directory file (SOS and ProDOS)
 $10 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RPS data file
 $11 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RPS index file
 $12 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AppleFile discard file
 $13 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AppleFile model file
 $14 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AppleFile report format file
 $15 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Screen Library file
 $16-$18 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SOS reserved
 $19&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AppleWorks Data Base file
 $1A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AppleWorks Word Processor file
 $1B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AppleWorks Spreadsheet file
 $1C-$EE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Reserved
 $EF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Pascal area
 $F0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ProDOS CI added command file
 $F1-$F8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ProDOS user defined files 1-8
 $F9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ProDOS reserved
 $FA&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Integer BASIC program file
 $FB&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Integer BASIC variable file
 $FC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Applesoft program file
 $FD&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Applesoft variables file
 $FE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Relocatable code file (EDASM)
 $FF&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ProDOS system file
</PRE><a name="page173"></a>

<A NAME="B.5"><H2>B.5 - DOS 3.3 Disk Organization</H3></A><P>Both DOS 3.3 and ProDOS 140K flexible disks are formatted using the<br />
same 16-sector layout.  As a consequence, the ProDOS READ_BLOCK<br />
and WRITE_BLOCK calls are able to access DOS 3.3 disks too.  These<br />
calls know nothing about the organization of files on either type of<br />
disk.</P><P>When using READ_BLOCK and WRITE_BLOCK, you specify a<br />
512-byte block on the disk.  When using RWTS (the DOS 3.3<br />
counterpart to READ_BLOCK and WRITE_BLOCK), you specify the<br />
track and sector of a 256-byte chunk of data, as explained in the <I>DOS<br />
Programmer's Manual</I>.  You use READ_BLOCK and WRITE_BLOCK<br />
to access DOS 3.3 disks, you must know what 512-byte block<br />
corresponds to the track and sector you want.</P><P>Figure B-15 shows how to determine a block number from a given<br />
track and sector.  First multiply the track number by 8, then add the<br />
Sector Offset that corresponds to the sector number.  The half of the<br />
block in which the sector resides is determined by the Half-of-Block<br />
line (1 is the first half; 2 is the second).</P><A NAME="B-15"><P><B>Figure B-15.  Tracks and Sectors to Blocks</B></P></A><PRE>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Block = (8 * Track) + Sector Offset

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Sector : 0 1 2 3 4 5 6 7 8 9 A B C D E F
 Sector Offset : 0 7 6 6 5 5 4 4 3 3 2 2 1 1 0 7
&nbsp; Half of Block: 1 1 2 1 2 1 2 1 2 1 2 1 2 1 2 2
</PRE><P>Refer to the <I>DOS Programmer's Manual</I> for a description of the file<br />
organization of DOS 3.3 disks.</P><a name="page174"></a>
