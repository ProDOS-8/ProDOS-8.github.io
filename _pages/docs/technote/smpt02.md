---
layout:      'page'
title:       'SmartPort Technical Note #2'
description: 'SmartPort Calls Updated'
permalink:   '/docs/technote/smartport/02/'
---

<h2>Revised by Llew Roberts (September 1989)
<br />Written by Mike Askins (May 1985)</h2>

<p>This Technical Note documents SmartPort call information which is notfound in the descriptions of SmartPort in the Apple IIGS FirmwareReference and the Apple IIc Technical Reference Manual, Second Edition.  The device-specific information which had been included in this Note isnow found in these manuals.</p>

<p>Changes since November 1988:  Added diagram and information on vendor ID numbers.</p>

<hr>


<h2>STATUS Calls</h2>

<p>A STATUS call with unit number = $00 and status code = $00 is a request to return the status of the SmartPort host, as opposed to unit numbers greater than zero which return the status of individual devices.  The number of devices as well as the current interrupt status is returned.  The format of the status list returned is illustrated in Figure 1.</p>

<pre>

           +------------------+
    Byte 0 |   Device Count   |
           +------------------+
    Byte 1 | Interrupt Status |
           +------------------+
    Byte 2 |      Vendor      |   $0000          Vendor unknown
           +                  +---$0001          Apple Computer, Inc.
    Byte 3 |        ID        |   $0002-$FFFF    Third-Party Vendor
           +------------------+
    Byte 4 |    Interface     |   _____|___________________|_____
           +                  +--|F|E|D|C|B|A|9|8|7|6|5|4|3|2|1|0|
    Byte 5 |     Version      |  |_______|_______________|_______|
           +------------------+  |       |               |
    Byte 6 |    Reserved      |  |Major  |    Minor      |$A=Alpha
           +------------------+  |Release|    Release    |$B=Beta
    Byte 7 |    Reserved      |                          |$E=Experimental
           +------------------+                          |$0=Final

              Figure 1 - Host General Status Return Information

</pre>

<h3>Stat_list</h3>

<dl>
<dt>byte 0</dt><dd>Number of devices</dd>
<dt>byte 1</dt><dd>Interrupt Status (If bit 6 is set, then no interrupt)</dd>
<dt>bytes 2-3</dt><dd>Driver manufacturer (were Reserved prior to May 1988):
<br>$0000: Undetermined
<br>$0001: Apple
<br>$0002-$FFFF: Third-party driver</dd>
<dt>bytes 4-5</dt><dd>Interface Version</dd>
<dt>bytes 6-7</dt><dd>Reserved (must be $0000)</dd>
</dl>

<p>The Number of devices byte tells the caller the total number of devices hooked to this slot or port.</p>

<p>The Interrupt Status byte is used by programs which try to determine if the SmartPort was the source of an interrupt.  If bit 6 of this byte is clear, there is a device (or devices) in the chain that require interrupt service.

You cannot use this value to determine which device in the chain is actually interrupting.  Your interrupt handler, having determined that a SmartPort interrupt has occurred, must poll each device on the chain to find out which device requires service.  The UniDisk 3.5 and Memory Expansion Card do not generate interrupts, so in these cases, this byte has bit 6 set.</p>

<p>The vendor ID number may be used to determine the manufacturer of a specific SmartPort peripheral interface card, a useful piece of information when dealing with device-specific calls.  Contact Apple Developer Technical Support if you require a specific vendor ID number.  The version word follows the 
SmartPort Interface Version definition described later in this Note.</p>


<h2>CONTROL Codes</h2>

<p>Before May 1988, control code $04 was defined as device-specific.  It is now defined as EJECT, and all SmartPort devices which support removable media must support this call.  If a device does not support removable media, it should simply return from this call without an error.</p>

<p>Note that the Apple II SCSI card firmware was revised in early 1988 to support this change.</p>


<h2>INIT</h2>

<p>An application should never make an INIT call (SmartPort code $05), since doing so is likely to destroy operating system integrity and may cause media damage as well.</p>

<p>If you are writing your own operating system (not encouraged) and need to reset all SmartPort devices, the INIT call with unit number = $00 will do just that.  Note that SmartPort devices cannot be selectively reset, and INIT must never be made at all with any unit number other than $00.</p>


<h2>SmartPort Interface Version Definition</h2>

<p>The SmartPort Interface Version definition uses the most significant nibble of the word as the major version number, the next two most significant nibbles as the minor version number, and the least significant nibble as a release indicator:</p>

<pre>

    $0 = Final    $A = Alpha    $B = Beta    $E = Experimental

</pre>

<p>Therefore, the interface version word for an experimental SmartPort interface 1.15 would be $115E while the interface version word for SmartPort interface 2.0 would be $2000.  GS/OS driver version numbers also follow this definition.</p>

{% include technote_credit.html %}
