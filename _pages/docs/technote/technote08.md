---
layout:      page
title:       ProDOS 8 Technical Note #8 - Dealing with /RAM
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/08/
---

<h2>Revised by Matt Deatherage (November 1988)
<br>Written by Kerry Laidlaw (October 1984)</h2>

<p>This Technical Note formerly described conventions for dealing with the 
built-in ProDOS 8 RAM disk, /RAM.</p>

<hr>

<p>Section 5.2.2 of the ProDOS 8 Technical Reference Manual now documents the 
conventions on how to handle /RAM, including how to disconnect it, how to 
reconnect it, and precautions you should follow if doing either, which were 
covered in this Note.  The manual also includes sample source code.</p>

<p>Executing the sample code which comes with the manual to disconnect /RAM has 
the undesired effect of decreasing the maximum number of volumes on-line when 
used with versions of ProDOS 8 prior to 1.2.  This side effect is because 
earlier versions of ProDOS 8 do not have the capability to remove the volume 
control block (VCB) entry which is allocated for /RAM when it is installed.</p>

<p>In later versions of ProDOS 8 (1.2 and later), this problem no longer
exists, and you should issue an ON_LINE call to a device after
disconnecting it.  This call returns error $28 (no device connected), but
it also erases the VCB entry for the disconnected device.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
<li>ProDOS 8 Update Manual</li>
</ul>

<hr>

{% include technote_credit.html %}
