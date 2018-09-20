---
layout:      page
title:       ProDOS 8 Technical Note #3 - Device Search, Identification, and Driver Conventions
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/03/
---




<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (November 1985)</h2>

<p>This Technical Note formerly described how ProDOS 8 searches for devices and 
how it deals with devices which are not Disk II drives.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and 
<em>no</em> "written" by-line for this Technical Note.  This is how I found it 
online.  <em>-- AH</em></blockquote>

<hr>

<p>This Note formerly described how ProDOS 8 searches for devices and how it 
deals with devices which are not Disk II drives; this information is now 
contained in section 6.3 of the ProDOS 8 Technical Reference Manual.</p>

<blockquote><em>Note:</em> The information on slot mapping on page 113 of
the manual and on page 2 of the former edition of this Technical Note is
incorrect.  ProDOS itself will mirror SmartPort devices from slot 5 into
slot 2 under certain conditions.  Devices should not be mirrored into
slots other than slot 2.  For more information, see <a href="/docs/technote/20/">ProDOS 8 Technical Note #20</a>, Mirrored Devices
and SmartPort.</blockquote>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
<li><a href="/docs/technote/20/">ProDOS 8 Technical Note #20: Mirrored 
Devices and SmartPort</a></li>
</ul>

<hr>



{% include technote_credit.html %}
