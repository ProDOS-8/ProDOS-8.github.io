---
layout:      'page'
title:       'SmartPort Technical Note #8'
description: 'SmartPort Packets'
permalink:   '/docs/technote/smartport/08/'
---

<h2>Written by Llew Roberts (May 1989)</h2>

<p>This Technical Note describes the structure and timing of a sample SmartPort packet.</p>

<hr />

<p>SmartPort devices communicate using SmartPort packets.  The following packet shows the timing and content of a SmartPort READBLOCK call.  For further explanation of the structure, please see the Apple IIGS Hardware Reference and the Apple IIGS Firmware Reference.</p>

<blockquote><em>Note:</em> The CPU will recognize and act on any packet put on the bus by a SmartPort Device.</blockquote>

<pre>

DATA            MNEMONIC  DESCRIPTION                           TIME
(SmartPort Bus)           (Relative)
_____________________________________________________________________________
FF              SYNC      SELF SYNCHRONIZING BYTES              0
3F              :         :                                     32 micro Sec.
CF              :         :                                     32 micro Sec.
F3              :         :                                     32 micro Sec.
FC              :         :                                     32 micro Sec.
FF              :         :                                     32 micro Sec.
C3              PBEGIN    MARKS BEGINNING OF PACKET             32 micro Sec.
81              DEST      DESTINATION UNIT NUMBER               32 micro Sec.
80              SRC       SOURCE UNIT NUMBER                    32 micro Sec.
80              TYPE      PACKET TYPE FIELD                     32 micro Sec.
80              AUX       PACKET AUXILLIARY TYPE FIELD          32 micro Sec.
80              STAT      DATA STATUS FIELD                     32 micro Sec.
82              ODDCNT    ODD BYTES COUNT                       32 micro Sec.
81              GRP7CNT   GROUP OF 7 BYTES COUNT                32 micro Sec.
80              ODDMSB    ODD BYTES MSB's                       32 micro Sec.
81              COMMAND   1ST ODD BYTE = Command Byte           32 micro Sec.
83              PARMCNT   2ND ODD BYTE = Parameter Count        32 micro Sec.
80              GRP7MSB   MSB's FOR 1ST GROUP OF 7              32 micro Sec.
80              G7BYTE1   BYTE 1 FOR 1ST GROUP OF 7             32 micro Sec.
98              G7BYTE2   BYTE 2 FOR 1ST GROUP OF 7             32 micro Sec.
82              G7BYTE3   BYTE 3 FOR 1ST GROUP OF 7             32 micro Sec.
80              G7BYTE4   BYTE 4 FOR 1ST GROUP OF 7             32 micro Sec.
80              G7BYTE5   BYTE 5 FOR 1ST GROUP OF 7             32 micro Sec.
80              G7BYTE5   BYTE 6 FOR 1ST GROUP OF 7             32 micro Sec.
80              G7BYTE6   BYTE 7 FOR 1ST GROUP OF 7             32 micro Sec.
BB              CHKSUM1   1ST BYTE OF CHECKSUM                  32 micro Sec.
EE              CHKSUM2   2ND BYTE OF CHECKSUM                  32 micro Sec.
C8              PEND      PACKET END BYTE                       32 micro Sec.
00              FALSE     FALSE IWM WRITE TO CLEAR REGISTER     32 micro Sec.
_____________________________________________________________________________

</pre>

{% include technote_credit.html %}
