---
layout:      page
title:       File Type $1A (26) - All Auxiliary Types
description: AppleWorks Word Processor File
permalink:   /docs/technote/ftn08/
---

<h2>Full Name: AppleWorks Word Processor File<br>Short Name:  AppleWorks
WP File</h2>

<h2>Revised by Matt Deatherage & John Kinder, CLARIS Corp. (September 1989)
<br>Written by Bob Lissner (February 1984)</h2>

<p>Files of this type and auxiliary type contain an AppleWorks(R) Word
Processor file.</p>

<p><em>Changes since May 1989:</em> Updated to include AppleWorks 2.1 and
AppleWorks 3.0.</p>

<hr>

<p>Files of type $1A and any auxiliary type contain an AppleWorks Word
Processor file.  AppleWorks is published by CLARIS.  CLARIS also has
additional information on AppleWorks files SEG.PR and SEG.ER.  For
information on AppleWorks, contact CLARIS at:</p>

<blockquote>CLARIS Corporation<br>
5201 Patrick Henry Drive<br>
P.O. Box 58168<br>
Santa Clara, CA 95052-8168</blockquote>

<blockquote>Technical Support<br>
Telephone:  (408) 727-9054<br>
AppleLink:  Claris.Tech</blockquote>

<blockquote)Customer Relations<br>
Telephone:  (408) 727-8227<br>
AppleLink:  Claris.CR</blockquote>

<p>AppleWorks was created by Bob Lissner.  AppleWorks 2.1 was done by Bob
Lissner and John Kinder of CLARIS.  AppleWorks 3.0 was done by Alan Bird,
Rob Renstrom and Randy Brandt of Beagle Bros Software with John Kinder of
CLARIS.</p>

<h2>Definitions</h2>

<p>The following definitions apply to AppleWorks files in addition to
those defined for all Apple II file types:</p>

<dl>
<dt>MRL</dt><dd>Data base multiple record layout</dd>
<dt>SRL</dt><dd>Data base single record layout</dd>
<dt>RAC</dt><dd>Review/Add/Change screen</dd>
<dt>DB</dt><dd>AppleWorks or /// E-Z Pieces Data Base</dd>
<dt>SS</dt><dd>AppleWorks or /// E-Z Pieces Spreadsheet</dd>
<dt>WP</dt><dd>AppleWorks or /// E-Z Pieces Word Processor</dd>
<dt>AW</dt><dd>AppleWorks or /// E-Z Pieces</dd>
</dl>

<h2>Auxiliary Type Definitions</h2>

<p>The volume or subdirectory auxiliary type word for this file type is
defined to control uppercase and lowercase display of filenames.  The
highest bit of the least significant byte corresponds to the first
character of the filename, the next highest bit of the least significant
byte corresponds to the second character, etc., through the second bit of
the most significant byte, which corresponds to the fifteenth character of
the filename.</p>

<p>AppleWorks performs the following steps when it saves a file to disk:</p>

<ol>
<li>Zeros all 16 bits of the auxiliary type word.</li>

<li>Examines the filename for lowercase letters.  If one is found, it
changes the corresponding bit in the auxiliary type word to 1 and changes
the letter to uppercase.</li>

<li>Examines the filename for spaces.  If one is found, it changes the
corresponding bit in the auxiliary type word to 1 and changes the space to
a period.</li>
</ol>

<p>When files are read from disk, the filename and auxiliary type
information from the directory file entry are used to determine which
characters should be lowercase and which periods should be displayed as
spaces.  If you use the auxiliary type bytes for a different purpose,
AppleWorks will still display the filenames, but the wrong letters are
likely lowercase.</p>

<h2>File Version Changes</h2>

<p>Certain features present in AppleWorks 3.0 files are not
backward-compatible to 2.1 and earlier versions.  Such features are noted
in the text.  AppleWorks Word Processor files which may not be loaded by
versions prior to 3.0 are identified by a non-zero byte at location +183,
referred to as location SFMinVers.</p>

<p>Those features added for AppleWorks 2.0, 2.1 and 3.0 not previously
documented are indicated with that version number in the margin.</p>

<h2>Word Processor Files</h2>

<p>Word Processor files start with a 300 byte header, followed by a number
of variable length line records, one for each line on the screen.</p>

<h3>Header Record</h3>

<p>The header contains the following information:</p>

<dl>
<dt>+000 to +003</dt><dd>Not used.</dd>

<dt>+004: Byte</dt><dd>$4F (79)</dd>

<dt>+005 to +084: Bytes</dt><dd>Tab stops.  Either equal sign (=) or vertical 
bar (|)  If SFMinVers is non-zero, these will be one of the following 
values:<dl>
<dt>"="</dt><dd>no tab</dd>
<dt>"<"</dt><dd>left tab</dd>
<dt>"^"</dt><dd>center tab</dd>
<dt>">"</dt><dd>right tab</dd>
<dt>"."</dt><dd>decimal tab.</dd></dl></dd>

<dt>+085: Byte</dt><dd>Boolean:  Zoom switch.</dd>

<dt>+086 to +089</dt><dd>Four bytes not used.</dd>

<dt>+090: Byte</dt><dd>Boolean:  Whether file is currently paginated
(i.e., whether the page break lines are displayed).</dd>

<dt>+091: Byte</dt><dd>Minimum left margin that should be added to the
margin that is appearing on the screen.  This is normally one inch, shown
in 10ths of an inch, 10 or $0A.</dd>

<dt>+092: Byte</dt><dd>Boolean:  Whether file contains any mail-merge
commands.</dd>

<dt>+093 to +175: Bytes</dt><dd>Not used.  Reserved.</dd>

<dt>+176: Byte (3.0)</dt><dd>Boolean:  Whether there are multiple rulers 
in the document.</dd>

<dt>+177 to +182: Bytes (3.0)</dt><dd>Used internally for keeping track of
tab rulers.</dd>

<dt>+183: Byte (3.0)</dt><dd>SFMinVers.  The minimum version of AppleWorks
needed to read this document.  If this document contains 3.0 specific
features (tabs and multiple tab rulers, for example), this byte will
contain the version number 30 ($1E).  Otherwise, it will be zero ($00).</dd>

<dt>+184 to +249: Bytes</dt><dd>Reserved.</dd>

<dt>+250 to +299: Bytes</dt><dd>Available.  Will never be used by
AppleWorks.  If you are creating this type of file, you can use this area
to keep information that is important to your program.</dd>
</dl>

<h3>Line Records</h3>

<p>Line records are of three different types.  The first line record after
the 300 byte header corresponds to line 1, the next is line 2, and so on.  
The first two bytes of each line record contain enough information to
establish the type.</p>

<p>If SFMinVers is non-zero, the first line record (two bytes long) is
invalid and should be skipped.</p>

<h4>Carriage Return Line Records</h4>

<p>Carriage return line records have a $D0 (208) in byte +001.  Byte +000
is a one byte integer between 00 and 79 that is the horizontal screen
position of this carriage return.</p>

<h4>Command Line Records</h4>

<p>Command line records are formatting commands that appear on the screen 
in the form:</p>

<pre>

--------Double Space

</pre>

<p>for example.  These records can be identified by a value greater than 
$D0 (208) in byte +001. They are:</p>

<dl>
<dt>Byte +001: Command</dt><dd>Byte +000</dd>
<hr>
<dt>$D4: reserved (3.0)</dt><dd>(used internally as ruler)</dd>
<dt>$D5: Page header end (3.0)</dt>
<dt>$D6: Page footer end (3.0)</dt>
<dt>$D7: Right justified (3.0)</dt>
<dt>$D8: Platen width</dt><dd>Byte: 10ths of an inch</dd>
<dt>$D9: Left margin</dt><dd>Byte: 10ths of an inch</dd>
<dt>$DA: Right margin</dt><dd>Byte: 10ths of an inch</dd>
<dt>$DB: Chars per inch</dt><dd>Byte</dd>
<dt>$DC: Proportional-1</dt><dd>No meaning</dd>
<dt>$DD: Proportional-2</dt>
<dt>$DE: Indent</dt><dd>Byte: Characters</dd>
<dt>$DF: Justify</dt>
<dt>$E0: Unjustify</dt>
<dt>$E1: Center</dt>
<dt>$E2: Paper length</dt><dd>Byte: 10ths of an inch</dd>
<dt>$E3: Top margin</dt><dd>Byte: 10ths of an inch</dd>
<dt>$E4: Bottom margin</dt><dd>Byte: 10ths of an inch</dd>
<dt>$E5: Lines per inch</dt><dd>Byte</dd>
<dt>$E6: Single space</dt>
<dt>$E7: Double space</dt>
<dt>$E8: Triple space</dt>
<dt>$E9: New page</dt>
<dt>$EA: Group begin</dt>
<dt>$EB: Group end</dt>
<dt>$EC: Page header</dt>
<dt>$ED: Page footer</dt>
<dt>$EE: Skip lines</dt><dd>Byte: Count</dd>
<dt>$EF: Page number</dt><dd>Byte</dd>
<dt>$F0: Pause each page</dt>
<dt>$F1: Pause here</dt>
<dt>$F2: Set marker</dt><dd>Byte: Marker number</dd>
<dt>$F3: Page number</dt><dd>Byte: (add 256)</dd>
<dt>$F4: Page break</dt><dd>Byte: Page number</dd>
<dt>$F5: Page break</dt><dd>Byte: (add 256)
<dt>$F6: Page break</dt><dd>Byte: (break in middle of paragraph)
<dt>$F7: Page break</dt><dd>Byte: (add 256 in middle of paragraph)
<dt>$FF: End of file</dt>
</dl>

<h3>Text Records</h3>

<p>Text records are the lines where text has been typed.  The format is:</p>

<dl>
<dt>+000 to +001: Word</dt><dd>Number of bytes following this word.  
Since the maximum is about 80, byte +001 is always zero.  Use byte +001 to
identify text lines.</dd>

<dt>+002 (3.0)</dt><dd>If bit 7 is on, this line contains Tab and Tab
Filler special codes (described below).  The remaining seven bits are the
screen column for the first text character.  Usually will be zero, but may
vary as a result of left margin, centering, and indent commands. If this
byte is $FF, this text line is actually a ruler -- ASCII equivalent of what
appears on the top of the screen.</dd>

<dt>+003: Byte</dt><dd>If bit 7 (the high bit) of this byte is on, there
is a carriage return on the end of this line.  If off, no carriage return.
Bits 6-0:  Number of bytes of text following this byte.</dd>

<dt>+004 to nnn</dt><dd>Actual text bytes.  Consists of ASCII characters
and special codes.  The special codes are values from $01 to $1F, and
indicate special formatting features:<br>
$01: Begin boldface<br>
$02: Boldface end<br>
$03: Superscript begin<br>
$04: Superscript end<br>
$05: Subscript begin<br>
$06: Subscript end<br>
$07: Underline begin<br>
$08: Underline end<br>
$09: Print page number<br>
$0A: Enter keyboard<br>
$0B: Sticky space<br>
$0C: Begin Mail merge<br>
$0D: Reserved (3.0)<br>
$0E: Print Date (3.0)<br>
$0F: Print Time (3.0)<br>
$10: Special Code 1 (3.0)<br>
$11: Special Code 2 (3.0)<br>
$12: Special Code 3 (3.0)<br>
$13: Special Code 4 (3.0)<br>
$14: Special Code 5 (3.0)<br>
$15: Special Code 6 (3.0)<br>
$16: Tab character (3.0)<br>
$17: Tab fill character (3.0) (used in formatting lines)<br>
$18: Reserved (3.0)</dd>
</dl>

<h2>File Tags</h2>

<p>All AppleWorks files normally end with two bytes of $FF; tags are 
anything after that.  Although File Tags were primarily designed by 
Beagle Bros, they can be used by any application that needs to create or 
modify an AppleWorks 3.0 file.</p>

<p>Because versions of AppleWorks before 3.0 stop at the double $FF, they 
simply ignore tags.</p>

<p>The File Tag structure is as follows:</p>

<dl>
<dt>+000: Byte</dt><dd>Tag ID.  Should be $FF.</dd>

<dt>+001: Byte</dt><dd>2nd ID byte.  These values will be defined and
arbitrated by Beagle Bros Software.  Beagle may be reached at:<br><br>
Beagle Bros Inc<br>
6215 Ferris Square, #100<br>
San Diego, CA  92121</dd>

<dt>+002 to +003: Word</dt><dd>Data length.  If this is the last tag on
the file, the low byte (+002)  will be a count of the tags in this file,
and the high byte (+003) will be $FF.</dd>

<dt>+004 to nnn: Bytes</dt><dd>Actual tag data, immediately followed by
the next four-byte tag ID.  These bytes do not exist for the last tag.</dd>
</dl>

<p>There is a maximum of 64 tags per file.  Each tag may be no larger than 
2K.</p>

<hr>

{% include technote_credit.html %}
