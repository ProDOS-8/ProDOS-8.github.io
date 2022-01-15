---
layout:      'page'
title:       'SmartPort Technical Note #3'
description: 'SmartPort Bus Architecture'
permalink:   '/docs/technote/smartport/03/'
---

<h2>Revised by Matt Deatherage (November 1988)
<br />Written by Mike Askins (March 1985)</h2>

<p>This Technical Note formerly described the SmartPort Bus architecture, but this information is now documented in the Apple IIGS Firmware Reference.</p>

<hr />

<p>Do not be confused by the name "SmartPort Bus" architecture.  The information in the Apple IIGS Firmware Reference describes the mechanics of how devices interface with the disk port on a IIGS or IIc and with the UniDisk 3.5 Interface card on a ][+ or IIe.  It is not necessary to understand this information to use SmartPort firmware calls, nor do all devices which have SmartPort firmware necessarily have to connect mechanically through the disk port or UniDisk 3.5 Interface card.</p>

<p>The physical or electrical side of the hardware is called the "SmartPort Bus,"  while the firmware protocols are called the "SmartPort Interface."  Although the term "SmartPort" can refer to either or both parts, it is most often used to refer to the SmartPort Interface.  Only those developers who are designing products which will attach to either the IIGS or IIc disk port or to the UniDisk 3.5 Interface card need be concerned with the SmartPort Bus architecture.  Software developers need not learn about the SmartPort Bus architecture to use the SmartPort Interface firmware.</p>

{% include technote_credit.html %}
