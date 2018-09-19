---
layout: page
title: ProDOS 2.4
permalink: /releases/prodos-24/
---

<img src="/pix/prodos_24_logo2.svg" onerror="this.onerror=null; this.src='/pix/prodos_24_logo.png'" />

<div class="vertical-spacer"></div>

* **<a href="/about/#johnbrooks">John Brooks</a>** spoke about the development of **ProDOS 2.4** at <a href="https://www.youtube.com/watch?v=Sm4D1wtWPck">KansasFest 2017</a>

<iframe style="margin-left:50px;" src="http://www.youtube.com/embed/Sm4D1wtWPck" width="560" height="315" frameborder="0" allowfullscreen></iframe>

<div class="vertical-spacer"></div>

## Announcing ProDOS 2.4 for all Apple II computers

<p><img src="/pix/prodos24/ProDOS-2.4-Splash.png"></p>

<p>Today, the 30-year anniversary of the Apple IIGS, a new version of the ProDOS operating system has been released.</p>

<p>ProDOS 2.4 adds new features for all Apple II computers, including the 1977 Integer ROM Apple II.</p>


<div class="vertical-spacer"></div>

## Apple IIGS features of ProDOS 2.4

* Preserves GS/OS dormant state – Now multiple ProDOS games or programs can be booted and still return to GS/OS.
* New **Bitsy Boot** utility allows programs to quit to the 8-bit launcher or return to the 16-bit GS/OS Finder.
* New **Bitsy Bye** program launcher is built into ProDOS 2.4 and allows users to run SYS, S16, BIN, BAS, and TXT files.
* ProDOS 2.4 includes both the **6502 compatibility of ProDOS 1.x** and the **slot remapping functionality of ProDOS 2.x**. Now Apple II programs can use a single version of ProDOS to boot any Apple II and access all storage volumes.
* When run from the Finder, the Solid-Apple key selects whether ProDOS 2.4 will Quit to Bitsy Bye or the Finder.
* **ProDOS 2.4 is smaller than ProDOS 2.0.3 and loads faster.**
* The ProDOS 2.4 interrupt manager reduces latency and memory-use, resulting in faster, consistent interrupt response.

<div class="vertical-spacer"></div>

## Apple II features of ProDOS 2.4

* For the first time, the features and improvements of ProDOS 2.x are available on 6502-based Apple ][, Apple ][+, and un-enhanced Apple //e computers.
* All Apple II computers with modern USB storage devices or hard drives can now support up to 14 ProDOS volumes per device.
* Unlike earlier versions of Basic.System which hang on Integer ROM Apple ][ computers. The new Basic.System 1.6 reports that ProDOS Basic requires an Apple ][+ and then quits back to the Bitsy Bye program launcher.
* ProDOS splash screen date of 16-8-16 because Woz.

<div class="vertical-spacer"></div>

## Bitsy Bye program launcher

<em>ProDOS 2.4 includes a new program launcher with many features and improvements over earlier versions of ProDOS:</em>

* Runs on all Apple II computers and CPUs: 6502, 65c02 or 65816.
* Allows drives to be selected directly by slot using number keys 1-7.
* Allows files to be selected by typing the first letter of their filename.
* Displays and quickly scrolls through up to 2,733 files per directory.
* Displays and allows selection of all files on a drive, not just System files and directories like previous launchers.
* Displays file types and allows launching Applesoft Basic, Binary, Text exec, and GS/OS S16 files via Basic.System.
* Displays the slot and drive of each device.
* Does not abort on drive errors, but instead lists and allows launching of all readable files.
* The code and data size for Bitsy Bye is less than 1KB, with room to spare (thanks qkumba).


<p><img src="/pix/prodos24/ProDOS-2.4-Bitsy-Bye.png"></p>

<div class="vertical-spacer"></div>

## Bitsy Boot utility

_Bitsy Boot is a small system program which allows quick and easy booting of Apple II devices in various slots:_

* Displays all slots which contain active ProDOS devices.
* Allows one-press booting of slots 1-7.
* The most recently-used ProDOS device can be booted using Return or Space.
* If GS/OS was previously booted and is dormant, Open-Apple-Q or Open-Apple-Escape will quit back to GS/OS.
* Bitsy Boot takes only 1 block on disk. Code and data are under 400 bytes.


<p><img src="/pix/prodos24/ProDOS-2.4-Bitsy-Boot.png"></p>

<div class="vertical-spacer"></div>

## Utilities

_The 140k 5.25" disk image of ProDOS 2.4 disk also includes these useful utilities:_


* New **MiniBas** _by Usotsuki_ – Great for compilation disks, this tiny program can be used instead of Basic.System:
  * Requires only 1 block on disk vs 21 blocks for Basic.System
  * Loads and runs Binary and Basic programs launched by Bitsy Bye.
  * Provides two commands:
    * <strong>&"Filename"</strong> runs a Binary or Basic program.
    * <strong>&</strong> by itself will quit back to ProDOS.

* **Disk Imaging Programs** – ADT Pro and FastDsk allow migrating data from floppy disks to modern computers.
* **Disk Utilities** – Verify and repair disks. View and edit disk blocks.
* **File Utilities** – Manage ProDOS and DOS 3.3 files and disks on any Apple II, including Integer ROM Apple ][.
* **Shrinkit archive expander** – Access Apple II Shrinkit archives commonly found on the internet.





<div class="vertical-spacer"></div>

<div style="width:100%">
Enjoy.
</div>

<div class="vertical-spacer"></div>

<div style="width:100%">
&mdash; John Brooks
</div>

<div class="vertical-spacer"></div>

<div style="width:100%">
Twitter: <a href="https://www.twitter.com/JBrooksBSI">@JBrooksBSI</a>
</div>

<div class="vertical-spacer"></div>

<div style="width:100%">
Download <a href="https://mirrors.apple2.org.za/ftp.apple.asimov.net/images/masters/prodos/ProDOS_2_4.dsk">ProDOS_2_4.dsk</a>
</div>

<div class="vertical-spacer"></div>

<div style="width:100%">
If you'd like to support John Brook's efforts to improve the Apple II, donations are welcome using: <a href="https://www.paypal.me/JBrooksBSI">PayPal</a>
</div>