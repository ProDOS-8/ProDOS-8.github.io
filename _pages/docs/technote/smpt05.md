---
layout:      'page'
title:       'SmartPort Technical Note #5'
description: 'SCSI SmartPort Call Changes'
permalink:   '/docs/technote/smartport/05/'
---

<h2>Revised by Matt Deatherage and Llew Roberts (November 1990)
<br />Written by Rilla Reynolds and Matt Deatherage (May 1988)</h2>

<p>This Technical Note describes two CONTROL codes which have changed in 
revision C of the Apple II SCSI card firmware.</p>

<p><em>Changes since January 1989:</em>  Added notes about the Apple II 
High-Speed SCSI Card.</p>

<hr />

<p>Revision C of the Apple II SCSI card firmware includes two CONTROL code changes.</p>

<p>CONTROL code $04, previously defined as FORMAT, is now defined as
EJECT.  This change reflects the revised SmartPort requirement that all
devices maintain CONTROL code $04 as EJECT.  See <a
href="tn.smpt.2.html">SmartPort Technical Note #2</a>, SmartPort Calls
Updated, for more information.  CONTROL code $15 is now defined as FORMAT
instead of RESERVED.  Note that there are two EJECT calls in this version,
as CONTROL code $26 is still defined as EJECT.</p>

<p>To determine which version of the SCSI ROM is on any particular Apple
II SCSI Interface Card, issue a $03 SmartPort STATUS call.  The revision C
SCSI ROM returns the word $0200.  This does not follow the SmartPort
Interface Version scheme described in <a href="tn.smpt.2.html">SmartPort
Technical Note #2</a>.  However, future revisions of the Apple II SCSI
card will follow this scheme.  Therefore, applications should expect any
SmartPort SCSI firmware to behave as described in this Note if the version
number is $0200 or if it is greater than or equal to $2000.  The Apple II
High-Speed SCSI Card returns version $3000 (3.0).

<p>To maintain compatibility with the Apple II High-Speed SCSI Card and future
SCSI products, you should use the following guidelines when programming with
the revision C card:</p>

<ul>
<li>Avoid access to the hardware or any RAM locations on the SCSI card.</li>
<li>Do not use the Patch1Call, SetNewSDAT, or SetBlockSize control calls.</li>

<li>For devices with a block size other than 512 bytes, use the SmartPort Read 
and Write calls.  Do not use ReadBlock and WriteBlock calls for these devices, 
since they only read or write the first 512 bytes of a block.  The Read and 
Write calls may also be used for devices with a 512-byte block size.</li>

<li>Never Reset the SCSI bus.</li>
</ul>

<p>The Apple II SCSI Card firmware was designed to operate with SCSI CD-ROM and
disk drives only; however, the Apple II High-Speed SCSI Card works with most
SCSI devices, including removable drives, scanners, and tape backup units.</p>

{% include technote_credit.html %}
