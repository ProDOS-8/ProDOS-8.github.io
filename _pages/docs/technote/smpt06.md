---
layout:      'page'
title:       'SmartPort Technical Note #6'
description: 'Apple IIgs SmartPort Errata'
permalink:   '/docs/technote/smartport/06/'
---

<h2>Revised by Matt Deatherage (November 1990)
<br>Written by Matt Deatherage (November 1988)</h2>

<p>This Technical Note documents two bugs in the Apple IIgs SmartPort firmware.</p>

<p><em>Changes since November 1988:</em>  Documented corrections in ROM 03 and an additional ROM 03 bug.</p>

<hr>

<p>Developers should be aware of the following two bugs in the Apple IIgs ROM 01 SmartPort firmware:</p>

<ol>
<li>SmartPort accidentally uses locations $57 through $5A on the zero page without saving and restoring them first.  There is some confusion as to whether these bytes are used on the absolute zero page or on the caller's direct page.  This is a moot point -- SmartPort calls are required to be made from full-emulation mode. This requirement means the emulation bit must be set and the data bank and direct page registers must both be set to zero.  The bytes are used on the absolute zero page, as that should be the direct page when SmartPort is called.</li>

<li>If an extended SmartPort CONTROL call is made, the CONTROL list must not start at $FFFE or $FFFF of any bank.  The IIgs SmartPort interface does not increment the bank pointer when moving past the two-byte CONTROL list length.  If a CONTROL list starts one or two bytes before a bank boundary, SmartPort will incorrectly read the list from the beginning of that bank, instead of the beginning of the next bank.</li>
</ul>

<p>The ROM 03 firmware fixes these bugs; however, it has a bug in the ResetHook device-specific CONTROL call for the Apple 3.5" Drive.  With this bug, hook numbers of nine or greater crash the machine.  At present, hook numbers in this range are invalid, so this bug should not be a problem.</p>

{% include technote_credit.html %}
