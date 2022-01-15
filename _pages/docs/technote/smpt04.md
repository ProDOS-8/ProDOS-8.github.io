---
layout:      'page'
title:       'SmartPort Technical Note #4'
description: 'SmartPort Device Types'
permalink:   '/docs/technote/smartport/04/'
---

<h2>Revised by Matt Deatherage (November 1988)
<br />Written by Rilla Reynolds (June 1987)</h2>

<p>This Technical Note documents additional device types which the SmartPort  firmware recognizes, but which may not be currently documented in the  technical reference manuals which cover SmartPort.</p>

<hr />

<p>The following is an updated list of possible SmartPort device types, extended to support an increasing variety of third-party peripheral products.  A device type byte is returned as part of the Device Information Block (DIB) from a SmartPort STATUS call ($03).</p>

<ul>
<li><em>Type: Device</em></li>
<li><b>$00</b>: Memory Expansion Card (RAM disk)</li>
<li><b>$01</b>: 3.5" disk</li>
<li><b>$02</b>: ProFile-type hard disk</li>
<li><b>$03</b>: Generic SCSI</li>
<li><b>$04</b>: ROM disk</li>
<li><b>$05</b>: SCSI CD-ROM</li>
<li><b>$06</b>: SCSI tape or other SCSI sequential device</li>
<li><b>$07</b>: SCSI hard disk</li>
<li><b>$08</b>: Reserved</li>
<li><b>$09</b>: SCSI printer</li>
<li><b>$0A</b>: 5-1/4" disk</li>
<li><b>$0B</b>: Reserved</li>
<li><b>$0C</b>: Reserved</li>
<li><b>$0D</b>: Printer</li>
<li><b>$0E</b>: Clock</li>
<li><b>$0F</b>: Modem</li>
</ul>


{% include technote_credit.html %}
