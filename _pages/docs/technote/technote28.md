---
layout:      page
title:       ProDOS 8 Technical Note #28 - ProDOS Dates -- 2000 and Beyond
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/28/
---



<h2>Written by Dave Lyons (Septembet 1990)</h2>

<p>This Technical Note explains how ProDOS year values range from zero to 
ninety-nine and represent the years 1940 through 2039.</p>

<hr>

<p>The ProDOS date format uses sixteen bits: seven bits for the year, four for 
the month, and five for the day (see the ProDOS 8 Technical Reference Manual, 
page 71).  Dates are represented in this format in the parameter blocks for 
ProDOS 8 MLI calls and in the directories of ProDOS volumes.</p>

<p>In seven bits, 128 different years could be represented, but the proper 
interpretation of those bits has never been defined clearly until now.</p>


<h2>2000? I'll Be Dead By Then Anyway</h2>

<p>It's only nine years, folks, and then things get weird.  Is that ProDOS
year 100 or ProDOS year 0?  How do you compare two file-modification dates
so it keeps working correctly?</p>

<p>Before you dismiss questions like this, consider just how sure you are
that nobody will be using your software in nine years, or whether those
few dedicated weirdos are going to call you up on January 1, 2000 to
complain.  There will be plenty of computer-related problems in 2000, so
write your applications right today.</p>


<h2>Some Choices</h2>

<p>These two possible interpretations were considered and then rejected in
favor of The Definition below.</p>

<ol>
<li>Valid years would be from 0 to 99, meaning 1900 to 1999, so ProDOS 
dates would just "expire" at the end of 1999.  No fun.</li>

<li>Valid years would be from 0 to 127, meaning 1900 to 2027.  This is a
little better, except that almost no existing software is prepared to deal
with year values outside the 0-to-99 range.</li>
</ol>

<p>So, you are left with...</p>


<h2>The Definition</h2>

<p>The following definition allows the same range of years that the Apple
IIgs Control Panel CDA currently does:</p>

<ul>
<li>A seven-bit ProDOS year value is in the range 0 to 99 (100 through 127 
are invalid)</li>
<li>Year values from 40 to 99 represent 1940 through 1999</li>
<li>Year values from 0 to 39 represent 2000 through 2039</li>
</ul>

<blockquote><em>Note:</em> Apple II and Apple IIgs System Software does
not currently reflect this definition.</blockquote>


<h2>How to Compare Two Years</h2>

<p>To compare two dates, you need to adjust the years to allow for the
wrap-around effect between 39 and 40.  A simple approach is to add 100 to
any year less than 40 before doing the comparison, thus comparing two
values in the range 40 to 139.</p>

<pre>

    CompareAB    lda YearB
                 cmp #40
                 bcs B_OK
                 adc #100    ;carry is clear
                 sta YearB

B_OK             lda YearA
                 cmp #40
                 bcs A_OK
                 adc #100    ;carry is clear
                 sta YearA

A_OK             cmp YearB
                 bcc A_is_earlier
                 ...

</pre>


<h2>What About GS/OS Dates?</h2>

<p>This definition affects how the GS/OS ProDOS File System Translator works 
internally, but it does not affect GS/OS applications.  A year value under 
GS/OS is always a byte offset from 1900, giving a possible range of 1900 to 
2155, regardless of the file system involved.</p>


<h2>What Do You Do After 2039?</h2>

<p>Apple is still working on it.  Contact your neighborhood Apple
Developer Technical Support office in 2030.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
<li><a href="https://archive.org/details/AppleIIGSToolboxReferenceVolume1">Apple IIgs Toolbox Reference Manual, Volume 1</a></li>
<li><a href="http://www.brutaldeluxe.fr/documentation/apda/apple_appleiigs_gsosreference.pdf">GS/OS Reference</a></li>
</ul>

<hr>



{% include technote_credit.html %}
