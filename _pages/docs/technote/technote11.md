---
layout:      'page'
title:       'ProDOS 8 Technical Note #11'
description: 'The ProDOS 8 MACHID Byte'
permalink:   '/docs/technote/11/'
---



<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (November 1985)</h2>

<p>This Technical Note describes the machine ID byte (MACHID) which ProDOS 
maintains to help identify different machine types.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and 
<em>no</em> "written" by-line for this Technical Note.  This is how I found it 
online.  <em>-- AH</em></blockquote>

<hr>

<p>ProDOS 8 maintains a machine ID byte, MACHID, at location $BF98 in the
ProDOS 8 global page.  Section 5.2.4 of the ProDOS 8 Technical Reference
Manual correctly documents the definition of this byte.</p>

<p>MACHID has become less robust through the years.  Although it can tell
you if you are running on an Apple ][, ][+, IIe, IIc, or Apple /// in
emulation mode, it cannot tell you which version of an Apple IIe or IIc
you are using, nor can it identify an Apple IIGS (it thinks a IIGS is an
Apple IIe).  However, the byte still provides a quick test for two
components of the system which you might wish to identify:  an 80-column
card and a clock card.</p>

<p>Bit 1 of MACHID identifies an 80-column card.  <a
href="/docs/technote/15/">ProDOS 8 Technical Note #15</a>, How ProDOS 8
Treats Slot 3 explains how this identification is determined.  Note that
on an Apple IIGS, this bit is always set, even if the user selects Your
Card in the Control Panel for slot 3.  The bit is set since ProDOS 8
versions 1.7 and later switch out a card in slot 3 in favor of the
built-in 80-column firmware, unless the card in slot 3 is an 80-column
card.  ProDOS 8 behaves in the same manner on an Apple IIe as well.</p>

<p>Bit 0 of MACHID identifies a clock card.  Note that on an Apple IIGS,
this bit is always set since the IIGS clock cannot be switched out of the
system.  Due to these unchangeable settings, the value of MACHID on the
Apple IIGS is always $B3, as it is on any Apple IIe with an 80-column card
and a clock card.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
<li>Apple IIGS Hardware Reference Manual</li>
<li><a href="/docs/technote/15/">ProDOS 8 Technical Note #15</a>, How ProDOS 
8 Treats Slot 3</li>
<li><a href="/docs/technote/misc07/">Miscellaneous Technical Note #7</a>, Apple II Family Identification</li>
</ul>

<hr>




{% include technote_credit.html %}

