---
layout:      'page'
title:       'ProDOS 8 Technical Note #1'
description: 'The GETLN Buffer and a ProDOS Clock Card'
permalink:   '/docs/technote/01/'
---


<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (November 1985)</h2>

<p>This Technical Note describes the effect of a clock card on the GETLN
buffer.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and 
<em>no</em> "written" by-line for this Technical Note.  This is how I found it 
online.  <em>-- AH</em></blockquote>

<hr>

<p>ProDOS automatically supports a ThunderClock(TM) or compatible clock
card when the system identifies it as being installed.  When programming
under ProDOS, always consider the impact of a clock card on the GETLN
input buffer ($200 - $2FF).  ProDOS can support other clocks which may
also use this space.</p>

<p>When ProDOS calls a clock card, the card deposits an ASCII string in
the GETLN input buffer in the form:  07,04,14,22,46,57.  This string
translates as the following:</p>

<blockquote>07 = The month, July (01=Jan,...,12=Dec)
<br>04 = The day of the week, Thurs.(00=Sun,...,06=Sat)
<br>14 = The date (00 to 31)
<br>22 = The hour, 10 p.m. (00 to 23)
<br>46 = The minute (00 to 59)
<br>57 = The second (00 to 59)</blockquote>

<p>ProDOS calls the clock card as part of many of its routines.  Anything
in the first 17 bytes of the GETLN input buffer is subject to loss if a
clock card is installed and is called.</p>

<p>In general, it has been the practice of programmers to use the GETLN input 
buffer for every conceivable purpose.  Therefore, an application should never 
store anything there.  If your application has a future need to know about the 
contents of the $200 - $2FF space, you should transfer it to some other 
location to guarantee that it will remain intact, particularly under ProDOS, 
where a clock card may regularly be overwriting the first 17 bytes.</p>

<p>The ProDOS 8 Technical Reference Manual contains more information on
the clock driver, including the necessary identification bytes, how the
ProDOS driver calls the card, and how you may replace this routine with
your own.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
</ul>

<hr>

{% include technote_credit.html %}



