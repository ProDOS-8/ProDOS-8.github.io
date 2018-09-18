---
layout:      page
title:       File Type $19 (25) - All Auxiliary Types
description: AppleWorks Data Base File
permalink:   /docs/technote/ftn08/
---


<h2>Full Name: AppleWorks Data Base File<br>Short Name: AppleWorks DB 
File</h2>

<h2>Revised by Matt Deatherage & John Kinder, Claris Corporation (July 
1990)
<br>Written by Bob Lissner (February 1984)</h2>

<p>Files of this type and auxiliary type contain an AppleWorks(R) Data 
Base file.</p>

<p><em>Changes since September 1989:</em> Corrected the description of
offset +337 in the header.</p>

<hr>

<p>Files of type $19 and any auxiliary type contain an AppleWorks Data
Base file.  AppleWorks is published by Claris.  Claris also has additional
information on AppleWorks files SEG.PR and SEG.ER.  For information on
AppleWorks, contact Claris at:</p>

<blockquote>Claris Corporation
<br>5201 Patrick Henry Drive
<br>P.O. Box 58168
<br>Santa Clara, CA 95052-8168</blockquote>

<blockquote>Technical Support
<br>Telephone:  (408) 727-9054
<br>AppleLink:  Claris.Tech</blockquote>

<blockquote>Customer Relations
<br>Telephone:  (408) 727-8227
<br>AppleLink:  Claris.CR</blockquote>

<p>AppleWorks was created by Bob Lissner.  AppleWorks 2.1 was done by Bob
Lissner and John Kinder of Claris.  AppleWorks 3.0 was done by Randy
Brandt, Alan Bird and Rob Renstrom of Beagle Bros Software with John
Kinder of Claris.</p>


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
in the text.  AppleWorks Data Base files which may not be loaded by
versions prior to 3.0 are identified by a non-zero byte at location +218,
referred to as location DBMinVers.</p>

<p>Those features added for AppleWorks 2.0, 2.1 and 3.0 not previously
documented are indicated with that version number in the margin.</p>

<h2>Data Base Files</h2>

<p>Data base files start with a variable length header, followed by 600
bytes for each report format (if any), the standard values record, then
variable length information for each record.</p>

<h3>Header Record</h3>

<p>The header contains category names, record selection rules, counts,
screen positioning information, and all other non-record specific
information.</p>

<dl>
<dt>+000 to +001: Word</dt><dd>The number of bytes in the remainder of the
header record.  Use this count for your next ProDOS read from the disk.</dd>

<dt>+002 to +029</dt><dd>Ignore these bytes.</dd>

<dt>+030: Byte</dt><dd>Cursor direction when the Return key is pressed in
SRL.  $01: Order in which you defined categories or $02:  Left to right,
top to bottom.</dd>

<dt>+031: Byte</dt><dd>What direction should the cursor go when you press
the Return key in the MRL?  D)own or R)ight.</dd>

<dt>+032 to +033</dt><dd>Ignore these bytes.</dd>

<dt>+034: Byte</dt><dd>Style of display that Review/Add/Change was using
when the file was saved:  R: SRL.  Slash (/): MRL.</dd>

<dt>+035: Byte</dt><dd>Number of categories per record.  Values from $01 to
$1E.</dd>

<dt>+036 to +037: Word (3.0)</dt><dd>Number of records in file. If
DBMinVers is non-zero, the high bit of this word may be set.  If it is,
there are more than eight reports and the remaining 15 bits contain the
true number of records defined.</dd>

<dt>+038: Byte (3.0)</dt><dd>Number of reports in a file, maximum of 8 (20
for 3.0).</dd>

<dt>+039 to +041</dt><dd>Ignore these bytes.</dd>

<dt>+042 to +071: Byte</dt><dd>For each of up to 30 columns, showing the
number of spaces used for this column on the MRL.  Be sure you understand
that categories may have been rearranged on the MRL.  Byte +042 refers to
the leftmost column on the MRL.</dd>

<dt>+072 to +077</dt><dd>Ignore six bytes.</dd>

<dt>+078 to +107: Byte</dt><dd>For up to 30 categories on the MRL, the
defined category that appears in each position.  Byte +078 is the leftmost
column of the MRL and has a value from $01 to $1E that defines which of
the category names appears in this position.  These numbers change as a
result of changing the layout of the MRL.</dd>

<dt>+108 to +113</dt><dd>Ignore six bytes.</dd>

<dt>+114 to +143: Byte</dt><dd>For up to 30 categories on the SRL, the
horizontal screen position.  These are changed as a result of changing the
layout of the SRL.  AppleWorks makes sure that these entries, and the
vertical screen positions, are kept in order from left to right within top
to bottom.</dd>

<dt>+144 to +149</dt><dd>Ignore these six bytes.</dd>

<dt>+150 to +179: Byte</dt><dd>For up to 30 categories on the SRL, the
vertical screen position.</dd>

<dt>+180 to +185</dt><dd>Ignore six bytes.</dd>

<dt>+186 to +215: Bytes</dt><dd>For up to 30 categories on the SRL, which
of the category names appears in this position. These change as a result
of changing the SRL.  This number refers to the category names listed
below.</dd>

<dt>+216 to +217</dt><dd>Ignore two bytes.</dd>

<dt>+218: Byte (3.0)</dt><dd>DBMinVers.  The minimum version of AppleWorks
needed to read this file.  This will be $00 unless there are more than 8
report formats; it will then contain the version number 30 ($1E) or
greater.</dd>

<dt>+219: Byte</dt><dd>The first frozen column in the titles.</dd>

<dt>+220: Byte (3.0)</dt><dd>If this is zero, no titles are present.  If
non-zero, this is the last frozen column.</dd>

<dt>+221: Byte (3.0)</dt><dd>Leftmost active column.  This is zero-based;
if this value is zero, it means column one, etc.</dd>

<dt>+222: Byte</dt><dd>Number of categories on MRL.  Will be less than or
equal to the number of categories in the file.  SRL displays all
categories, so there is no equivalent number for SRL.</dd>

<dt>+223 to +224: Word</dt><dd>For the first line of RAC selection rules.  
Zero means no selection rules, while any other value refers to the
category name that is tested.  The high byte will always be zero.</dd>

<dt>+225 to +226: Word</dt><dd>Category name for the second line of RAC
selection rules.  Zero means that there is only one line.</dd>

<dt>+227 to +228: Word</dt><dd>Category name for the third line of RAC
selection rules.  Zero means that there is no third line.</dd>

<dt>+229 to +230: Word</dt><dd>For the first line of RAC rules, which of
the tests is to be applied.  1 means equals, 2 means greater than and so
on.</dd>

<dt>+231 to +232: Word</dt><dd>Test for the second line of rules, if any.</dd>

<dt>+233 to +234: Word</dt><dd>Test for the third line, if any.</dd>

<dt>+235 to +236: Word</dt><dd>Continuation code for the first line:  1:
And, 2: Or, 3: Through.</dd>

<dt>+237 to +238: Word</dt><dd>Continuation code for the second line.</dd>

<dt>+239 to +240: Word</dt><dd>Continuation code for the third line.  Not
possible, so it is always zero.</dd>

<dt>+241 to +272: String</dt><dd>Maximum length of 30 bytes.  Comparison
information for the first line RAC selection rules.</dd>

<dt>+273 to +304: String</dt><dd>Comparison for the second line.</dd>

<dt>+305 to +336: String</dt><dd>Comparison for the third line.</dd>

<dt>+337 to +356</dt><dd>Ignore these twenty bytes.</dd>

<dt>+357 to +378: String</dt><dd>Name of the first category.  Maximum
length of 20 bytes.  If the file has only one category, the header record
will end here.</dd>

<dt>+379 to +400: String</dt><dd>Name of the second category, if any.  This 
area will not be on the header record if there is only one category.</dd>

<dt>+401: 22 Bytes</dt><dd>Additional 22 byte entries for all remaining
categories.  The size of the header record depends on the number of
categories.  Space is not maintained past the last category.</dd>
</dl>

<h3>Report Records</h3>

<p>Report records follow the header record.  One of the header record
categories tells you how many report records to expect.  The number will
be from zero to eight.  Each report record is 600 bytes, and contains:</p>

<dl>
<dt>+000 to +019: String</dt><dd>Report name.  Maximum length of 19
characters.</dd>

<dt>+020 to +052: Bytes</dt><dd>Column width for up to 33 columns in a
tables-style report format.  Byte +020 is for the leftmost column on a
tables-style report.  There can be up to 30 categories from the file, plus
3 more calculated columns.<br>For labels-style report formats, the value
is a byte that has the horizontal position of this category, relative to
the left margin.</dd>

<dt>+053 to +055</dt><dd>Skip 3 bytes.</dd>

<dt>+056 to +088: Bytes</dt><dd><dl>
<dt>For tables-style:</dt><dd>Number of spaces to be printed at the right
of justified columns.</dd>
<dt>For labels-style:</dt><dd>Vertical position on the report for each of
up to 30 categories.  A value of 1 means that category is on the first
line of labels-style report.</dd></dl></dd>

<dt>+089 to +091</dt><dd>Skip 3 bytes.</dd>

<dt>+092 to +124: Bytes</dt><dd><dl>
<dt>For up to 33 columns of tables-style:</dt><dd>Values from 1 to 30
refer to which category name appears in this column on the report.  
Values of 80, $81 and $82 are the three calculated categories, from left
to right.</dd>
<dt>For labels-style:</dt><dd>Same as tables-style, minus the calculated
categories.</dd></dl></dd>

<dt>+125 to +127</dt><dd>Skip these three bytes.</dd>

<dt>+128 to +160: Bytes</dt><dd><dl>
<dt>For up to 33 columns of tables-style:</dt><dd>$99 means no foot
totals, 0 through 4 means the number of decimal places for a foot
total.</dd>
<dt>For labels-style:</dt><dd>For up to 30 categories on report, Boolean
bytes whether or not category names are to be printed.</dd></dl></dd>

<dt>+161 to +163</dt><dd>Skip these three bytes.</dd>

<dt>+164 to +196: Bytes</dt><dd><dl>
<dt>For up to 33 columns of tables-style:</dt><dd>$99 means left
justified, 0 through 4 means right justified with 0 to 4 decimal 
places.</dd>
<dt>For up to 30 categories of labels-style:</dt><dd>Boolean bytes whether 
or not to float (OA-J) this category up against the category to its 
left.</dd></dl></dd>

<dt>+197 to +199</dt><dd>Skip three bytes.</dd>

<dt>+200: Byte</dt><dd>Number of categories on report.  Includes
calculated categories, if any.</dd>

<dt>+201: Byte</dt><dd><dl>
<dt>Tables-style.</dt><dd>If there is at least one calculated category,
this contains values from 1 to 33: which column of the report.</dd>
<dt>Labels-style:</dt><dd>Values from 3 to 21.  Position of the line on
the screen that says "Each record will print nn lines."</dd></dl></dd>

<dt>+202: Byte</dt><dd><dl>
<dt>Tables-style:</dt><dd>Same as +201, but for the second calculated
category, if any.</dd>
<dt>Labels-style:</dt><dd>Unused.</dd></dl></dd>

<dt>+203: Byte</dt><dd><dl>
<dt>Tables-style:</dt><dd>Same as +201, but for the third calculated
category, if any.</dd>
<dt>Labels-style:</dt><dd>Unused</dd></dl></dd>

<dt>+204: Byte</dt><dd>Tables-style only:  If there is a group total
column, this byte states which of the category names is used as a basis.  
Values from 1 to 30.</dd>

<dt>+205: Byte</dt><dd>Platen width value, in 10ths of an inch.  For
example, a value of 8.0 inches entered by the user will show as 80 or
$50.</dd>

<dt>+206: Byte</dt><dd>Left margin value.  All inches values are in 10ths.</dd>

<dt>+207: Byte</dt><dd>Right margin value.</dd>

<dt>+208: Byte</dt><dd>Characters per inch.</dd>

<dt>+209: Byte</dt><dd>Paper length value, in 10ths of an inch.</dd>

<dt>+210: Byte</dt><dd>Top margin value.</dd>

<dt>+211: Byte</dt><dd>Bottom margin value.</dd>

<dt>+212: Byte</dt><dd>Lines per inch.  6 or 8.</dd>

<dt>+213: Byte</dt><dd>Not relevant.  Probably always a "C."</dd>

<dt>+214: Byte</dt><dd>Type of report format.  H: tables-style, V:
labels-style.</dd>

<dt>+215: Byte</dt><dd>Spacing:  S(ingle, D(ouble, or T(riple.  Expect
these three letters, even in European versions.</dd>

<dt>+216: Byte</dt><dd>Print report header.  Boolean.</dd>

<dt>+217: Byte</dt><dd>Tables-style:  If user has specified group totals,
Boolean, just print the group totals.</dd>

<dt>+218: Byte</dt><dd>Labels-style:  Boolean, omit the line when all
entries on the line are blank.</dd>

<dt>+219: Byte</dt><dd>Labels-style:  Boolean, keep the number of lines
the same within each record.</dd>

<dt>+220 to +301: String</dt><dd>80-byte string.  Title line, if any.</dd>

<dt>+302 to +323: String</dt><dd>Tables-style.  20-byte string.  Name of
the first calculated category, if any.</dd>

<dt>+324 to +355: String</dt><dd>Tables-style.  30-byte string.  
Calculation rules for first calculated category, if any.</dd>

<dt>+356 to +409: String</dt><dd>Tables-style.  Name and rules for second
calculated category, if any.</dd>

<dt>+410 to +463: String</dt><dd>Tables-style.  Name and rules for third
calculated category, if any.</dd>

<dt>+464 to +477: String</dt><dd>If user has specified "Send special codes
to printer," this is a 13 byte string containing those codes.</dd>

<dt>+478: Byte</dt><dd>Boolean:  Print a dash when an entry is blank.</dd>

<dt>+479 to +592: Words & Strings</dt><dd>Record selection rules.  Exact
same format as described in the header record.</dd>

<dt>+593 to +599</dt><dd>Unused</dd>
</dl>

<h3>Data Records</h3>

<p>Data records follow the report records.  The first data record contains
the standard values.  Each following data record corresponds to one data
base record.</p>

<p>These records contain all of the categories within one stream of data.  
The category entries are in the same order that the category names appear
in the header record.</p>

<p>Bytes +0 and +1 are a word that contains a count of the number of bytes
in the remainder of the record.</p>

<p>Byte +2 of each record will always be a control byte.  Other control
bytes within each record define the contents of the record.  Control bytes
may be:</p>

<dl>
<dt>$01-$7F</dt><dd>This is a count of the number of following bytes that
are the contents of a category.</dd>

<dt>$81-$9E</dt><dd>This (minus $80) is a count of the number of
categories to be skipped.  For example, $82 means skip two categories.</dd>

<dt>$FF</dt><dd>This indicates the end of the record.</dd>
</dl>

<p>The information in individual categories may have some special coding
so that date and time entries can be arranged (sorted).</p>

<p>Date entries have the following format:</p>

<dl>
<dt>+000: Byte</dt><dd>$C0 (192).  Identifies a date entry.</dd>

<dt>+001 to 002: Two bytes</dt><dd>ASCII year code, like "84" ($38 $34).</dd>

<dt>+003: Byte</dt><dd>ASCII month code.  A means January, L means 
December.</dd>

<dt>+004 to +005: Two bytes</dt><dd>ASCII day of the month, like "31" ($33
$31).</dd>
</dl>

<p>Time entries have the following format:</p>

<dl>
<dt>+000: Byte</dt><dd>$D4 (212).  Identifies a time entry.</dd>

<dt>+001: Byte</dt><dd>ASCII hour code.  A means 00 (the hour after
midnight).  X means 23, the hour before midnight.</dd>

<dt>+002 to +003: Two bytes</dt><dd>ASCII minute code.  Values from 00 to 
59.</dd>
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
the next four-byte tag ID.  These bytes do not exist for the last
tag.</dd>
</dl>

<p>There is a maximum of 64 tags per file.  Each tag may be no larger than 
2K.</p>

<hr>

{% include technote_credit.html %}
