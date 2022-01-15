---
layout:      'page'
title:       'File Type Note $08 (8) - Auxiliary Types $0000-$3FFF'
description: 'Apple II Graphics File'
permalink:   '/docs/technote/ftn/08/'
---


<h2>Full Name: Apple II Graphics File<br>Short Name: Graphics File</h2>

<h2>Revised by Matt Deatherage (1989)
<br>Written by Matt Deatherage (1988)</h2>

<p>Files of this type and auxiliary type contain standard Apple II
graphics files.</p>

<p><em>Changes since November 1988:</em> The offset was incorrectly listed
as +121 instead of +120.  The hexadecimal value of $78 is correct.</p>

<hr>

<p>Files of type $08 and any auxiliary type less than or equal to $3FFF
contain a standard Apple II graphics file in one of several modes.  After
determining that the auxiliary type is not $4000 or $4001 (which have been
defined for high-resolution and double high-resolution pictures packed
with the Apple IIGS PackBytes routine), you can determine the mode of the
file by examining byte +120 (+$78).  The value of this byte, which ranges
from zero to seven, is interpreted as follows:</p>

<pre>
               Mode                         Page 1    Page 2
               280 x 192 Black & White        0         4
               280 x 192 Limited Color        1         5
               560 x 192 Black & White        2         6
               140 x 192 Full Color           3         7

</pre>

<p>Note that some modes only apply to high-resolution while some only
apply to double high-resolution.</p>

<p>The format of the file is as follows:</p>

<dl>
<dt>Bytes +000 to +8191</dt><dd>High-resolution image or portion of double
high-resolution image stored in auxiliary memory.</dd>
<dt>Bytes +8192 to +16383</dt><dd>Portion of double high-resolution image
stored in main memory (not present for high-resolution).</dd>
</dl>

<p>File type $08 was originally defined as an Apple /// FotoFile, but now
it is useful for those applications that wish to save high-resolution or
double high-resolution data with a file type other than $06, which is a
standard binary file.  If you choose to use this type, you should remember
that older applications which do not check the auxiliary type may attempt
to interpret these files incorrectly.</p>

<hr>

{% include technote_credit.html %}
