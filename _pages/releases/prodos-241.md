---
layout: page
title: ProDOS 2.4.1
permalink: /releases/prodos-241/
download_link: 'https://mirrors.apple2.org.za/ftp.apple.asimov.net/images/masters/prodos/ProDOS_2_4_1.dsk'
---

## Announcing ProDOS 2.4.1 for all Apple II and compatible computers

<div style="width:100%"><img src="/pix/prodos241/ProDOS-2.4.1.png"></div>

<div style="width:100%">ProDOS 2.4.1 adds several improvements and bug fixes to <a href="/releases/prodos-24/">ProDOS 2.4</a>.</div>


* Includes ROM ID detection for many Apple II clones, and workarounds for clone firmware bugs.
  * Franklin Ace
  * Laser 128
  * Unitron
  * Pravetz

* Updates MiniBas to version 1.2.
* Fixes a bug when launching ProDOS 2.4 from GS/OS using Closed-Apple to activate Bitsy Bye.
* Fixes a ROM bug in un-enhanced Apple //e when quitting to Bitsy Bye with 80-column mode enabled.
* Files on disk have been organized for faster booting and file access.
* ProDOS 2.4.1 moves GS/OS support code to the end of the file. This allows PRODOS to be shortened by 1K when used on compilation disks or other 8-bit use-cases where PRODOS will not be used as SYSTEM/P8.
* As a minor update, the ProDOS 2.4.1 KVERSION byte at $BFFF is the same as ProDOS 2.4, (I.E., $24)
* Bitsy Bye is only $300 bytes long yet hides an Easter egg. <em>Who will find it first?</em>




<p>&nbsp;</p>

<div style="width:100%">
Enjoy.
</div>

<p>&nbsp;</p>

<div style="width:100%">
&mdash; John Brooks
</div>

<p>&nbsp;</p>

<div style="width:100%">
Twitter: <a href="https://www.twitter.com/JBrooksBSI">@JBrooksBSI</a>
</div>

<p>&nbsp;</p>

<div style="width:100%">
<a href="{{ page.download_link }}" class="btn btn-lg btn-secondary">Download {{ page.title }}</a></div>

<p>&nbsp;</p>

<div style="width:100%">
If you’d like to support John Brook's efforts to improve the Apple II, donations are welcome using: <a href="https://www.paypal.me/JBrooksBSI">PayPal</a>
</div>
