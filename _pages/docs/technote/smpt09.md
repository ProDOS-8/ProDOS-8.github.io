---
layout:      'page'
title:       'SmartPort Technical Note #9'
description: 'Apple II SCSI Errata'
permalink:   '/docs/technote/smartport/09/'
---

<h2>Written by Llew Roberts (July 1990)</h2>

<p>This Technical Note documents SCSI-specific anomalies that were
discovered in the development of the Apple II High-Speed SCSI card.</p>

<hr />

<p>During the testing of the Apple II High Speed SCSI Card, several SCSI-related issues of interest to developers were discovered.  Most of these issues directly relate to SCSI devices with removable media.</p>

<p>If a CD-ROM has a bad directory, the firmware hangs because it gets a "Read In Progress" error.  There is no timeout.  The system can be recovered if the CD-ROM is manually ejected.</p>

<p>If the media is ejected while a SmartPort DIB Status call is in progress, the call returns with incorrect results (it reports DISKSW and that the block count of the device is zero).  In order to avoid this conflict, bracket the DIB Status call with the SmartPort SCSI specific Control Calls Prevent Removal ($1A) and Allow Removal ($1B).</p>

<p>A SmartPort FORMAT call, in some cases, does not update the DIB correctly to  reflect the new or changed partition map.  If a SmartPort Init call is always  made immediately after the FORMAT, the DIB is rebuilt correctly.  Note that  after formatting a tape, the tape should be removed from the SCSI tape drive  before an Init call is made.  An Init call causes the tape to rewind, hanging  the system with no time-out until the rewind is complete.</p>

{% include technote_credit.html %}
