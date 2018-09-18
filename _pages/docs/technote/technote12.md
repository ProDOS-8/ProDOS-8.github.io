---
layout:      page
title:       ProDOS 8 Technical Note #12 - Interrupt Handling
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/12/
---



<h2>Revised by Matt Deatherage (November 1988)
<br>Revised by Pete McDonald (November 1985)</h2>

<p>This Technical Note clarifies some aspects of ProDOS 8 interrupt 
handlers.</p>

<blockquote><em>Note:</em> Yes, there are <em>two</em> "revised" by-lines and 
<em>no</em> "written" by-line for this Technical Note.  This is how I found it 
online.  <em>-- AH</em></blockquote>

<hr>

<p>Although the ProDOS 8 Technical Reference Manual (section 6.2) documents 
interrupt handlers and includes a code example, there still remain a few 
unclear areas on this subject matter; this Note clarifies these areas.</p>

<p>All interrupt routines must begin with a CLD instruction.  Although not 
checked in initial releases of ProDOS 8, this first byte will be checked in 
future revisions to verify the validity of the interrupt handler.</p>

<p>Although your interrupt handler does not have to disable interrupts
(ProDOS 8 does that for you), it must never re-enable interrupts with a
6502 CLI instruction.  Another interrupt coming through during a
non-reentrant interrupt handler can bring the system down.</p>

<p>If your application includes an interrupt handler, you should do the
following before exiting:</p>

<ol>
<li>Turn off the interrupt source.  Remember, 255 unclaimed interrupts 
will cause system death.</li>

<li>Make a DEALLOC_INTERRUPT call before exiting from your application.  Do not 
leave a vector installed that points to a routine that is no longer there.</li>
</ol>

<p>Within your interrupt handler routines, you must leave all memory banks in 
the same configuration you found them.  Do not forget anything:  main language 
card, main alternate $D000 space, main motherboard ROM, and, on an Apple IIe, 
IIc, or IIGS, auxiliary language card, auxiliary alternate $D000 space, 
alternate zero page and stack, etc.  This is very important since the ProDOS 
interrupt receiver assumes that the environment is absolutely unaltered when 
your handler relinquishes control.  In addition, be sure to leave the language 
card write-enabled.</p>

<p>If your handler recognizes an interrupt and services it, you should clear 
the carry flag (CLC) immediately before returning (RTS).  If it was not your 
interrupt, you set set the carry (SEC) immediately before returning (RTS).  Do 
not use a return from interrupt (RTI) to exit; the ProDOS interrupt receiver 
still has some housekeeping to perform before it issues the RTI instruction.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
</ul>

<hr>


{% include technote_credit.html %}

