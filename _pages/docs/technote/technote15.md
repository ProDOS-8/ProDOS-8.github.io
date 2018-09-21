---
layout:      'page'
title:       'ProDOS 8 Technical Note #15'
description: 'How ProDOS 8 Treats Slot 3'
permalink:   '/docs/technote/15/'
---



<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (November 1985)</h2>

<p>This Technical Note describes how ProDOS 8 reacts to non-Apple
80-column cards in slot 3 and how it identifies them.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and 
<em>no</em> "written" by-line for this Technical Note.  This is how I found it 
online.  <em>-- AH</em></blockquote>

<hr>

<p>The ProDOS 8 Update Manual now documents much of the information which
was originally covered in this Note about how ProDOS 8 reacts to non-Apple
80-column cards in slot 3.  However, since there is still some confusion
on the issue, we summarize it again in this Note.</p>

<p>On an Apple ][+, ProDOS 8 considers the following four Pascal 1.1
protocol ID bytes sufficient to identify a card in slot 3 as an 80-column
card and mark the corresponding bit in the MACHID byte:  $C305 = $38,
$C307 = $18, $C30B = $01, $C30C = $8x, where x represents the card's own
ID value and is not checked.  On any other Apple II, the following fifth
ID byte must also match:  $C3FA = $2C.  This fifth ID byte assures ProDOS
8 that the card supports interrupts on an Apple IIe.  Unless ProDOS 8
finds all five ID bytes in an Apple IIe or later, it will not identify the
card as an 80-column card and will enable the built-in 80-column firmware
instead.  In an Apple IIc or IIGS, the internal firmware always matches
these five bytes (see below).</p>

<p>If you are designing an 80-column card and wish to meet these requirements, 
you must follow certain other considerations as well as matching the five 
identification bytes; the ProDOS 8 Update Manual enumerates these other 
considerations.</p>

<p>The ProDOS 8 Update Manual notes that an Apple IIGS does not switch in
the 80-column firmware if it is not selected in the Control Panel.  
However, due to a bug in ProDOS 8 versions 1.6 and earlier, it switches in
the 80-column firmware unconditionally.  ProDOS 8 cannot respect the
Control Panel setting for 80-column firmware in certain situations; it
cannot operate in a 128K machine in a 128K configuration (including /RAM)
without the presence of the 80-column firmware, since it must utilize the
extra 64K.  This is just one of the reasons ProDOS 8 does not recognize a
card in slot 3 if it is not an 80-column card, as outlined above.</p>

<p>With ProDOS 8 version 1.7 and later, an Apple IIGS behaves exactly like
an Apple IIe with respect to slot 3.  If a card is slot 3 is selected in
the Control Panel, ProDOS 8 ignores it in favor of the built-in 80-column
firmware -- unless the card matches the five identification bytes listed
above.  This works the same on a Apple IIe.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
<li>ProDOS 8 Update Manual</li>
<li><a href="/docs/technote/11/">ProDOS 8 Technical Note #11</a>, The ProDOS 
8 MACHID Byte</li>
</ul>

<hr>



{% include technote_credit.html %}

