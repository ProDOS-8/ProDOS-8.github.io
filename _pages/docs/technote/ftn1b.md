---
layout:      'page'
title:       'File Type $1B (27) - All Auxiliary Types'
description: 'AppleWorks Spreadsheet File'
permalink:   '/docs/technote/ftn/1b/'
---




<h2>Full Name: AppleWorks Spreadsheet File<br>Short Name: AppleWorks SS 
File</h2>

<h2>Revised by Matt Deatherage & John Kinder, CLARIS Corp. (September 1989)
<br>Written by Bill Lissner (February 1984)</h2>

<p>Files of this type and auxiliary type contain an AppleWorks(R)  
Spreadsheet file.

<p><em>Changes since May 1989:</em> Updated to include AppleWorks 2.1 and
AppleWorks 3.0.</p>

<hr>

<p>Files of type $1B and any auxiliary type contain an AppleWorks
Spreadsheet file.  AppleWorks is published by CLARIS.  CLARIS also has
additional information on AppleWorks files SEG.PR and SEG.ER.  For
information on AppleWorks, contact CLARIS at:</p>

<blockquote>CLARIS Corporation<br>
5201 Patrick Henry Drive<br>
P.O. Box 58168<br>
Santa Clara, CA 95052-8168</blockquote>

<blockquote>Technical Support<br>
Telephone:  (408) 727-9054<br>
AppleLink:  Claris.Tech</blockquote>

<blockquote>Customer Relations<br>
Telephone:  (408) 727-8227<br>
AppleLink:  Claris.CR</blockquote>

<p>AppleWorks was created by Bob Lissner.  AppleWorks 2.1 was done by Bob
Lissner and John Kinder of CLARIS.  AppleWorks 3.0 was done by Rob
Renstrom, Randy Brandt and Alan Bird of Beagle Bros Software with John
Kinder of CLARIS.</p>

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
in the text.  AppleWorks spreadsheet files which may not be loaded by
versions prior to 3.0 are identified by a non-zero byte at location +242,
referred to as location SSMinVers.</p>

<p>Those features added for AppleWorks 2.0, 2.1 and 3.0 not previously
documented are indicated with that version number in the margin.</p>

<h2>Spreadsheet Files</h2>

<p>Spreadsheet files start with a 300 byte header record that contains 
basic information about the file, including column widths, printer 
options, window definitions, and standard values.</p>

<h3>Header Record</h3>

<p>The spreadsheet header record contains the following entries:</p>

<dl>
<dt>+000 to +003</dt><dd>Skip 4 bytes.</dd>

<dt>+004 to +130: Bytes</dt><dd>The column width for each column.</dd>

<dt>+131: Byte</dt><dd>Order of recalculation.  ASCII R or C.</dd>

<dt>+132: Byte</dt><dd>Frequency of recalculation.  ASCII A or M.</dd>

<dt>+133 to +134: Word</dt><dd>Last row referenced.</dd>

<dt>+135: Byte</dt><dd>Last column referenced.</dd>

<dt>+136: Byte</dt><dd>Number of windows:  ASCII 1:  just one window, S:
side by side windows, T: top and bottom windows.</dd>

<dt>+137: Byte</dt><dd>Boolean:  If there are two windows, are they
synchronized?</dd>

<dt>+138 to +161</dt><dd>The next 20 (approximately)  variables are for
the current window.  If there is only one window, it is the current
window.  If there are two windows, the current window is the window that
had the cursor in it.</dd>

<dt>+138: Byte</dt><dd>Window standard format for label cells.  2: left
justified, 3: right justified, 4: centered.</dd>

<dt>+139: Byte</dt><dd>Window standard format for value cells.  2: fixed,
3: dollars, 4:  commas, 5: percent, 6: appropriate</dd>

<dt>+140: Byte</dt><dd>More of window standard format for value cells.  
Number of decimal places to display.  Values from 0 to 7.</dd>

<dt>+141: Byte</dt><dd>Top screen line used by this window.  This is the
line that the =====A=========B==== appears on.  Normally 1 unless there
are top and bottom windows.</dd>

<dt>+142: Byte</dt><dd>Leftmost screen column used by this window.  This
is the column that the hundreds digit of the row number appears in.  
Normally 0 unless there are side-by-side windows.</dd>

<dt>+143 to +144: Word</dt><dd>Top, or first, row appearing in titles
area.  This will probably be 0 if there are no top titles.</dd>

<dt>+145: Byte</dt><dd>Leftmost, or first, column appearing in left titles
area.  This will probably be 0 if there are no left titles.</dd>

<dt>+146 to +147: Word</dt><dd>Last row appearing in top titles area.  
This will probably be zero if there are no top titles.</dd>

<dt>+148: Byte</dt><dd>Last column appearing in left titles area. This
will probably be zero if there are no left titles.</dd>

<dt>+149 to +150: Word</dt><dd>Top, or first, row appearing in the body of
the window.  The body is defined as those rows that are on the screen, but
not in the titles area.</dd>

<dt>+151: Byte</dt><dd>Leftmost, or first, column appearing in the body of
the window.</dd>

<dt>+152: Byte</dt><dd>The screen line that the top body row goes on.  
Normally 2, unless there are top titles or top and bottom windows.</dd>

<dt>+153: Byte</dt><dd>Leftmost screen column used for the leftmost body
column.  Normally 4 unless there are side titles, or side-by-side
windows.</dd>

<dt>+154 to +155: Word</dt><dd>Bottom, or last, row appearing in this 
window.</dd>

<dt>+156: Byte</dt><dd>Rightmost, or last, column appearing in this
window.</dd>

<dt>+157: Byte</dt><dd>The screen line that the last body row goes on.  
Normally $13 (19)  unless there are top and bottom windows.</dd>

<dt>+158: Byte</dt><dd>The rightmost screen column used by this window.  
Normally $4E (78)  unless there are side-by-side windows.</dd>

<dt>+159: Byte</dt><dd>Number of horizontal screen locations used to
display the body columns.  Normally $48 (72), because 8 columns of 9
characters each are the standard display.  This is affected by
side-by-side windows, side titles, and variable column widths.</dd>

<dt>+160: Byte</dt><dd>Boolean:  Rightmost column is not fully displayed.  
This can only happen when the body portion of the window is narrower than
the width of a particular column.</dd>

<dt>+161: Flag Byte</dt><dd>Titles switch for this window.  Bit 7:  top
titles, Bit 6:  side titles.  These bits represent top titles, side
titles, both, and no titles.</dd>

<dt>+162 to +185</dt><dd>Window information for the second window.  This
is meaningful only if there are two windows.  This is the information for
the window that the cursor is not currently in.  See the descriptions for
the current window (+138 to +161).</dd>

<dt>+186 to +212</dt><dd>Not currently used.</dd>

<dt>+213: Byte</dt><dd>Boolean:  Cell protection is on or off.</dd>

<dt>+214</dt><dd>Not currently used.</dd>

<dt>+215: Byte</dt><dd>Platen width value, in 10ths of an inch.  For
example, a value of 80 inches entered by the user will show as 80 or
$50.</dd>

<dt>+216: Byte</dt><dd>Left margin value.  All inches values are in 10ths
of an inch.</dd>

<dt>+217: Byte</dt><dd>Right margin value.</dd>

<dt>+218: Byte</dt><dd>Characters per inch.</dd>

<dt>+219: Byte</dt><dd>Paper length value, in 10ths of an inch.</dd>

<dt>+220: Byte</dt><dd>Top margin value.</dd>

<dt>+221: Byte</dt><dd>Bottom margin value.</dd>

<dt>+222: Byte</dt><dd>Lines per inch.  6 or 8.</dd>

<dt>+223: Byte</dt><dd>Spacing:  S(ingle, D(ouble, or T(riple.  Expect
these three letters, even in European versions.</dd>

<dt>+224 to +237: Bytes</dt><dd>If user has specified "Send special codes
to printer," this is a 13-byte string containing those codes.</dd>

<dt>+238: Byte</dt><dd>Boolean:  Print a dash when an entry is blank.</dd>

<dt>+239: Byte</dt><dd>Boolean:  Print report header.</dd>

<dt>+240: Byte</dt><dd>Boolean:  Zoomed to show formulas.</dd>

<dt>+241: Byte (2.1)</dt><dd>Reserved; used internally.</dd>

<dt>+242: Byte (3.0)</dt><dd>SSMinVers.  The minimum version of AppleWorks
needed to read this document.  If this document contains version
3.0-specific functions (such as calculated labels or new functions), this
byte will contain the version number 30 ($1E).  Otherwise, it will be zero
($00).</dd>

<dt>+243 to +249</dt><dd>Reserved for future use.</dd>

<dt>+250 to +299</dt><dd>Available.  Will never be used by AppleWorks.  
If you are creating these files, you can use this area to keep information
that is important to your program.</dd>
</dl>

<h3>Row Records</h3>

<p>Row records contain a variable amount of information about each row
that is non-blank.  Each row record contains enough information to
completely build one row of the spreadsheet:</p>

<dl>
<dt>+000 to +001: Word (3.0)</dt><dd>Number of additional bytes to read
from disk.  $FFFF means end of file.  If SFMinVers is not zero, these two
bytes are invalid and should be skipped.  The first row record begins at
+302 in an AW 3.0 SS file.</dd>

<dt>+002 to +003: Word</dt><dd>Row number.</dd>

<dt>+004: Byte</dt><dd>Beginning of actual information for the row.  This
byte of each record will always be a control byte.  Other control bytes
within each record define the contents of the record.  Control bytes may
be: <dl>
<dt>$01-$7F</dt><dd>This is a count of the number of following bytes that
are the contents of a cell entry.</dd>
<dt>$81-$FE</dt><dd>This (minus $80) is a count of the number of columns
to be skipped.  For example, $82 means skip two columns.</dd>
<dt>$FF</dt><dd>This indicates the end of the row.</dd></dl></dd>
</dl>

<h3>Cell Entries</h3>

<p>Cell entries contain all the information that is necessary to build one 
cell.  There are several types:</p>

<h4>Value Constants</h4>

<p>Value constants are cells that have a value that cannot change.  This 
means that someone typed a constant into the cell, 3.14159, for example.</p>

<dl>
<dt>+000: Flag Byte</dt><dd>Bit 7 is always on.<br>
Bit 6 on means that if the value is zero, display a blank instead of a zero.  
This is for pre-formatted cells that still have no value.<br>
Bit 5 is always on.<br>
Bit 4 on means that labels cannot be typed into this cell.<br>
Bit 3 on means that values cannot be typed into this cell.<br>
Bits 2,1, and 0 specify the formatting for this cell:<ol>
<li>Use spreadsheet standard</li>
<li>Fixed</li>
<li>Dollars</li>
<li>Commas</li>
<li>Percent</li>
<li>Appropriate</li></ol></dd>

<dt>+001: Flag Byte</dt><dd>Bit 7 is always zero.<br>
Bit 6 is always zero.<br>
Bit 5 is always zero.<br>
Bit 4 on indicates that this cell must be calculated the next time this 
spreadsheet is calculated, even if none of the referenced cells are changed.  
This bit makes sense on for cells that have a calculated formula.<br>
Bits 2, 1, and 0:  Number of decimal places for fixed, dollars, commas, or 
percent formats.</dd>

<dt>+002 to +009</dt><dd>8-byte SANE double format floating point number.</dd>
</dl>

<h4>Value Labels</h4>

<blockquote><em>Note:</em> The entire Value Labels cell record entry
requires AppleWorks 3.0 or later.</blockquote>

<p>Value labels are cells whose function has returned a label value.  
Formulas like @Lookup, @Choose and @IF can all return labels as their 
results.  Specific format:</p>

<dl>
<dt>+000: Flag Byte</dt><dd>Bit 7 is always one.<br>
Bit 6 on means not to display the cell.  This was originally intended for 
pre-formatted cells that still have no value.  If a value is placed in this 
cell, be sure to turn this bit off.<br>
Bit 5 is always zero.<br>
Bits 4, 3, 2, 1, and 0 are the same as regular label cells.</dd>

<dt>+001: Flag Byte</dt><dd>Bit 7 is always one.<br>
Bit 6 set indicates the last evaluation of this formula resulted in @NA.<br>
Bit 5 set indicates the last evaluation of his formula resulted in @Error.<br>
Bit 4 on indicates that this cell must be calculated the next time this 
spreadsheet is calculated, even if none of the referenced cells are changed.<br>
Bit 3 is always one.<br>
Bits 2-0 are ignored.</dd>

<dt>+002 to nnn: String</dt><dd>Pascal string containing characters to 
display.</dd>

<dt>+nnn+1 to xxx: Bytes</dt><dd>Various control bytes that are "tokens"  
representing the formula that was typed by the user.  They are defined
below.</dd>
</dl>

<h4>Value Formulas</h4>

<p>Value formulas are cells that contain information that has to be
evaluated.  Formulas like AA17+@sum(r19...r21) and @Error are examples.  
Specific format:</p>

<dl>
<dt>+000: Flag Byte</dt><dd>Bit 7 is always on.<br>
Bit 6 on means to not display the cell.  This was originally intended for
pre-formatted cells that still have no value.  If a value is placed in
this cell, be sure to turn off this bit.<br>
Bit 5 is always off.<br>
Bits 4, 3, 2, 1, and 0 are the same as value constants.</dd>

<dt>+001</dt><dd>Bit 7 is always on.<br>
Bit 6 on indicates that the last evaluation of this formula resulted in an 
@NA.<br>
Bit 5 on indicates that the last evaluation of this formula resulted in an 
@Error.<br>
Bits 4, 2, 1, and 0 are the same as value constants.</dd>

<dt>+002 to +009</dt><dd>8-byte SANE double floating point number that is
the most recent evaluation of this cell.</dd>

<dt>+010 to nnn</dt><dd>Various control bytes that are tokens representing
the formula that was entered by the user.  They are:<dl>
<dt>$C0 (3.0)</dt><dd>@Deg</dd>
<dt>$C1 (3.0)</dt><dd>@Rad</dd>
<dt>$C2 (3.0)</dt><dd>@Pi</dd>
<dt>$C3 (3.0)</dt><dd>@True</dd>
<dt>$C4 (3.0)</dt><dd>@False</dd>
<dt>$C5 (3.0)</dt><dd>@Not</dd>
<dt>$C6 (3.0)</dt><dd>@IsBlank</dd>
<dt>$C7 (3.0)</dt><dd>@IsNA</dd>
<dt>$C8 (3.0)</dt><dd>@IsError</dd>
<dt>$C9 (3.0)</dt><dd>@Exp</dd>
<dt>$CA (3.0)</dt><dd>@Ln</dd>
<dt>$CB (3.0)</dt><dd>@Log</dd>
<dt>$CC (3.0)</dt><dd>@Cos</dd>
<dt>$CD (3.0)</dt><dd>@Sin</dd>
<dt>$CE (3.0)</dt><dd>@Tan</dd>
<dt>$CF (3.0)</dt><dd>@ACos</dd>
<dt>$D0 (3.0)</dt><dd>@ASin</dd>
<dt>$D1 (3.0)</dt><dd>@ATan2</dd>
<dt>$D2 (3.0)</dt><dd>@ATan</dd>
<dt>$D3 (3.0)</dt><dd>@Mod</dd>
<dt>$D4 (3.0)</dt><dd>@FV</dd>
<dt>$D5 (3.0)</dt><dd>@PV</dd>
<dt>$D6 (3.0)</dt><dd>@PMT</dd>
<dt>$D7 (3.0)</dt><dd>@Term</dd>
<dt>$D8 (3.0)</dt><dd>@Rate</dd>
<dt>$D9 (2.0)</dt><dd>@Round</dd>
<dt>$DA (2.0)</dt><dd>@Or</dd>
<dt>$DB (2.0)</dt><dd>@And</dd>
<dt>$DC</dt><dd>@Sum</dd>
<dt>$DD</dt><dd>@Avg</dd>
<dt>$DE</dt><dd>@Choose</dd>
<dt>$DF</dt><dd>@Count</dd>
<dt>$E0</dt><dd>@Error (followed by 3 bytes of zero)</dd>
<dt>$E1 (3.0)</dt><dd>@IRR</dd>
<dt>$E2</dt><dd>@If</dd>
<dt>$E3</dt><dd>@Int</dd>
<dt>$E4</dt><dd>@Lookup</dd>
<dt>$E5</dt><dd>@Max</dd>
<dt>$E6</dt><dd>@Min</dd>
<dt>$E7</dt><dd>@NA (followed by three bytes of zero)</dd>
<dt>$E8</dt><dd>@NPV</dd>
<dt>$E9</dt><dd>@Sqrt</dd>
<dt>$EA</dt><dd>@Abs</dd>
<dt>$EB</dt><dd>Not currently used</dd>
<dt>$EC</dt><dd>Not equal (<>)</dd>
<dt>$ED</dt><dd>greater than or equal to (>=)</dd>
<dt>$EE</dt><dd>less than or equal to (<=)</dd>
<dt>$EF</dt><dd>equals (=)</dd>
<dt>$F0</dt><dd>greater than (>)</dd>
<dt>$F1</dt><dd>less than (<)</dd>
<dt>$F2</dt><dd>comma (,)</dd>
<dt>$F3</dt><dd>exponentiation sign (^)</dd>
<dt>$F4</dt><dd>right parenthesis (")")</dd>
<dt>$F5</dt><dd>minus (-)</dd>
<dt>$F6</dt><dd>plus (+)</dd>
<dt>$F7</dt><dd>divide (/)</dd>
<dt>$F8</dt><dd>multiply (*)</dd>
<dt>$F9</dt><dd>left parenthesis ("(")</dd>
<dt>$FA</dt><dd>unary minus (-) i.e., -A3</dd>
<dt>$FB</dt><dd>(unary plus (+) i.e., +A3)</dd>
<dt>$FC</dt><dd>ellipses (...)</dd>
<dt>$FD</dt><dd>Next 8 bytes are SANE double number</dd>
<dt>$FE</dt><dd>Next 3 bytes are row, column reference</dd>
<dt>$FF (3.0)</dt><dd>Next n bytes are a Pascal string</dd></dl></dd>
</dl>

<p>Three of the codes require special information.  Code $FD indicates
that the next 8 bytes are a SANE numerics package double precision floating 
point number.  All constants within formulas are carried in this manner.</p>

<p>Code $FE indicates that the next three bytes point at a cell:</p>

<dl>
<dt>+000: Byte</dt><dd>$FE</dd>

<dt>+001: Byte</dt><dd>Column reference.  Add this byte to the column
number of the current cell to get the column number of the pointed at
cell.  This value is sometimes negative, but Add always works.</dd>

<dt>+002 to +003: Word</dt><dd>Row reference.  Add this word to the row
number of the current cell to get the row number of the pointed at cell.  
This value is sometimes negative, but Add always works.</dd>
</dl>

<p>Code $FF indicates that the next bytes are a String, where the byte 
immediately following the $FF contains the length.</p>

<h2>Propagated Label Cells</h2>

<p>Propagated label cells are labels that place one particular ASCII
character in each position of a window.  Handy for visual effects like
underlining.</p>

<dl>
<dt>+000: Flag Byte</dt><dd>Bit 7 is always zero.<br>
Bit 6 is meaningless.<br>
Bit 5 is always on.<br>
Bit 4 and bit 3 are protection, just like value cells.<br>
Bits 2, 1, and 0 are meaningless.  Put a 1 here.</dd>

<dt>+001: Byte</dt><dd>This is the actual character that is to be put in
each position in the cell.</dd>
</dl>

<h3>Regular Label Cells</h3>

<p>Regular label cells contain alphanumeric information, such as headings, 
names, and other descriptive information.</p>

<dl>
<dt>+000          Flag Byte     Bits 7, 6, and 5 are always zero.<br>
Bits 4 and 3 are same as value cells.<br>
Bits 2, 1, and 0 determine cell formatting:<ol>
<li>Use spreadsheet standard formatting</li>
<li>Left justify</li>
<li>Right justify</li>
<li>Center</li></ol></dd>

<dt>+001 to +nnn: Bytes</dt><dd>ASCII characters that actually display.  
The actual length was defined earlier in the word that contained the
actual number of bytes to read from disk.</dd>
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
arbitrated by Beagle Bros Software.  Beagle may be reached at:<br>
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
