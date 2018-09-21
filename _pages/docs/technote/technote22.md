---
layout:      'page'
title:       'ProDOS 8 Technical Note #22'
description: 'Do not Put Parameter Blocks on Zero Pages'
permalink:   '/docs/technote/22/'
---



<h2>Written by Dave Lyons (July 1989)</h2>

<p>Putting ProDOS 8 parameter blocks on zero page ($00-$FF) is not 
recommended.</p>

<hr>

<p>It is not a good idea to put the parameter blocks for ProDOS 8 MLI calls on 
zero page.  This is not forbidden by the ProDOS 8 Technical Reference Manual, 
but then again, it also doesn't tell you not to put parameter blocks in ROM, 
in the $C0xx soft switch area, or just below the active part of the stack.</p>

<p>If you do put MLI parameter blocks on zero page, your application may break 
in the future.</p>

<p>If your parameter block comes between $80 and $FF, it won't work with 
AppleShare installed.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
</ul>

<hr>




{% include technote_credit.html %}
