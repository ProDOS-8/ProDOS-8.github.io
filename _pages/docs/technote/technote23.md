---
layout:      page
title:       ProDOS 8 Technical Note #23 - ProDOS 8 Changes and Minutia
description: ProDOS 8 Technical Notes
permalink:   /docs/technote/23/
---



<h2>Revised by Matt Deatherage (May 1992)
<br>Written by Matt Deatherage (July 1989)</h2>

<p>This Technical Note documents the change history of ProDOS 8 through V2.0.1,
and it supersedes the information on this topic in the ProDOS 8 Technical
Reference Manual and the ProDOS 8 Update.</p>

<p><em>Changes since September 1990:</em> Updated to include ProDOS 8
version 2.0.1 and its known bugs.  Replaced APDA references with Resource
Central.</p>

<hr>


<h2>Changes?  You're Kidding.</h2>

<p>No.  One of the side effects of evolving technology is that eventually
little things (like the disk operating system) have to change to support
the new technologies.  Every time Apple changes ProDOS 8, the manuals
can't be reprinted.  For one thing, it takes a long time to turn out a
manual, by which time there's often a new version done which the new
manual doesn't cover.  For another thing, programmers and developers don't
tend to purchase revised manuals (our informal research shows that more
people have up-to-date Apple /// RPS documentation than have up-to-date
Apple IIc documentation -- and this was done before the Apple IIc Plus was
released...).</p>

<p>So this Note explains what has changed between ProDOS 8 V1.0 and the current
release, V2.0.1, which began shipping with Apple IIgs System Software 6.0.
Table 1 shows what versions of ProDOS 8 existing documentation covers.</p>

<pre>

                                                         Version
      Document                                           Number
     ------------------------------------------------------------
      ProDOS 8 Technical Reference Manual                1.1.1
      ProDOS 8 Update                                    1.4
      AppleShare Programmer's Guide to the Apple IIgs    1.5
     ------------------------------------------------------------
                   Table 1 - ProDOS 8 Documentation

</pre>

<h3>ProDOS 1.0</h3>

<p>This was the first release of ProDOS, which was so unique it didn't
even have to be called ProDOS 8 to distinguish it from ProDOS 16.</p>

<h3>ProDOS 1.0.1</h3>

<ul>
<li>Fixed a bug in the STATUS call which affected testing for the
write-protected condition.</li>
</ul>

<h3>ProDOS 1.0.2</h3>

<ul>
<li>Changed instructions used in interrupt entry routines on the global
page so the accumulator would not be destroyed.</li>

<li>Fixed a bug in the Disk II core routines so the motor would shut off
after recalibration on an error.</li>
</ul>

<h3>ProDOS 1.1</h3>

<ul>
<li>Changed the internal MLI layout for future expansibility and
maintenance.</li>

<li>Modified machine ID routines to identify IIc and enhanced IIe ROMs.</li>

<li>Removed code that allowed ProDOS to boot on 48K machines.</li>

<li>Removed the check for the ProDOS version number from the OPEN routine.</li>

<li>Incremented KVERSION (the ProDOS Kernel version) on the global page.</li>

<li>Modified the loader routines to reflect the presence of any 80-column card 
following the established protocol (see <a href="/docs/technote/15/">ProDOS 8 
Technical Note #15</a>, How ProDOS 8 Treats Slot 3).  Also, at this time, 
added code to allow slot 3 to be enabled on a IIe if an 80-column card 
following the protocol was found.</li>

<li>Added code to turn off all disk motor phases prior to seeking a track
in the Disk II driver.</li>

<li>Fixed a bug to prevent accesses to /RAM after it had been removed from
the device list.</li>

<li>Reduced the size of the /RAM device by one block to protect interrupt 
vectors in the auxiliary language card.  The correct vectors are installed 
at boot time.</li>
</ul>

<h3>ProDOS 1.1.1</h3>

<ul>
<li>Fixed a Disk II driver bug for mapping into drive 1.</li>

<li>Modified machine ID routines to give precedence to identifiable
80-column cards in slot 3.</li>
</ul>

<h3>ProDOS 8 1.2</h3>

<ul>
<li>Changed the name from ProDOS to ProDOS 8 to avoid confusion with
ProDOS 16, which, again, this Note does not discuss.</li>

<li>Introduced the clock driver for the Apple IIgs.  The machine identification 
code was changed to indicate the presence of the clock on the IIgs.</li>

<li>Added preliminary network support by adding the network call and
preliminary network driver space.</li>

<li>Fixed a bug in returning errors from calls to the RAM disk.  Changed
the RAM disk driver to return values of zero on reads and ignore writes to
blocks zero, one, four, five, six, and seven, which are not accessible as
storage in the driver's design.</li>

<li>Added a new system error ($C) for errors when deallocating blocks from
a tree file.</li>

<li>Fixed a bug in zeroing a Volume Control Block (VCB) when trying to
reallocate a previously used VCB.</li>

<li>Modified the ProDOS 8 loader code to automatically install up to four
drives in slot 5 if a SmartPort device is found.  Removed the code to
always leave interrupts disabled, which leaves the state of the interrupt
flag at boot time unchanged while ProDOS 8 loads.</li>

<li>Changed the MLI entry to disable interrupts until after the MLIACTV
flag is set and other ProDOS parameters are initialized.</li>

<li>Modified the QUIT code to allow the Delete key to function the same as
the left arrow key.  Also fixed a bug so screen holes would not be trashed
in 80-column mode.  Crunched code to allow soft switch accesses to force
40-column text mode.  Fixed a bug so the dispatcher would not trash the
screen when executed with a NIL prefix.</li>

<li>Modified the ONLINE call so that it could be made to a device that had
just been removed from the device list by the standard protocol. Previous
to this change, a VCB for the removed device was left, reducing the number
of on-line volumes by one for each such device. From this point on,
removing a device should be followed by an ONLINE call to the device just
removed.  The call returns error $28 (No Device Connected), but
deallocates the VCB.</li>

<li>Added a spurious interrupt handler to allow up to 255 unclaimed
interrupts before system death.</li>

<li>Removed the code which invoked low-resolution graphics on system death
-- it had not worked well and the space was needed.  The system had
previously had the ability to display "INSERT SYSTEM DISK AND RESTART"
without also displaying "-ERR xx", which was removed at this point for
space reasons since the system wasn't using it (and hopefully you weren't,
either, since it wasn't documented).</li>

<li>Changed MLIACTV to use an ASL instead of an LSR to turn "off" the flag.</li>

<li>Changed the OPEN call to correctly return error $4B (Unsupported Storage
Type) instead of error $4A (incompatible file format for this version) when
attempting to open a file with an unrecognized storage type.</li>

<li>Fixed an obscure bug involving READ in Newline mode.  If the requested
number of bytes was greater than $FF, and the number of bytes in the file
after the newline character was read was a multiple of $100, then the
number of bytes reported transferred by ProDOS was equal to the correct
number of transferred bytes plus $100.</li>

<li>Starting with V1.2 on an Apple IIgs, stopped switching slot 3 ROM space
and left the determination of whether the slot or the port was enabled to the
Control Panel; however, there was a bug in this implementation which was fixed
in V1.7 and described in <a href="/docs/technote/15/">ProDOS 8 Technical Note
#15</a>, How ProDOS 8 Treats Slot 3.</li>

<li>Updated the slot-based clock driver's year table through 1991.</li>

<li>Added a feature which allows ProDOS 8 to search for a file named
ATINIT in the boot volume's root directory, to load and execute it, then
to proceed normally with the boot process by loading the first .SYSTEM
file.  No error occurs if the ATINIT file is not found, but any other
error condition (including the file existing and not having file type $E2)
causes a fatal error.</li>

<li>Changed loader code so ProDOS 8 could be loaded by ProDOS 16 without
automatically executing the ATINIT and the first .SYSTEM file.</li>

<li>Changed the device search process in the ProDOS 8 loader so SmartPort
devices are only installed if they actually exist, and Disk IIs are placed
with lowest priority in the device list so they are scanned last.</li>

<li>Forced Super Hi-Res off on an Apple IIgs when a fatal error occurs.
(Actually, this did not work, but it was fixed in V1.7.)</li>

<li>Inserted a patch to fix a bug in the first IIgs ROM that caused internal 
$Cn00 ROM space to be left mapped in if SmartPort failed to boot.</li>
</ul>

<h3>ProDOS 8 1.3</h3>

<blockquote><em>Warning:</em> This is not a stable version of ProDOS due
to an illegal 65C02 instruction which was added.  This version can damage
disks if used with a 6502 processor.</blockquote>

<ul>
<li>Changed the code that resets phase lines for Disk IIs so phase clearing is
done with a load instead of a store, since stores to even numbered locations
cause bus contention, which is major uncool.  Changed the routine to force
access to all eight even locations, which not only clears the phases, but also
forces read mode, first drive, and motor off.  DOS used to do this; ProDOS had
not been doing it.  If L7 had been left on when the Disk II driver was called
and it checked write-protect with L6 high, write mode was enabled.  Forcing
read mode leaves less to chance.</li>

<li>Changed deallocation of index blocks so index blocks are not zeroed,
allowing the use of file recovery utilities.  Instead, index blocks are
"flipped" (the first 256 bytes are exchanged with the last 256 bytes).</li>

<li>Since the UniDisk 3.5 interface card for the ][+ and IIe does not set
up its device chain unless a ProDOS call is made to it, ProDOS STATUS
calls are now made to the device before SmartPort STATUS calls.</li>
</ul>

<h3>ProDOS 8 1.4</h3>

<ul>
<li>Removed an illegal 65C02 instruction which was added in V1.3.</li>

<li>Modified the Disk II driver so a routine that should only clear the
phase lines only clears the phase lines.  Also clear Q7 to prevent
inadvertent writes.</li>
</ul>

<blockquote><em>Warning:</em> The AppleTalk command, which was added in
version 1.5, is present as a skeleton in this version.  Unfortunately,
it's not a useful skeleton.  It moves a section of memory from a ProDOS
location to another location and transfers control, totally oblivious of
the fact that there is no code at this address.</blockquote>

<blockquote>Even more unfortunate, the server software that ships with the
Apple IIe Workstation Card is such that when the IIe is booted over the network
with that server software, it is version 1.4 (KVERSION = 4).</blockquote>

<blockquote>So if you boot version 1.4 from a local disk, making a $42
call is fatal.  See <a href="/docs/technote/21/">ProDOS 8 Technical Note
#21</a>, Identifying ProDOS Devices, for a reliable way to identify
AppleTalk volumes under ProDOS 8 version 1.4.</blockquote>

<h3>ProDOS 8 1.5</h3>

<ul>
<li>ProDOS 8 1.5 is the first version to include network support through
the ProDOS Filing Interface (PFI) as part of ProDOS 16 or on the Apple IIe
Workstation Card without booting over the server (see the warning under
version 1.4).  Made many changes to internal routines for PFI location and
compatibility at this point.  Crunched and moved code for PFI booting and
accessibility.</li>

<li>Changed some strings to all uppercase internally for string
comparisons.</li>

<li>Removed the generic $42 AppleTalk call (the cause of the previous
warning) which was introduced in V1.2, as PFI gets called through the
global page.</li>

<li>Changed the ASL to clear the MLIACTV flag back to an LSR.  This
doesn't make nested levels of busy states possible, but always clears the
flag before calling interrupt handling routines that check MLIACTV as
described in the ProDOS 8 Technical Reference Manual.</li>

<li>If an Escape key is detected in the keyboard buffer on an Apple IIc,
it is removed.  This is friendly to the Apple IIc Plus, the ROM of which
does not remove the Escape key it uses to detect that the system should be
booted at normal speed.</li>
</ul>

<h3>ProDOS 8 1.6</h3>

<ul>
<li>Set up a parallel pointer to correct a PFI misinterpretation of an 
internal MLI pointer.</li>
</ul>

<h3>ProDOS 8 1.7</h3>

<ul>
<li>Made a change to ensure that ProDOS 8 counts the volume's bitmap
before incrementing the number of free blocks.  This fixed a bug where an
uninitialized location was being incremented and decremented, incorrectly
reporting a Disk Full error where none should have occurred.</li>

<li>Changed the handling of slot 3 ROM space to that described in <a href="/docs/technote/15/">ProDOS 8 Technical Note #15</a>, How ProDOS 8
Treats Slot 3.</li>

<li>Changed code to permit the invisible bit of the access byte (bit 2) to
be set by applications.</li>
</ul>

<h3>ProDOS 8 1.8</h3>

<ul>

<li>Fixed a bug introduced in V1.3.  If an error occurs while calling
DESTROY on a file, the file is not deleted but the index blocks are not
swapped back to normal position.  If a subsequent DESTROY of the same file
succeeds, the volume's integrity is destroyed.  Now ProDOS 8 marks the
file as deleted, even if an error occurs, so any other errors do not cause
a subsequent MLI call to trash the volume.  Note that "undelete" utilities
attempting to undelete such a file (one in which an error occurred during
the DESTROY) may trash the volume.</li>

<li>Fixed the ONLINE call to ignore the unused low nibble of the unit_num
parameter when deciding how many bytes to zero in the application's
buffer.  This change fixes a bug which zeroed only the first 16 bytes
of the caller's buffer before filling them if an ONLINE call was made
with a unit_num of $0X, where X is non-zero.</li>

<li>When loading on an Apple IIgs, ProDOS 8 now sets the video mode so the
80-column firmware is not active when the ProDOS 8 application gets
control.</li>

<li>Changed internal version checking between GS/OS and ProDOS 8.  Note
that GS/OS and ProDOS 8 are still tied to each other -- versions that
didn't come on the same disk can't be used together.  The methods for
checking versions were just altered.</li>

<li>Made the backward compatibility check when opening subdirectories
inactive.  The test would always fail when opening a subdirectory with
lowercase characters in the name (as assigned by the ProDOS FST under
GS/OS), so the check was removed.  Note that using earlier versions of
ProDOS 8 with such disks causes errors when trying to access files with
such directories in their pathnames.</li>

<li>Expanded the ProDOS 8 loader code to provide for more room for future
compatibility.</li>

<li>On a IIgs, installs a patch into the GS/OS stack-based call vector so that
anyone calling GS/OS routines (like QDStartUp in ROM 03, for example) gets an
appropriate error instead of performing a JSL into the stratosphere.</li>
</ul>

<h3>ProDOS 8 1.9</h3>

<ul>
<li>New selector and dispatcher code was added for machines with 80
columns.  The old code is still present for machines without 80-column
capability.</li>

<li>Fixed two bugs involved in booting into a ".SYSTEM" program larger
than 38K.  First, ProDOS 8 should be able to boot into a program as large
as 39.75K, but was returning an error if the ".SYSTEM" program was larger
than 38K.  Second, when attempting to print the message "*** SYSTEM
PROGRAM TOO LARGE ***", only one asterisk was printed. Both these bugs are
fixed.</li>

<li>No longer requires a ".SYSTEM" file when booting.  If ProDOS 8 does
not find a ".SYSTEM" file and the enhanced selector and dispatcher code is
installed, ProDOS 8 executes a QUIT call.</li>

<li>KVERSION is still $08.</li>
</ul>

<h3>ProDOS 8 V2.0.1</h3>

<ul>
<li>ProDOS 8 now supports more than two SmartPort devices per slot by
remapping the third device and beyond to different slots.  There's still a
limit of 14 devices altogether, though.</li>

<li>ProDOS 8 version 2.0.1 and later require a 65C02 microprocessor or
equivalent; you get RELOCATION/CONFIGURATION ERROR if you don't have one.  
ProDOS 8 tests for a 65C02 by setting binary-coded decimal (BCD) mode and
adding $01 to $99, which is the largest negative BCD value representable
in an 8-bit register.  65C02 microprocessors correctly clear the N flag
when the addition wraps to zero; 6502 microprocessors do not.</li>

<p>Since all of Apple's 65C02 or greater computers also have lower-case
capability, the ProDOS 8 splash screen now uses lower-case letters. After
only nine years, too.</p>

<li>The file's been rearranged again, so if you have a program that
patches the P8 file, it probably breaks now.  Please learn your lesson and
write a .SYSTEM program that patches ProDOS 8 in memory and not on disk.</li>

<li>The prefix is now set correctly when launching Applesoft programs.</li>

<li>Old never-used code to handle call $42 is now gone.</li>

<li>Removed some RAM-disk code that was not used.</li>

<li>ProDOS 8 now sets the prefix to empty when you try to set the prefix
to "/".</li>

<li>The Apple IIgs clock driver inside ProDOS 8 now limits the year to the
range 00 through 99.</li>

<li>Sparse seedling files are now truncated properly.</li>

<li>When filling up a volume with a WRITE call, ProDOS 8 used to return
the disk full error but leave the file's mark set past the file's EOF.
This is now fixed.</li>

<li>If you try to mount a new volume but all eight VCB slots are filled,
ProDOS 8 now tries to kick out the first volume in the table with no open
files.  If all volumes have open files, you'll still get error $55.</li>

<li>The new quit code (introduced with 1.9) now beeps and lets the user
try another subdirectory if the one they chose can't be opened. Previously
it went forward to the next volume.</li>

<li>The new quit code also now closes a directory if it gets a ProDOS
error in the directory read loop.</li>

<li>When synthesizing a directory entry for a volume, ProDOS 8 always used
to assume the directory was four blocks long (for 51 files).  The /RAM
disk's directory is shorter than this (one block), and ProDOS 8 no longer
returns funky errors when trying to read past the end of this shortened
directory.  The EOF and blocks used are now returned as $200 and 1,
respectively.</li>

<li>The system death messages are now displayed in the center of the
40-column screen, bordered by inverse spaces.  This is an improvement over
the line of garbage showing at the bottom of the screen since
approximately version 1.5.</li>

<li>The new quit code was rearranged to clear the screen prior to loading
the selected application.  This insures that MSLOT ($07F8) points to the
"boot" slot prior to starting the application.  In this way, you can
launch the ProDOS file from GS/OS to start up GS/OS.  (Note that MSLOT
must be set properly for this to work.)</li>

<li>If the device search code at start time finds a SCSI SmartPort, a
SmartPort status call is issued to device #2.  This lets the Apple II
High-Speed SCSI card build its device tables and return the true number of
devices connected.  Without this, it always returns "4" for slot 5 or "2"
for any other slot.</li>

<li>KVERSION is now $21.</li>
</ul>


<h2>Known ProDOS 8 V2.0.1 Bugs</h2>

<ul>
<li>ProDOS 8 still doesn't behave perfectly when 14 or more devices are
present.  Specifically, the /RAM driver tends to install itself without
checking to see whether or not there's room in the device table.</li>
</ul>

<blockquote><em>Caution:</em> ProDOS 8's remapping of SmartPort devices may
interfere with intelligent SmartPort peripherals that were already doing their
own remapping.  ProDOS 8 remaps additional SmartPort devices, even if the
SmartPort firmware already did this on its own, and this can cause problems.  
We never said this would work, but we never said it wouldn't -- ProDOS 8 has
no way to determine what remapping has already been done.  If you make such a
card and your customers have problems, tell them to disable your SmartPort
remapping and let ProDOS 8 do it all.</blockquote>


<h2>Further Reference</h2>

<ul>
<li><a href="/docs/techref/">ProDOS 8 Technical Reference Manual</a></li>
<li>ProDOS 8 Update</li>
<li>AppleShare Programmer's Guide to the Apple II</li>
<li><a href="/docs/technote/21/">ProDOS 8 Technical Note #21</a>, Identifying 
ProDOS Devices</li>
</ul>

<hr>



{% include technote_credit.html %}

