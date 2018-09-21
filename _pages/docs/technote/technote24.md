---
layout:      'page'
title:       'ProDOS 8 Technical Note #24'
description: 'BASIC.SYSTEM Revisions'
permalink:   '/docs/technote/24/'
---



<h2>Revised by Matt Deatherage (May 1992)
<br>Written by Matt Deatherage (July 1989)</h2>

<p>This Technical Note documents the change history of BASIC.SYSTEM
through V1.5, which ships with Apple IIgs System Software 6.0.  V1.0, the
initial release, is not documented in this Note, and V1.1 is described in
BASIC Programming with ProDOS.</p>

<p><em>Changes since September 1990:</em> Revised to include BASIC.SYSTEM
1.5.</p>

<hr>

<h3>V1.1</h3>

<ul>
<li>Fixed a bug in variable packing (used by CHAIN, STORE, and RESTORE).</li>

<li>Changed the interpreter to use the ProDOS startup convention of a JMP
instruction followed by two $EE bytes and a startup pathname buffer.</li>

<li>Removed a bad buffer address in the FIELD parameter of the READ
routine.</li>

<li>Fixed a bug in APPEND so calls to OPEN and READ from a random-access
file would not cause the next call to APPEND to any file to use the record
length of the random-access file.</li>

<li>Added the BYE command to allow ProDOS QUIT calls from BASIC.</li>

<li>Removed the limited support for run-time capabilities which had been
present.</li>
</ul>

<h3>V1.2</h3>

<ul>
<li>Changed the CATALOG command to ignore the number of entries in a
directory when listing it so AppleShare volumes could be cataloged
properly (this number can change on the fly on an AppleShare volume).</li>

<li>Fixed another bug in CATALOG so pressing an unexpected key when a
catalog listing was paused with a Control-S would no longer abort the
catalog.</li>
</ul>

<h3>V1.3</h3>

<ul>
<li>Changed BSAVE so it now truncates the length of the saved file when
the B parameter is not used.  To replace the first part of a file without
truncation, use the B parameter with a value of zero.  This behavior with
the B parameter is how V1.1 and V1.2 worked without the B parameter.</li>

<li>Fixed a bug in CHAIN and STORE where they expected one branch to go
two ways at the same time.</li>

<li>Added the MTR command for easier access to the Monitor from BASIC.</li>

<li>Made internal changes to the assembly process for easier project
management.  These changes do not affect the code image.</li>
</ul>

<h3>V1.4</h3>

<ul>
<li>Fixed a bug which caused a BLOAD into an address marked as used in the
global page to start performing a BSAVE on the file instead of returning
the NO BUFFERS AVAILABLE message.  For this reason, BASIC.SYSTEM version
1.3 should not be used.</li>
</ul>

<h3>V1.4.1</h3>

<ul>
<li>Fixed a bug in the mark handling routines.  When using the "B"
parameter to indicate a byte to use as a file mark, the third and most
significant byte would never be reset before the next use of B.  For
example, if you used a B value of $010000 and then used a B value of
$2345, BASIC.SYSTEM 1.4 would use $012345 for the second B parameter
value.</li>
</ul>

<h3>V1.5</h3>

<ul>
<li>Fixed centuries-old bug where NOTRACE after a THEN (as in IF/THEN)
disconnected BASIC.SYSTEM.  Now it doesn't.</li>

<li>BSAVE now modifies the auxtype of an existing file only if the file
type is $06 (BIN).</li>

<li>BASIC.SYSTEM can now launch (with "-") GS/OS applications.  Files of
type $B3 are passed through to an extended QUIT call to the ProDOS 8 MLI.</li>

<li>$B3 files are now listed as S16 in the catalog.</li>

<li>Fixed a bug in the READ command where reading from the slot 3 /RAM
disk passed errors back to BASIC, making the program break without
completing a legal operation.</li>

<li>Code optimized and crunched slightly.</li>
</ul>


<h2>Further Reference</h2>

<ul>
<li>BASIC Programming with ProDOS</li>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
</ul>

<hr>



{% include technote_credit.html %}

