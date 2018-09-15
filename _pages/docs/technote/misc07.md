---
layout:      page
title:       Apple II Miscellaneous Technical Note #7
description: Miscellaneous #7 - Apple II Family Identification
permalink:   /docs/technote/misc07/
---



<h2>Revised by Jim Luther (May 1991)
<br>Written by Cameron Birse and Matt Deatherage (December 1986)</h2>

<p>This Technical Note describes the ROM identification bytes in the Apple 
II family.</p>

<p><em>Changes since November 1988:</em>  Added the identification bytes 
needed to identify the Apple IIe Card for Macintosh LC.</p>

<hr>

<p>To identify which computer of the Apple II family is executing your program, 
you must check the following identification bytes.  These bytes are in the 
main bank of main ROM (shadowed on the Apple IIgs), and you should make sure 
that this bank is switched in before making decisions based on the contents 
of these locations.</p>

<pre>

Machine                    $FBB3    $FB1E    $FBC0    $FBDD    $FBBE    $FBBF
-----------------------------------------------------------------------------
Apple ][                    $38              [$60]                      [$2F]
Apple ][+                   $EA      $AD     [$EA]                      [$EA]
Apple /// (emulation)       $EA      $8A
Apple IIe                   $06               $EA                       [$C1]
Apple IIe (enhanced)        $06               $E0                       [$00]
Apple IIe Option Card       $06               $E0      $02      $00
Apple IIc                   $06               $00                        $FF
Apple IIc (3.5 ROM)         $06               $00                        $00
Apple IIc (Org. Mem. Exp.)  $06               $00                        $03
Apple IIc (Rev. Mem. Exp.)  $06               $00                        $04 
Apple IIc Plus              $06               $00                        $05
Apple IIgs                  (see below)

</pre>

<blockquote><em>Note:</em> Values listed in square brackets in the table
are provided for your reference only.  You do not need to check them to
conclusively identify an Apple II.</blockquote>

<p>The Apple IIe Card for Macintosh LC uses the same identification bytes
($FBB3 and $FBC0) as an enhanced Apple IIe.  Location $FBDD allows you to
tell the difference between the Apple IIe Card and an enhanced Apple IIe
because $FBDD will always contain the value $02 on the Apple IIe Card.  
Location $FBBE is the version byte for the Apple IIe Card (just as $FBBF
is the version byte for the Apple IIc family) and is $00 for the first
release of the Apple IIe Card.</p>


<p>The ID bytes for an Apple IIgs are not listed in the table since they
match those of an enhanced Apple IIe.  Future 16-bit Apple II products may
match different Apple II identification bytes for compatibility reasons,
so to identify a machine as a IIgs or other 16-bit Apple II, you must make
the following ROM call:</p>

<pre>

    SEC        ;Set carry bit (flag)
    JSR $FE1F    ;Call to the monitor
    BCS OLDMACHINE    ;If carry is still set, then old machine
    BCC NEWMACHINE    ;If carry is clear, then new machine

</pre>

<p>In all the current, standard Apple II ROMs, $FE1F contains an RTS.  In the 
Apple IIgs, there is a routine that returns compatibility information in the 
A, X, and Y registers:</p>

<pre>

Bit      Accumulator                       X Register  Y Register
------------------------------------------------------------------------
Bit 15   Reserved                          Reserved    Machine ID Number 
                                                       (0 = Apple IIgs)
Bit 14   Reserved                          Reserved    Machine ID Number
Bit 13   Reserved                          Reserved    Machine ID Number
Bit 12   Reserved                          Reserved    Machine ID Number 
Bit 11   Reserved                          Reserved    Machine ID Number
Bit 10   Reserved                          Reserved    Machine ID Number
Bit 9    Reserved                          Reserved    Machine ID Number
Bit 8    Reserved                          Reserved    Machine ID Number
Bit 7    Reserved                          Reserved    ROM version number
Bit 6    1 if system has memory expansion slot
                                           Reserved    ROM version number
Bit 5    1 if system has IWM port          Reserved    ROM version number
Bit 4    1 if system has a built-in clock  Reserved    ROM version number
Bit 3    1 if system has desktop bus       Reserved    ROM version number
Bit 2    1 if system has SCC built-in      Reserved    ROM version number
Bit 1    1 if system has external slots    Reserved    ROM version number
Bit 0    1 if system has internal ports    Reserved    ROM version number

</pre>

<blockquote><em>Note:</em> In emulation or eight-bit mode, only the lower
eight bits are returned.</blockquote>

<p>This ROM call is enough to determine if a machine is an Apple IIgs or 
equivalent.</p>

<blockquote><em>Note:</em> The original Apple IIgs ROM returns a faulty value 
in the accumulator.  The value returned is $xx1F and should be $xx7F.  If you 
see a $0000 in the Y register (i.e., Apple IIgs, ROM version $00), you should 
assume that the accumulator value is $xx7F.</blockquote>

<p>The current Apple IIgs ROM (ROM version $01) sets all the registers
correctly before returning from this call.</p>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/technote/misc02/">Apple II Miscellaneous Technical Note #2</a>, Apple II Family Identification Routines 2.2</li>
</ul>

<hr>

{% include technote_credit.html %}
