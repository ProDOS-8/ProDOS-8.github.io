---
layout:      page
title:       ProDOS 8 Technical Note #16 - How to Format a ProDOS Disk Device
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/16/
---



<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (November 1985)</h2>

<p>This Technical Note supplements the ProDOS 8 Technical Reference Manual
in its description of the low-level driver call that formats the media in
a ProDOS device.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and
<em>no</em> "written" by-line for this Technical Note.  This is how I found it
online.  <em>-- AH</em></blockquote>

<hr>

<p>The ProDOS 8 Technical Reference Manual describes the low-level driver call 
that formats the media in a ProDOS device, but it neglects to mention the 
following:</p>

<ol>
<li>It does not work for Disk II drives or /RAM, both of which ProDOS 
treats specially with built-in driver code.</li>
<li>ProDOS has no easy way to tell you whether a device is a Disk II 
drive or /RAM.</li>
</ol>

<p>Once ProDOS finishes building its device table, which it does when it boots, 
it no longer cares about what kind of devices exist, so it does not keep any 
information about the different types of devices available.  ProDOS identifies 
Disk II devices and installs a built-in driver for them.  When it has 
installed all devices which are physically present, ProDOS then installs /RAM, 
in a manner similar to Disk II drives, by pointing to the driver code which is 
within ProDOS itself.  This method presents a problem for the developer who 
wishes to format ProDOS disks since the Disk II driver and the /RAM driver 
respond to the FORMAT request in non-standard ways, yet there is no 
identification in the global page that tells you which devices are Disk II 
drives or /RAM.</p>

<p>The Disk II driver does not support the FORMAT request, and the /RAM
driver responds by "formatting" the RAM disk and also writing to it a
virgin directory and bitmap; neither of these two cases is documented in
the ProDOS 8 Technical Reference Manual.  To write special-case code for
these two device types, you must be able to identify them, and the method
for identification is available in <a href="/docs/technote/21/">ProDOS 8
Technical Note #21</a>: Identifying ProDOS Devices.</p>

<p>You should note, however, that AppleTalk network volumes cannot be
formatted; they return a DEVICE NOT CONNECTED error for the FORMAT and any
low-level device call.  You may access AppleTalk network volumes through
ProDOS MLI calls only.</p>

<p>Also note that Apple licences a ProDOS 8 Formatter routine, which
correctly identifies and handles Disk II drives and /RAM.  You should
contact Apple Software Licensing at Apple Computer, Inc., 20525 Mariani
Avenue, M/S 38-I, Cupertino, CA, 95014 or (408) 974-4667 if you wish to
license this routine.</p>


<h2>Further Reference</h2

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
<li>ProDOS 8 Update Manual</li>
<li><a href="/docs/technote/21/">ProDOS 8 Technical Note #21</a>, Identifying 
ProDOS Devices</li>
</ul>

<hr>



{% include technote_credit.html %}

