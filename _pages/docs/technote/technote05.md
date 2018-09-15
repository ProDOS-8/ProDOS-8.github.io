---
layout:      page
title:       ProDOS 8 Technical Note #5 - ProDOS Block Device Formatting
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/01/
---



<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (October 1985)</h2>

<p>This Technical Note formerly described the ProDOS FORMATTER routine.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and 
<em>no</em> "written" by-line for this Technical Note.  This is how I found it 
online.  <em>-- AH</em></blockquote>

<hr>

<p>The ProDOS 8 Update Manual now contains the information about the ProDOS 
FORMATTER routine which this Note formerly described.  This routine is 
available from Apple Software Licensing at Apple Computer, Inc., 20525 Mariani 
Avenue, M/S 38-I, Cupertino, CA, 95014 or (408) 974-4667.</p>

<blockquote><em>Note:</em> This routine does not work properly with
network volumes on either entry point.  You cannot format a network volume
with ProDOS 8, nor can you make low-level device calls to it (as FORMATTER
does in ENTRY2 to determine the characteristics of a volume).  As a
general rule, it is better to use GET_FILE_INFO to determine the size of
the volume since ProDOS MLI calls work with network volumes.</blockquote>


<h2>Further Reference</h2>

<ul>
<li>ProDOS 8 Update Manual</li>
</ul>

<hr>



{% include technote_credit.html %}