---
layout:      page
title:       ProDOS 8 Technical Note #4 - I/O Redirection in DOS and ProDOS
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/04/
---



<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (November 1985)</h2>

<p>This Technical Note discusses I/O redirection differences between DOS 
3.3 and ProDOS.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and 
<em>no</em> "written" by-line for this Technical Note.  This is how I found it 
online.  <em>-- AH</em></blockquote>

<hr>

<p>Under DOS 3.3, all that is necessary to change the I/O hooks is
installing your I/O routine addresses in the character-out vector
($36-$37) and the key-in vector ($38-$39) and notifying DOS (JSR $3EA) to
take your addresses and swap in its intercept routine addresses.</p>

<p>Under ProDOS, there is no instruction installed at $3EA, so what do you
do?</p>

<p>You simply leave the ProDOS BASIC command interpreter's intercept addresses 
installed at $36-$39 and install your I/O addresses in the global page at 
$BE30-$BE33.  The locations $BE30-$BE31 should contain the output address 
(normally $FDF0, the Monitor COUT1 routine), while $BE32-$BE33 should contain 
the input address (normally $FD1B, the Monitor KEYIN routine).</p>

<p>By keeping these vectors in a global page, a special routine for moving the 
vectors is no longer needed, thus, no $3EA instruction.  You install the 
addresses at their destination yourself.</p>

<p>If you intend to switch between devices (i.e., the screen and the printer), 
you should save the hooks you find in $BE30-$BE33 and restore them when you 
are done.  Blindly replacing the values in the global page could easily leave 
you no way to restore input or output to the previous device when you are 
done.</p>

<hr>


{% include technote_credit.html %}
