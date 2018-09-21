---
layout:      'page'
title:       'ProDOS 8 Technical Note #18'
description: '/RAM Memory Map'
permalink:   '/docs/technote/18/'
---



<h2>Revised by Matt Deatherage (November 1988)
<br>Written by Pete McDonald (December 1986)</h2>

<p>This Technical Note describes the block to actual memory location
mapping of /RAM.</p>

<hr>

<pre>

                Blocks     Address Range
            ______________________________
           |   $70-$7F   |   $E000-$EFFF  |
            ______________________________
           |   $68-$6F   |   $D000-$DFFF  |  (Bank 2)
            ______________________________
           |   $60-$67   |   $D000-$DFFF  |  (Bank 1)
            ______________________________
           |   $4E-$5C   |   $A200-$BFFF  |
            ______________________________
           |   $3D-$4C   |   $8200-$A1FF  |
            ______________________________
           |   $2C-$3B   |   $6200-$81FF  |
            ______________________________
           |   $1B-$2A   |   $4200-$61FF  |
            ______________________________
           |   $0A-$19   |   $2200-$41FF  |
            ______________________________

            ______________________________
           |   $5D-$5F   |   $1A00-$1FFF  |
            ______________________________
           |     $4D     |   $1800-$19FF  |
            ______________________________
           |     $3C     |   $1600-$17FF  |
            ______________________________
           |     $2B     |   $1400-$15FF  |
            ______________________________
           |     $1A     |   $1200-$13FF  |
            ______________________________
           |     $09     |   $1000-$11FF  |
            ______________________________
           |     $08     |   $2000-$21FF  |
            ______________________________
           |     $02     |   $0E00-$0FFF  |
            ______________________________
            
            ______________________________
           |     $03     |     Bitmap*    |
            ______________________________

</pre>

<p>Notes:</p>

<p>*: Synthesized.
<br>1: Blocks 0, 1, 4, 5, 6, and 7 do not exist.
<br>2: Block $7F contains the Reset, IRQ, and NMI vectors and is normally 
marked as used.
<br>3: The memory from $0C00 - $0DFF is a general purpose buffer used by 
the /RAM driver.</p>

<hr>



{% include technote_credit.html %}
