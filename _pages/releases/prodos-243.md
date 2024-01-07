---
layout: page
title: ProDOS 2.4.3
permalink: /releases/prodos-243/
download_link: 'https://releases.prodos8.com/ProDOS_2_4_3.po'
---

## Announcing ProDOS 2.4.3 for all Apple II computers

<img src="/pix/prodos243/ProDOS-2.4.3-title.png">

* ProDOS 2.4.3 updates the **Thunderclock year table** so it goes beyond 2023.
* ProDOS 2.4.2 replaces the previous <a href="/releases/prodos-24/">ProDOS 2.4</a>, <a href="/releases/prodos-241/">ProDOS 2.4.1</a>, and <a href="/releases/prodos-242/">ProDOS 2.4.2</a> releases.

<p>&nbsp;</p>







## Bugs fixed:

* Fix long standing bug where `CATALOG` would fail on **directories** that have `128 blocks` or more.
- Fix crash starting **A2osX** _([issue 55](https://github.com/ProDOS-8/ProDOS8-Testing/issues/55))_.
- Fix bug where ProDOS would not distinguish disks with the same volume name, _([issues 46](https://github.com/ProDOS-8/ProDOS8-Testing/issues/46))_ and _([issue 50](https://github.com/ProDOS-8/ProDOS8-Testing/issues/50))_.
- Fix **splash screen** to not use lower case on II and II+ machines with a **65C02 or 65816 CPU upgrade**.
- Fix long standing bug that prevented **creating more than 33024 files in a directory**.
- Fix long standing bug where `SET_MARK` on **directories** would fail for **offsets** past `block 128`.

<p>&nbsp;</p>

## Updates:

<img src="/pix/prodos243/ProDOS-2.4.3-apps.png">

* ADT Pro removed from the disk image because of size constraints

* Thunderclock driver updated for years 2023-2028, _([issue 72](https://github.com/ProDOS-8/ProDOS8-Testing/issues/72))_.

### `BASIC.SYSTEM` changed from 1.6 to 1.7:

* Delete key is mapped to left arrow.
* `RENAME` command supports using space _(new)_ or comma _(as before)_ between the filenames, e.g. `RENAME f1 f2`.
* Bump `IVERSION` to `7` at globals `$BFFD`



<p>&nbsp;</p>

<div style="width:100%">
Please file bug reports at: <a href="https://github.com/ProDOS-8/ProDOS8-Testing/issues">github.com/ProDOS-8/ProDOS8-Testing</a>
</div>

<p>&nbsp;</p>

<div style="width:100%">
Enjoy.
</div>

<p>&nbsp;</p>

<div style="width:100%">
&mdash; John Brooks and Friends
</div>

<p>&nbsp;</p>

<div style="width:100%">
Twitter: <a href="https://www.twitter.com/JBrooksBSI">@JBrooksBSI</a>
</div>
<p>&nbsp;</p>
<div style="width:100%">
<a href="{{ page.download_link }}" class="btn btn-lg btn-secondary">Download {{ page.title }}</a>
</div>
<p>&nbsp;</p>
<div style="width:100%">
If you’d like to support John Brook's efforts to improve the Apple II, donations are welcome using: <a href="https://www.paypal.me/JBrooksBSI">PayPal</a>
</div>
