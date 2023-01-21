---
layout:      page
title:       TechRef - Appendix - File Organization
description: ProDOS 8 Technical Reference Manual File Organization
permalink:   /docs/techref/file-organization/
---

<a name="B"></a>

<a name="page145"></a>

<p>This appendix contains a detailed description of the way that ProDOS stores files on disks.  For most system program applications, the MLI insulates you from this level of detail.  However, you must use this information if you want</p>

<ul>

<li>to list the files in a directory</li>

<li>to copy a sparse file without increasing the file's size</li>

<li>to compare two sparse files.</li>

</ul>

<p>This appendix first explains the organization of information on volumes.  Next, it shows the storage of volume directories, directories, and the various stages of standard files.  Finally it presents a set of diagrams that summarize all the material in this appendix.  You can refer to these diagrams as you read the appendix.  They will become your most valuable tool for working with file organization.</p>


<a name="B.1"></a>

<h2>B.1 - Format of Information on a Volume</h2>


<p>When a volume is formatted for use with ProDOS, its surface is partitioned into an array of tracks and sectors.  In accessing a volume, ProDOS requests not a track and sector, but a logical block from the device corresponding to that volume.  That device's driver translates the requested block number into the proper track and sector number; the physical location of information on a volume is unimportant to ProDOS and to a system program that uses ProDOS.  This appendix discusses the organization of information on a volume in terms of logical blocks, numbered starting with zero, not tracks and sectors.</p>

<p>When the volume is formatted, information needed by ProDOS is placed in specific logical blocks.  A <b>loader program</b> is placed in blocks 0 and 1 of the volume.  This program enables ProDOS to be booted from the volume.  Block 2 of the volume is the <b>key block</b> (the first block) of the <b>volume directory file</b>; it contains descriptions of (and pointers to) all the files in the volume directory.  The volume directory occupies a number of consecutive blocks, typically four, and is immediately followed by the <b>volume bit map</b>, which records whether each block on the volume is used or unused.  The volume bit map occupies consecutive blocks, one for every 4,096 blocks, or fraction thereof, on the volume.  The rest of the blocks on the disk contain subdirectory file information, standard file information, or are empty. The first blocks of a volume look something like Figure B-1.</p>

<a name="page146"></a>

<a name="B-1"></a>

<p><b>Figure B-1.  Blocks on a Volume</b></p>


<pre>
 +-----------------------------------   ----------------------------------   -------------------
 |         |         |   Block 2   |     |   Block <i>n</i>    |  Block <i>n + 1</i>  |     |    Block <i>p</i>    |
 | Block 0 | Block 1 |   Volume    | ... |    Volume    |    Volume     | ... |    Volume     | Other
 | Loader  | Loader  |  Directory  |     |  Directory   |    Bit Map    |     |    Bit Map    | Files
 |         |         | (Key Block) |     | (Last Block) | (First Block) |     | (Last Block)  |
 +-----------------------------------   ----------------------------------   -------------------
</pre>

<p>The precise format of the volume directory, volume bit map, subdirectory files and standard files are explained in the following sections.</p>

<a name="B.2"></a>

<h2>B.2 - Format of Directory Files</h2>


<p>The format of the information contained in volume directory and subdirectory files is quite similar.  Each consists of a <b>key block</b> followed by zero or more blocks of additional directory information.  The fields in a directory's key block are: a pointer to the next block in the directory; a header entry that describes the directory; a number of file entries describing, and pointing to, the files in that directory; and zero or more unused bytes.  The fields in subsequent (non-key) blocks in a directory are: a number of entries describing, and pointing to, the files in that directory; and zero or more unused bytes.  The format of a directory file is represented in Figure B-2.</p>


<a name="page147"></a>

<a name="B-2"></a>


<p><b>Figure B-2.  Directory File Format</b></p>


<pre>
          
          
          
          
          
           <b>Key Block    Any Block         Last Block</b>
         / +-------+    +-------+         +-------+
        |  |   0   |&#60;---|Pointer|&#60;--...&#60;--|Pointer|                         <b>Blocks of a directory:</b>
        |  |-------|    |-------|         |-------|     Not necessarily contiguous,
        |  |Pointer|---&#62;|Pointer|--&#62;...--&#62;|   0   |     linked by <b>pointers</b>.
        |  |-------|    |-------|         |-------|
        |  |Header |    | Entry |   ...   | Entry |
        |  |-------|    |-------|         |-------|                         <b>Header</b> describes the
        |  | Entry |    | Entry |   ...   | Entry |     directory file and its
        |  |-------|    |-------|         |-------|     contents.
  One  /   / More  /    / More  /         / More  /
 Block \   /Entries/    /Entries/         /Entries/
        |  |-------|    |-------|         |-------|                         <b>Entry</b> describes
        |  | Entry |    | Entry |   ...   | Entry |     and points to a file
        |  |-------|    |-------|         |-------|     (subdirectory or
        |  | Entry |    | Entry |   ...   | Entry |     standard) in that
        |  |-------|    |-------|         |-------|     directory.
        |  |Unused |    |Unused |   ...   |Unused |
         \ +-------+    +-------+         +-------+
</pre>


<p>The header entry is the same length as all other entries.  The only organizational difference between a volume directory file and a subdirectory file is in the header.</p>

<p>See the sections "Volume Directory Headers" and "Subdirectory Headers."</p>


<a name="B.2.1"></a>

<h2>B.2.1 Pointer Fields</h2>


<p>The first four bytes of each block used by a directory file contain pointers to the preceding and succeeding blocks in the directory file, respectively.  Each pointer is a two-byte logical block number, low byte first, high byte second.  The key block of a directory file has no preceding block: its first pointer is zero.  Likewise, the last block in a directory file has no successor: its second pointer is zero.</p>

<p><b>By the Way:</b> All block pointers used by ProDOS have the same format: low byte first, high byte second.</p>


<a name="B.2.2"></a>

<h3>B.2.2 - Volume Directory Headers</h3>


<p>Block 2 of a volume is the key block of that volume's directory file. The volume directory header is at byte position $0004 of the key block, immediately following the block's two pointers.  Thirteen fields are currently defined to be in a volume directory header: they contain all the vital information about that volume.  Figure B-3 illustrates the structure of a volume directory header.  Following Figure B-3 is a description of each of its fields.</p>


<a name="page148"></a>

<a name="B-3"></a>


<p><b>Figure B-3.  The Volume Directory Header</b></p>


<pre>
   
   
   
   
   
    <b>Field                                Byte of
   Length                                Block</b>
          +----------------------------+
  1 byte  | storage_type | name_length | $04
          |----------------------------|
          |                            | $05
          /                            /    
 15 bytes /        file_name           /
          |                            | $13
          |----------------------------|
          |                            | $14
          /                            /
  8 bytes /          reserved          /
          |                            | $1B
          |----------------------------|
          |                            | $1C
          |          creation          | $1D
  4 bytes |        date &#38; time         | $1D
          |                            | $1F
          |----------------------------|
  1 byte  |          version           | $20
          |----------------------------|
  1 byte  |        min_version         | $21
          |----------------------------|
  1 byte  |           access           | $22
          |----------------------------|
  1 byte  |        entry_length        | $23
          |----------------------------|
  1 byte  |     entries_per_block      | $24
          |----------------------------|
          |                            | $25
  2 bytes |         file_count         | $26
          |----------------------------|
          |                            | $27
  2 bytes |      bit_map_pointer       | $28
          |----------------------------|
          |                            | $29
  2 bytes |        total_blocks        | $2A
          +----------------------------+
</pre>


<a name="page149"></a>

<p><b>storage_type</b> and <b>name_length</b> (1 byte): Two four-bit fields are packed into this byte.  A value of $F in the high four bits (the storage_type) identifies the current block as the key block of a volume directory file.  The low four bits contain the length of the volume's name (see the file_name field, below).  The name_length can be changed by a RENAME call.</p>

<p><b>file_name</b> (15 bytes): The first n bytes of this field, where n is specified by name_length, contain the volume's name.  This name must conform to the filename (volume name) syntax explained in Chapter 2. The name does not begin with the slash that usually precedes volume names.  This field can be changed by the RENAME call.</p>

<p><b>reserved</b> (8 bytes): Reserved for future expansion of the file system. The reserved bytes must be set in order to prevent I/O ERROR on read. The bytes are as follows: $75, version ($23 in the last version released by Apple), min_version (up to ProDOS 2.4 this is $00), $00, $C3, $27, $0D, $00</p>

<p><b>creation</b> (4 bytes): The date and time at which this volume was initialized.  The format of these bytes is described in Section B.4.2.2.</p>

<p><b>version</b> (1 byte): The version number of ProDOS under which this volume was initialized.  This byte allows newer versions of ProDOS to determine the format of the volume, and adjust their directory interpretation to conform to older volume formats.  In ProDOS 1.0, version = 0.</p>

<p><b>min_version</b>: Reserved for future use.  In ProDOS 1.0, it is 0.</p>

<p><b>access</b> (1 byte): Determines whether this volume directory can be read written, destroyed, and renamed.  The format of this field is described in Section B.4.2.3.</p>

<p><b>entry_length</b> (1 byte): The length in bytes of each entry in this directory.  The volume directory header itself is of this length. entry_length = $27.</p>

<p><b>entries_per_block</b> (1 byte): The number of entries that are stored in each block of the directory file.  entries_per_block = $0D.</p>

<p><b>file_count</b> (2 bytes): The number of active file entries in this directory file.  An active file is one whose storage_type is not 0.  See Section B.2.4 for a description of file entries.</p>

<p><b>bit_map_pointer</b> (2 bytes): The block address of the first block of the volume's bit map.  The bit map occupies consecutive blocks, one for every 4,096 blocks (or fraction thereof) on the volume.  You can calculate the number of blocks in the bit map using the total_blocks field, described below.</p>

<a name="page150"></a>

<p>The bit map has one bit for each block on the volume: a value of 1 means the block is free; 0 means it is in use.  If the number of blocks used by all files on the volume is not the same as the number recorded in the bit map, the directory structure of the volume has been damaged. In each byte of the bitmap, the blocks are represented from left to right. For example, the first block is represented by the high bit in the first byte of the bitmap.</p>

<p><b>total_blocks</b> (2 bytes): The total number of blocks on the volume.</p>

<a name="B.2.3"></a>


<h3>B.2.3 - Subdirectory Headers</h3>


<p>The key block of every subdirectory file is pointed to by an entry in a parent directory; for example, by an entry in a volume directory (explained in Section B.2).  A subdirectory's header begins at byte position $0004 of the key block of that subdirectory file, immediately following the two pointers.</p>

<p>Its internal structure is quite similar to that of a volume directory header.  Fourteen fields are currently defined to be in a subdirectory. Figure B-4 illustrates the structure of a subdirectory header.  A description of all the fields in a subdirectory header follows Figure B-4.</p>

<a name="page151"></a>

<a name="B-4"></a>


<p><b>Figure B-4.  The Subdirectory Header</b></p>


<pre>
   
   
   
   
   
    <b>Field                                Byte of
   Length                                Block</b>
          +----------------------------+
  1 byte  | storage_type | name_length | $04
          |----------------------------|
          |                            | $05
          /                            /
 15 bytes /         file_name          /
          |                            | $13
          |----------------------------|
          |                            | $14
          /                            /
  8 bytes /          reserved          /
          |                            | $1B
          |----------------------------|
          |                            | $1C
          |          creation          | $1D
  4 bytes |        date &#38; time         | $1D
          |                            | $1F
          |----------------------------|
  1 byte  |          version           | $20
          |----------------------------|
  1 byte  |        min_version         | $21
          |----------------------------|
  1 byte  |           access           | $22
          |----------------------------|
  1 byte  |        entry_length        | $23
          |----------------------------|
  1 byte  |     entries_per_block      | $24
          |----------------------------|
          |                            | $25
  2 bytes |         file_count         | $26
          |----------------------------|
          |                            | $27
  2 bytes |       parent_pointer       | $28
          |----------------------------|
  1 byte  |    parent_entry_number     | $29
          |----------------------------|
  1 byte  |    parent_entry_length     | $2A
          +----------------------------+
</pre>

<a name="page152"></a>

<p><b>storage_type</b> and <b>name_length</b> (1 byte): Two four-bit fields are packed into this byte.  A value of $E in the high four bits (the storage_type) identifies the current block as the key block of a subdirectory file.  The low four bits contain the length of the subdirectory's name (see the file_name field, below).  The name_length can be changed by a RENAME call.</p>

<p><b>file_name</b> (15 bytes): The first name_length bytes of this field contain the subdirectory's name.  This name must conform to the filename syntax explained in Chapter 2.  This field can be changed by the RENAME call.</p>

<p><b>reserved</b> (8 bytes): Reserved for future expansion of the file system.</p>

<p><b>creation</b> (4 bytes): The date and time at which this subdirectory was created.  The format of these bytes is described in Section B.4.2.2.</p>

<p><b>version</b> (1 byte): The version number of ProDOS under which this subdirectory was created.  This byte allows newer versions of ProDOS to determine the format of the subdirectory, and to adjust their directory interpretations accordingly.  ProDOS 1.0: version = 0.</p>

<p><b>min_version</b> (1 byte): The minimum version number of ProDOS that can access the information in this subdirectory.  This byte allows older versions of ProDOS to determine whether they can access newer subdirectories.  min_version = 0.</p>

<p><b>access</b> (1 byte): Determines whether this subdirectory can be read, written, destroyed, and renamed, and whether the file needs to be backed up.  The format of this field is described in Section B.4.2.3.  A subdirectory's access byte can be changed by the SET_FILE_INFO call.</p>

<p><b>entry_length</b> (1 byte): The length in bytes of each entry in this subdirectory.  The subdirectory header itself is of this length. entry_length = $27.</p>

<p><b>entries_per_block</b> (1 byte): The number of entries that are stored in each block of the directory file.  entries_per_block = $0D.</p>

<p><b>file_count</b> (2 bytes): The number of active file entries in this subdirectory file.  An active file is one whose storage_type is not 0.  See Section "File Entries" for more information about file entries.</p>

<p><b>parent_pointer</b> (2 bytes): The block address of the directory file block that contains the entry for this subdirectory.  This two-byte pointer is stored low byte first, high byte second.</p>

<a name="page153"></a>

<p><b>parent_entry_number</b> (1 byte): The entry number for this subdirectory within the block indicated by parent_pointer.</p>

<p><b>parent_entry_length</b> (1 byte): The entry_length for the directory that owns this subdirectory file.  Note that with these last three fields you can calculate the precise position on a volume of this subdirectory's file entry.  parent_entry_length = $27.</p>

<a name="B.2.4"></a>

<h3>B.2.4 - File Entries</h3>


<p>Immediately following the pointers in any block of a directory file are a number of entries.  The first entry in the key block of a directory file is a header; all other entries are file entries.  Each entry has the length specified by that directory's entry_length field, and each file entry contains information that describes, and points to, a single subdirectory file or standard file.</p>

<p>An entry in a directory file may be active or inactive; that is, it may or may not describe a file currently in the directory.  If it is inactive, the first byte of the entry (storage_type and name_length) has the value zero.</p>

<p>The maximum number of entries, including the header, in a block of a directory is recorded in the entries_per_block field of that directory's header.  The total number of active file entries, not including the header, is recorded in the file_count field of that directory's header.</p>

<p>Figure B-5 describes the format of a file entry.</p>

<a name="page154"></a>

<a name="B-5"></a>

<p><b>Figure B-5.  The File Entry</b></p>


<pre>
   
   
   
   
   
    <b>Field                                Entry
   Length                                Offset</b>
          +----------------------------+
  1 byte  | storage_type | name_length | $00
          |----------------------------|
          |                            | $01
          /                            /
 15 bytes /         file_name          /
          |                            | $0F
          |----------------------------|
  1 byte  |         file_type          | $10
          |----------------------------|
          |                            | $11
  2 bytes |        key_pointer         | $12
          |----------------------------|
          |                            | $13
  2 bytes |        blocks_used         | $14
          |----------------------------|
          |                            | $15
  3 bytes |            EOF             |
          |                            | $17
          |----------------------------|
          |                            | $18
          |          creation          |
  4 bytes |        date &#38; time         |
          |                            | $1B
          |----------------------------|
  1 byte  |          version           | $1C
          |----------------------------|
  1 byte  |        min_version         | $1D
          |----------------------------|
  1 byte  |           access           | $1E
          |----------------------------|
          |                            | $1F
  2 bytes |          aux_type          | $20
          |----------------------------|
          |                            | $21
          |                            |
  4 bytes |          last mod          |
          |                            | $24
          |----------------------------|
          |                            | $25
  2 bytes |       header_pointer       | $26
          +----------------------------+
</pre>


<a name="page155"></a>

<p><b>storage_type</b> and <b>name_length</b> (1 byte): Two four-bit fields are packed into this byte.  The value in the high-order four bits (the storage_type) specifies the type of file pointed to by this file entry:</p>

<p>$1 = Seeding file $2 = Sapling file $3 = Tree file $4 = Pascal area $D = Subdirectory</p>

<p>Seedling, sapling, and tree files, the three forms of a standard file, are described in Section B.3.  The low four bits contain the length of the file's name (see the file_name field, below).  The name_length can be changed by a RENAME call.</p>

<p><b>file_name</b> (15 bytes): The first name_length bytes of this field contain the file's name.  This name must conform to the filename syntax explained in Chapter 2.  This field can be changed by the RENAME call.</p>

<p><b>file_type</b> (1 byte): A descriptor of the internal structure of the file. Section B.4.2.4 contains a list of the currently defined values of this byte.</p>

<p><b>key_pointer</b> (2 bytes): The block address of the master index block if a tree file, of the index block if a sapling file, and of the block if a seedling file.</p>

<p><b>blocks_used</b> (2 bytes): The total number of blocks actually used by the file.  For a subdirectory file, this includes the blocks containing subdirectory information, but not the blocks in the files pointed to.  For a standard file, this includes both informational blocks (index blocks) and data blocks.  Refer to Section B.3 for more information on standard files.</p>

<p><b>EOF</b> (3 bytes): A three-byte integer, lowest bytes first, that represents the total number of bytes readable from the file.  Note that in the case of sparse files, described in Section B.3.6, EOF may be greater than the number of bytes actually allocated on the disk.</p>

<p><b>creation</b> (4 bytes): The date and time at which the file pointed to by this entry was created.  The format of these bytes is described in Section B.4.2.2.</p>

<p><b>version</b> (1 byte): The version number of ProDOS under which the file pointed to by this entry was created.  This byte allows newer versions of ProDOS to determine the format of the file, and adjust their interpretation processes accordingly.  In ProDOS 1.0, version = 0.</p>

<a name="page156"></a>

<p><b>min_version</b> (1 byte): The minimum version number of ProDOS that can access the information in this file.  This byte allows older versions of ProDOS to determine whether they can access newer files.  In ProDOS 1.0, min_version = 0.</p>

<p><b>access</b> (1 byte): Determines whether this file can be read, written, destroyed, and renamed, and whether the file needs to be backed up. The format of this field is described in Section B.4.2.3.  The value of this field can be changed by the SET_FILE_INFO call.  You cannot delete a subdirectory that contains any files.</p>

<p><b>aux_type</b> (2 bytes): A general-purpose field in which a system program can store additional information about the internal format of a file.  For example, the ProDOS BASIC system program uses this field to record the load address of a BASIC program or binary file, or the record length of a text file.</p>

<p><b>last_mod</b> (4 bytes): The date and time that the last CLOSE operation after a WRITE was performed on this file.  The format of these bytes is described in Section B.4.2.2.  This field can be changed by the SET_FILE_INFO call.</p>

<p><b>header_pointer</b> (2 bytes): This field is the block address of the key block of the directory that owns this file entry.  This two-byte pointer is stored low byte first, high byte second.</p>

<a name="B.2.5"></a>


<h3>B.2.5 - Reading a Directory File</h3>


<p>This section deals with the techniques of reading from directory files, not with the specifics.  The ProDOS calls with which these techniques can be implemented are explained in Chapter 4.</p>

<p>Before you can read from a directory, you must know the directory's pathname.  With the directory's pathname, you can open the directory file, and obtain a reference number (<b><tt>RefNum</tt></b>) for that open file. Before you can process the entries in the directory, you must read three values from the directory header:</p>

<ul>
<li>the length of each entry in the directory (entry_length)</li>
<li>the number of entries in each block of the directory (entries_per_block)</li>
<li>the total number of files in the directory (file_count).</li>
</ul>

<a name="page157"></a>

<p>Using the reference number to identify the file, read the first 512 bytes from the file, and into a buffer (<b><tt>ThisBlock</tt></b>).  The buffer contains two two-byte pointers, followed by the entries; the first entry is the directory header.  The three values are at positions $1F through $22 in the header (positions $23 through $26 in the buffer).  In the example below, these values are assigned to the variables <b><tt>EntryLength</tt></b>, <b><tt>EntriesPerBlock</tt></b>, and <b><tt>FileCount</tt></b>.</p>

{% highlight basic %}
 Open(DirPathname, Refnum);               {Get reference number    }
 ThisBlock       := Read512Bytes(RefNum); {Read a block into buffer}
 EntryLength     := ThisBlock[$23];       {Get directory info      }
 EntriesPerBlock := ThisBlock[$24];
 FileCount       := ThisBlock[$25] + (256 * ThisBlock[$26]);
{% endhighlight %}


<p>Once these values are known, a system program can scan through the entries in the buffer, using a pointer to the beginning of the current entry <b><tt>EntryPointer</tt></b>, a counter <b><tt>BlockEntries</tt></b> that indicates the number of entries that have been examined in the current block, and a second counter <b><tt>ActiveEntries</tt></b> that indicates the number of active entries that have been processed.</p>

<p>An entry is active and is processed only if its first byte, the storage_type and name_length, is nonzero.  All entries have been processed when <b><tt>ActiveEntries</tt></b> is equal to <b><tt>FileCount</tt></b>.  If all the entries in the buffer have been processed, and <b><tt>ActiveEntries</tt></b> doesn't equal <b><tt>FileCount</tt></b>, then the next block of the directory is read into the buffer.</p>


{% highlight basic %}
 EntryPoint      := EntryLength + $04;         {Skip header entry}
 BlockEntries    := $02;            {Prepare to process entry two}
 ActiveEntries   := $00;            {No active entries found yet }

 while ActiveEntries &#60; FileCount do begin
      if ThisBlock[EntryPointer] &#60;&#62; $00 then begin  {Active entry}
           ProcessEntry(ThisBlock[EntryPointer]);
           ActiveEntries := ActiveEntries + $01
      end;
      if ActiveEntries &#60; FileCount then  {More entries to process}
           if BlockEntries = EntriesPerBlock
                then begin           {ThisBlock done. Do next one}
                     ThisBlock    := Read512Bytes(RefNum);
                     BlockEntries := $01;
                     EntryPointer := $04
                end
                else begin           {Do next entry in ThisBlock }
                     EntryPointer := EntryPointer + EntryLength;
                     BlockEntries := BlockEntries + $01
                end
 end;
 Close(RefNum);
{% endhighlight %}


<a name="page158"></a>

<p>This algorithm processes entries until all expected active entries have been found.  If the directory structure is damaged, and the end of the directory file is reached before the proper number of active entries has been found, the algorithm fails.</p>

<a name="B.3"></a>

<h2>B.3 - Format of Standard Files</h2>


<p>Each active entry in a directory file points to the key block (the first block) of a file.  As shown below, the key block of a standard file may have several types of information in it.  The storage_type field in that file's entry must be used to determine the contents of the key block. This section explains the structure of the three stages of standard file: seedling, sapling, and tree.  These are the files in which all programs and data are stored.</p>

<a name="B.3.1"></a>

<h3>B.3.1 - Growing a Tree File</h3>

<p>The following scenario demonstrates the <i>growth</i> of a tree file on a volume.  This scenario is based on the block allocation scheme used by ProDOS 1.0 on a 280-block flexible disk that contains four blocks of volume directory, and one block of volume bit map.  Larger capacity volumes might have more blocks in the volume bit map, but the process would be identical.</p>

<p>A formatted, but otherwise empty, ProDOS volume is used like this:</p>

<p>Blocks 0-1 - Loader Blocks 2-5 - Volume directory Block 6 - Volume bit map Blocks 7-279 - Unused</p>

<a name="page159"></a>

<p>If you open a new file of a nondirectory type, one data block is immediately allocated to that file.  An entry is placed in the volume directory, and it points to block 7, the new data block, as the key block for the file.  The key block is indicated below by an arrow.</p>

<p>The volume now looks like this:</p>


<pre>
 Data Block 0
     Blocks 0-1      Loader
     Blocks 2-5      Volume directory
     Block 6         Volume bit map
 --&#62; Block 7         Data block 0
     Blocks 8-279    Unused
</pre>


<p>This is a <b>seedling file</b>: its key block contains up to 512 bytes of data. If you write more than 512 bytes of data to the file, the file <i>grows</i> into a <b>sapling file</b>.  As soon as a second block of data becomes necessary, an <b>index block</b> is allocated, and it becomes the file's key block: this index block can point to up to 256 data blocks (two-byte pointers).  A second data block (for the data that won't fit in the first data block) is also allocated.  The volume now looks like this:</p>


{% highlight basic %}
 Index Block 0
 Data Block 0
 Data Block 1
     Blocks 0-1      Loader
     Blocks 2-5      Volume directory
     Block 6         Volume bit map
     Block 7         Data block 0
 --&#62; Block 8         Index block 0
     Block 9         Data block 1
     Blocks 10-279   Unused
{% endhighlight %}


<p>This sapling file can hold up to 256 data blocks: 128K of data.  If the file becomes any bigger than this, the file <i>grows</i> again, this time into a <b>tree file</b>.  A <b>master index block</b> is allocated, and it becomes the file's key block: the master index block can point to up to 128 index blocks and each of these can point to up to 256 data blocks.  Index block G becomes the first index block pointed to by the master index block.  In addition, a new index block is allocated, and a new data block to which it points.</p>

<a name="page160"></a>

<p>Here's a new picture of the volume:</p>


<pre>
 Master Index Block
 Index Block 0
 Index Block 1
 Data Block 0
 Data Block 255
 Data Block 256
     Blocks 0-1      Loader
     Blocks 2-5      Volume directory
     Block 6         Volume bit map
     Block 7         Data block 0
     Block 8         Index block 0
     Blocks 9-263    Data blocks 1-255
 --&#62; Block 264       Master index block
     Block 265       Index block 1
     Block 266       Data block 256
     Blocks 267-279  Unused
</pre>



<p>As data is written to this file, additional data blocks and index blocks are allocated as needed, up to a maximum of 129 index blocks (one a master index block), and 32,768 data blocks, for a maximum capacity of 16,777,215 bytes of data in a file.  If you did the multiplication, you probably noticed that a byte was lost somewhere.  The last byte of the last block of the largest possible file cannot be used because <b>EOF</b> cannot exceed 16,777,216.  If you are wondering how such a large file might fit on a small volume such as a flexible disk, refer to Section B.3.6 on sparse files.</p>

<p>This scenario shows the growth of a single file on an otherwise empty volume.  The process is a bit more confusing when several files are growing -- or being deleted -- simultaneously.  However, the block allocation scheme is always the same: when a new block is needed ProDOS always allocates the first unused block in the volume bit map.</p>

<a name="B.3.2"></a>


<h3>B.3.2 Seedling Files</h3>


<p>A <b>seedling file</b> is a standard file that contains no more than 512 data bytes ($0 &#60;= <b>EOF</b> &#60;= $200).  This file is stored as one block on the volume, and this data block is the file's key block.</p>

<p>The structure of such a seedling file appears in Figure B-6.</p>

<a name="page161"></a>

<a name="B-6"></a>
<h4>Figure B-6.  Structure of a Seedling File</h4>
<pre>
 key_pointer ----&#62; +-------+
                   | Data  | Data Block
                   | Block | 512 bytes long
 $0 &#60;= EOF &#60;= $200 +-------+
</pre>
<p>The file is called a seedling file because, if more than 512 data bytes are written to it, it grows into a sapling file, and thence into a tree file.</p>

<p>The <b>storage_type</b> field of an entry that points to a seedling file has the value $1.</p>

<a name="B.3.3"></a>


<h3>B.3.3 - Sapling Files</h3>


<p>A <b>sapling file</b> is a standard file that contains more than 512 and no more than 128K bytes ($200 &#60; <b>EOF</b> &#60;= $20000).  A sapling file comprises an index block and 1 to 256 data blocks.  The index block contains the block addresses of the data blocks.  The low bytes for each block pointer are in bytes 0 - 127 of the index block. The high bytes for each block pointer are in bytes 128 - 255 of the index block.  See Figure B-7.</p>

<a name="B-7"></a>

<p><b>Figure B-7.  Structure of a Sapling File</b></p>


<pre>
 key_pointer ------&#62; +-------------------+
                     |   |   |   |   |   | Index Block:
                     |$00 $01     $FE $FF| Up to 256 2-Byte
                     |-   Index Block   -| Pointers to Data Blocks
 $0 &#60;= EOF &#60;= $20000 |   |   |   |   |   |
                     +-------------------+
                       |   |       |   |
       +---------------+   |       |   +-------------------+
       |                   |       |                       |
       |               +---+       +-------+               |
       |               |                   |               |
       v               v                   v               v
 +-----------+   +-----------+       +-----------+   +-----------+
 |   Data    |   |   Data    | ..... |   Data    |   |   Data    |
 | Block $00 |   | Block $01 |       | Block $FE |   | Block $FF |
 +-----------+   +-----------+       +-----------+   +-----------+
</pre>


<p>The key block of a sapling file is its index block.  ProDOS retrieves data blocks in the file by first retrieving their addresses in the index block.</p>

<p>The <b>storage_type</b> field of an entry that points to a sapling file has the value $2.</p>

<a name="page162"></a>

<a name="B.3.4"></a>


<h3>B.3.4 - Tree Files</h3>


<p>A <b>tree file</b> contains more than 128K bytes, and less than 16M bytes ($20000 &#60; <b>EOF</b> &#60; $1000000).  A tree file consists of a master index block, 1 to 128 index blocks, and 1 to 32,768 data blocks.  The low bytes of block pointers on all index blocks are in bytes 0 - 127 and the high bytes in 128 - 255.  The master index block contains the addresses of the index blocks, and each index block contains the addresses of up to 256 data blocks.  The structure of a tree file is shown in Figure B-8.</p>

<a name="B-8"></a>


<p><b>Figure B-8.  The Structure of a Tree File</b></p>


<pre>
      key_pointer ------&#62; +----------------------+
                          |   |   |      |   |   | Master Index Block:
                          |- Master Index Block -| Up to 128 2-Byte Pointers
 $20000 &#60; EOF &#60; $10000000 |   |   |      |   |   | to Index Blocks
                          +----------------------+
                            |                  |
               +------------+                +-+
               |                             |
               v                             v
             +-------------------+         +-------------------+
             |   |   |   |   |   |         |   |   |   |   |   |
             |- Index Block $00 -| ....... |- Index Block $7F -|
             |   |   |   |   |   |         |   |   |   |   |   |
             +-------------------+         +-------------------+
               |               |             |               |
     +---------+        +------+            ++               ++
     |                  |                   |                 |
     v                  v                   v                 v
   +-----------+      +-----------+       +-----------+     +-----------+
   |   Data    | .... |   Data    |       |   Data    | ... |   Data    |
   | Block $00 |      | Block $FF |       | Block $00 |     | Block $FF |
   +-----------+      +-----------+       +-----------+     +-----------+
</pre>


<p>The key block of a tree file is the master index block.  By looking at the master index block, ProDOS can find the addresses of all the index blocks; by looking at those blocks, it can find the addresses of all the data blocks.</p>

<p>The <b>storage_type</b> field of an entry that points to a tree file has the value $3.</p>

<a name="B.3.5"></a>

<h3>B.3.5 - Using Standard Files</h3>



<p>A system program or application program operates the same on all three types of standard files, although the <b>storage_type</b> in the file's entry can be used to distinguish between the three.  A program rarely reads index blocks or allocates blocks on a volume: ProDOS does that. The program need only be concerned with the data stored in the file, not with how they are stored.</p>

<p>All types of standard files are read as a sequence of bytes, numbered from 0 to <b>EOF</b>-1, as explained in Chapter 4.</p>

<a name="page163"></a>

<a name="B.3.6"></a>

<h3>B.3.6 - Sparse Files</h3>



<p>A <b>sparse file</b> is a sapling or tree file in which the number of data bytes that can be read from the file exceeds the number of bytes physically stored in the data blocks allocated to the file.  ProDOS implements sparse files by allocating only those data blocks that have had data written to them, as well as the index blocks needed to point to them.</p>

<p>For example, you can define a file whose <b>EOF</b> is 16K, that uses only three blocks on the volume, and that has only four bytes of data written to it.  If you create a file with an  <b>EOF</b> of $0, ProDOS allocates only the key block (a data block) for a seedling file, and fills it with null characters (ASCII $00).</p>

<p>If you then set the <b>EOF</b> and <b>MARK</b> to position $0565, and write four bytes, ProDOS calculates that position $0565 is byte $0165 ($0564-($0200*2)) of the third block (block $2) of the file.  It then allocates an index block, stores the address of the current data block in position 0 of the index block, allocates another data block, stores the address of that data block in position 2 of the index block, and stores the data in bytes $0165 through $0168 of that data block.  The <b>EOF</b> is $0569.</p>

<p>If you now set the <b>EOF</b> to $4000 and close the file, you have a 16K file that takes up three blocks of space on the volume: two data blocks and an index block.  You can read 16384 bytes of data from the file, but all the bytes before $0565 and after $0568 are nulls. Figure B-9 shows how the file is organized.</p>

<a name="page164"></a>

<a name="B-9"></a>


<p><b>Figure B-9.  A Sparse File</b></p>


<pre>
                  0 1 2
 key_pointer --&#62; +--------------+
       Key_Block | | | |        |
                 +--------------+
                  |   |
        +---------+   +-------+                           EOF = $4000
        |                     |                                     |
        v Block $0   Block $1 v Block $2   Block $3       Block $1F v
   Data +-------------------------------------------+   +-----------+
 Blocks |          |          |     | |  |          |   |           |
        +-------------------------------------------+   +-----------+
       $0         $1FF       $400    ^  $5FF
                                     |
                      Bytes $565..$568
</pre>


<p>Thus ProDOS allocates volume space only for those blocks in a file that actually contain data.  For tree files, the situation is similar: if none of the 256 data blocks assigned to an index block in a tree file have been allocated, the index block itself is not allocated.</p>

<p>On the other hand, if you CREATE a file with an <b>EOF</b> of $4000 (making it 16K bytes, or 32 blocks, long), ProDOS allocates an index block and 32 data blocks for a sapling file, and fills the data blocks with nulls.</p>

<p><b>By the Way:</b> The first data block of a standard file, be it a seedling, sapling, or tree file, is always allocated.  Thus there is always a data block to be read in when the file is opened.</p>

<a name="page165"></a>

<a name="B.3.7"></a>

<h3>B.3.7 - Locating a Byte in a File</h3>


<p>The algorithm for finding a specific byte within a standard file is given below.</p>

<p>The MARK is a three-byte value that indicates an absolute byte position within a file.</p>


<pre>
 Byte #        Byte 2             Byte 1            Byte 0

 bit #      7             0   7             0   7             0
           +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 MARK      |Index Number |Data Block Number|   Byte of Block   |
           +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
 Used by:    Tree only    Tree and sapling      All three
</pre>


<p>If the file is a tree file, then the high seven bits of the MARK determine the number (0 to 127) of the index block that points to the byte.  The value of the seven bits indicate the location of the low byte of the index block address within the master index block.  The location of the high byte of the index block address is indicated by the value of these seven bits plus 256.</p>

<a name="page166"></a>

<p>If the file is a tree file or a sapling file, then the next eight bits of the MARK determine the number (0-255) of the data block pointed to by the indicated index block.  This 8-bit value indicates the location of the low byte of the data block address within the index block.  The high byte of the index block address is found at this offset plus 256.</p>

<p>For tree, sapling, and seedling files, the low nine bits of the MARK are the absolute position of the byte within the selected data block.</p>

<a name="B.3.8"></a>

<h3>B.3.8 - Maximum sizes</h3>

<p>The maximum size of a volume is 32 MB - 512 (total_blocks = 0xFFFF of 512 bytes each = 32,767.5 KB, see Figure B-3), of which 2 are reserved for the boot loader, and the rest for the filesystem.</p>
<p>The maximum size of a file is 16 MB - 1: in theory a tree could represent 32 MB: 256 pointers in the master block and 256 in each index block: 256 * 256 * 512 = 32MB. The 16 MB limit comes from the EOF value in the File Entry (see Figure B-5) which is 3 bytes with maximum value 0xFFFFFF = 16 MB - 1. This means that only half of the master block can be used (128 pointers).</p>



<a name="B.4"></a>


<h2>B.4 - Disk Organization</h2>


<p>Figure B-10 presents an overall view of block organization on a volume. Figure B-11 shows the complete structures of the three standard files types.  Figure B-12 is a summary of header and entry field information.</p>

<a name="page167"></a>

<a name="B-10"></a>

<p><b>Figure B-10.  Disk Organization</b></p>



<pre>
                                     +--------------------+
                                     | BLOCKS ON A VOLUME |
                                     |     Figure B-1     |
                                     +--------------------+
                                         ||          ||
                                         ||          ||
                                         ||          ||
                                         vv          vv
                              +----------------------------------+
                              |   BLOCKS OF A DIRECTORY FILE     |
            |=================| VOLUME DIRECTORY OR SUBDIRECTORY |
            ||                |          Figure B-2              |
            ||                +----------------------------------+
            ||                          ||                   ||
            |============================|                   ||
            ||                          ||                   ||
            vv                          vv                   vv
 +----------------------+    +----------------------+    +------------------------------------+
 |        HEADER        |    |        HEADER        |    |             FILE ENTRY             |
 |   VOLUME DIRECTORY   |    |     SUBDIRECTORY     |    |           SUBDIRECTORY OR          |
 |  Found in key block  |    |  Found in key block  |    |            STANDARD FILE           |===&#62;&#62;to Figure B-11
 | of volume directory. |    |   of subdirectory.   |    | Found in any directory file block. |
 |      Figure B-3      |    |      Figure B-4      |    |             Figure B-5             |
 +----------------------+    +----------------------+    +------------------------------------+
</pre>


<a name="page168"></a>

<a name="B.4.1"></a>

<h3>B.4.1 - Standard Files</h3>


<a name="B-11"></a>


<p><b>Figure B-11.  Standard Files</b></p>



<pre>
            +---------------+
      |===&#62;&#62;|   KEY BLOCK   |
      ||    | Standard File |
      ||    +---------------+
      ||
      ||    +----------------------------------+
      |===&#62;&#62;| SEEDLING FILE: storage_type = $1 |
      ||    |            Figure B-6            |
      ||    +----------------------------------+
      ||
      ||    +----------------------------------+
      |===&#62;&#62;| SAPLING FILE: storage_type = $2  |
      ||    |            Figure B-7            |
      ||    +----------------------------------+
      ||
      ||    +----------------------------------+
      |===&#62;&#62;| TREE FILE: storage_type = $3     |
      ||    |            Figure B-8            |
      ||    +----------------------------------+
      ||
 ======|
 from Figure B-10
</pre>


<a name="page169"></a>

<a name="B.4.2"></a>

<h3>B.4.2 - Header and Entry Fields</h3>


<a name="B-12"></a>


<p><b>Figure B-12.  Header and Entry Fields</b></p>


<pre>
 +-------------+
 | CREATE_DATE |                    Byte 1                          Byte 0
 |             |
 | MOD_DATE    |         7   6   5   4   3   2   1   0 | 7   6   5   4   3   2   1   0
 +-------------+ ----> +---------------------------------------------------------------+
                       |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
                       |           Year            |     Month     |        Day        |
                       |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
                       +---------------------------------------------------------------+
 +-------------+
 | CREATE_TIME |
 |             |
 | MOD_TIME    |
 +-------------+ ----> +---------------------------------------------------------------+
                       |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
                       | 0   0   0 |       Hour        | 0   0 |        Minute         |
                       |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
                       +---------------------------------------------------------------+
                                    Byte 1                          Byte 0




                                                                                 +-------- Write-Enable
                                                                                 |   +---- Read-Enable
                                                                                 |   |
 +--------------+                       +----------+   +-------------------------------+
 | storage_type |                       |  access  | = | D | RN | B | Reserved | W | R |
 |   (4 bits)   |                       | (1 byte) |   +-------------------------------+
 +--------------+                       +----------+     |   |    |
                                                         |   |    +----------------------- Backup
 $0 = inactive file entry                                |   +---------------------------- Rename-Enable
 $1 = seedling file entry                                +-------------------------------- Destroy-Enable
 $2 = sapling file entry
 $3 = tree file entry
 $D = subdirectory file entry                          name_length = length of file_name ($1-$F)
 $E = subdirectory header                              file_name = $1-$F ASCII characters: first = letters
 $F = volume directory header                                      rest are letters, digits, periods.
                                                       key_pointer = block address of file's key block
 +-----------+                                         blocks_used = total blocks for file
 | file_type |                                         EOF = byte number for end of file ($0-$FFFFFF)
 | (1 byte)  |                                         version, min_version = 0 for ProDOS 1.0
 +-----------+                                         entry_length = $27 for ProDOS 1.0
                                                       entries_per_block = $0D for ProDOS 1.0
 See section B.4.2.4                                   aux_type = defined by system program
                                                       file_count = total files in directory
                                                       bit_map_pointer = block address of bit map
                                                       total_blocks = total blocks on volume
                                                       parent_pointer = block address containing entry
                                                       parent_entry_number = number in that block
                                                       parent_entry_length = $27 for ProDOS 1.0
                                                       header pointer = block address of key block
                                                       of entry's directory
</pre>

<a name="page170"></a>

<a name="B.4.2.1"></a>


<h4>B.4.2.1 - The storage_type Attribute</h4>


<p>The storage_type, the high-order four bits of the first byte of an entry, defines the type of header (if the entry is a header) or the type of file described by the entry.</p>

<p>$0 indicates an inactive file entry $1 indicates a seedling file entry (EOF &#60;= 256 bytes) $2 indicates a sapling file entry (256 &#60; EOF &#60;= 128K bytes) $3 indicates a tree file entry (128K &#60; EOF &#60; 16M bytes) $4 indicates Pascal area $D indicates a subdirectory file entry $E indicates a subdirectory header $F indicates a volume directory header</p>

<p>The name_length, the low-order four bits of the first byte, specifies the number of characters in the file_name field.</p>

<p>ProDOS automatically changes a seedling file to a sapling file and a sapling file to a tree file when the file's EOF grows into the range for a larger type.  If a file's EOF shrinks into the range for a smaller type, ProDOS changes a tree file to a sapling file and a sapling file to a seedling file.</p>

<a name="B.4.2.2"></a>

<h4>B.4.2.2 - The creation and last_mod Fields</h4>


<p>The date and time of the creation and last modification of each file and directory is stored as two four-byte values, as shown in Figure B-13.</p>

<a name="B-13"></a>


<p><b>Figure B-13.  Date and Time Format</b></p>



<pre>
              Byte 1                          Byte 0

   7   6   5   4   3   2   1   0 | 7   6   5   4   3   2   1   0
 +---------------------------------------------------------------+
 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
 |           Year            |     Month     |        Day        |
 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
 +---------------------------------------------------------------+

 +---------------------------------------------------------------+
 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
 | 0   0   0 |       Hour        | 0   0 |        Minute         |
 |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
 +---------------------------------------------------------------+
              Byte 1                          Byte 0
</pre>


<p>The values for the year, month, day, hour, and minute are stored as binary integers, and may be unpacked for analysis.</p>

<a name="page171"></a>

<a name="B.4.2.3"></a>


<h4>B.4.2.3 - The access Attribute</h4>


<p>The access attribute field (Figure B-14) determines whether the file can be read from, written to, deleted, or renamed.  It also contains a bit that can be used to indicate whether a backup copy of the file has been made since the file's last modification.</p>

<a name="B-14"></a>


<p><b>Figure B-14.  The access Attribute Field</b></p>

<pre>
                           +-------- Write-Enable
                           |   +---- Read-Enable
                           |   |
 +-------------------------------+
 | D | RN | B | Reserved | W | R |
 +-------------------------------+
   |   |    |
   |   |    +----------------------- Backup
   |   +---------------------------- Rename-Enable
   +-------------------------------- Destroy-Enable
</pre>


<p>A bit set to 1 indicates that the operation is enabled; a bit cleared to 0 indicates that the operation is disabled.  The reserved bits are always 0.</p>

<p>ProDOS sets bit 5, the <b>backup bit</b>, of the access field to 1 whenever the file is changed (that is, after a CREATE, RENAME, CLOSE after WRITE, or SET_FILE_INFO operation).  This bit should be reset to 0 whenever the file is duplicated by a backup program.</p>

<p><b>Note:</b> Only ProDOS may change bits 2-4; only backup programs should clear bit 5, using SET_FILE_INFO.</p>

<a name="B.4.2.4"></a>


<h4>B.4.2.4 - The file_type Attribute</h4>

<p>The file_type attribute within an entry field identifies the type of file described by that entry.  This field should be used by system programs to guarantee file compatibility from one system program to the next. The values of this byte are shown in Table B-1.</p>

<a name="page172"></a>

<a name="B-1T"></a>

<p><b>Table B-1.  The ProDOS File_Types</b></p>


<p><i>The file types marked with a * apply to Apple III only; they are not ProDOS compatible.  For the file types used by Apple III SOS only, refer to the SOS Reference Manual.</i></p>

<pre>

 <b>File Type      Preferred Use</b>
 $00            Typeless file (SOS and ProDOS)
 $01            Bad block file
 $02 *          Pascal code file
 $03 *          Pascal text file
 $04            ASCII text file (SOS and ProDOS)
 $05 *          Pascal data file
 $06            General binary file (SOS and ProDOS)
 $07 *          Font file
 $08            Graphics screen file
 $09 *          Business BASIC program file
 $0A *          Business BASIC data file
 $0B *          Word Processor file
 $0C *          SOS system file
 $0D,$0E *      SOS reserved
 $0F            Directory file (SOS and ProDOS)
 $10 *          RPS data file
 $11 *          RPS index file
 $12 *          AppleFile discard file
 $13 *          AppleFile model file
 $14 *          AppleFile report format file
 $15 *          Screen Library file
 $16-$18 *      SOS reserved
 $19            AppleWorks Data Base file
 $1A            AppleWorks Word Processor file
 $1B            AppleWorks Spreadsheet file
 $1C-$EE        Reserved
 $EF            Pascal area
 $F0            ProDOS CI added command file
 $F1-$F8        ProDOS user defined files 1-8
 $F9            ProDOS reserved
 $FA            Integer BASIC program file
 $FB            Integer BASIC variable file
 $FC            Applesoft program file
 $FD            Applesoft variables file
 $FE            Relocatable code file (EDASM)
 $FF            ProDOS system file
</pre>

<a name="page173"></a>

<a name="B.5"></a>

<h2>B.5 - DOS 3.3 Disk Organization</h2>


<p>Both DOS 3.3 and ProDOS 140K flexible disks are formatted using the same 16-sector layout.  As a consequence, the ProDOS READ_BLOCK and WRITE_BLOCK calls are able to access DOS 3.3 disks too.  These calls know nothing about the organization of files on either type of disk.</p>

<p>When using READ_BLOCK and WRITE_BLOCK, you specify a 512-byte block on the disk.  When using RWTS (the DOS 3.3 counterpart to READ_BLOCK and WRITE_BLOCK), you specify the track and sector of a 256-byte chunk of data, as explained in the <i>DOS Programmer's Manual</i>.  You use READ_BLOCK and WRITE_BLOCK to access DOS 3.3 disks, you must know what 512-byte block corresponds to the track and sector you want.</p>

<p>Figure B-15 shows how to determine a block number from a given track and sector.  First multiply the track number by 8, then add the Sector Offset that corresponds to the sector number.  The half of the block in which the sector resides is determined by the Half-of-Block line (1 is the first half; 2 is the second).</p>

<a name="B-15"></a>


<p><b>Figure B-15.  Tracks and Sectors to Blocks</b></p>

<pre>
       Block = (8 * Track) + Sector Offset

        Sector : 0 1 2 3 4 5 6 7 8 9 A B C D E F
 Sector Offset : 0 7 6 6 5 5 4 4 3 3 2 2 1 1 0 7
  Half of Block: 1 1 2 1 2 1 2 1 2 1 2 1 2 1 2 2
</pre>

<p>Refer to the <i>DOS Programmer's Manual</i> for a description of the file organization of DOS 3.3 disks.</p>

<a name="page174"></a>
