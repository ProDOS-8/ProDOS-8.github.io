---
layout: page
title: ProDOS 2.5
permalink: /releases/prodos-25/
---

<img src="/pix/prodos_25_logo2.svg" onerror="this.onerror=null; this.src='/pix/prodos_25_logo.png'" />

* **<a href="/about/#johnbrooks">John Brooks</a>** announced **ProDOS 2.5** at <a href="https://www.youtube.com/watch?v=vcYunzxu-0w">KansasFest 2018</a>

<iframe style="margin-left:50px;" src="http://www.youtube.com/embed/vcYunzxu-0w" width="560" height="315" frameborder="0" allowfullscreen></iframe>

* _No downloable disk image is available yet._


<p>&nbsp;</p>

## Changes

* Lowercase volume support.
* Lowercase filenames match what GS/OS and the Finder use.<br />_If an application does not support lowercase filenames they will read the directory and see uppercase filenames._<br />_There is no case sensitivity in the filenames._
* Can pass relative path arguments to commands, such as:

<div class="highlight"><pre><code data-lang="prodos">
CAT ..
PREFIX ../..
</code></pre></div>

* Year has been expanded from 7-bits _(127 years)_ to 10-bits _(1,024 years)_ to allow date support until the year 2924.<br />_There is still a year 2040 problem where the 24-bit timer on the Apple IIgs will wrap around to 1900._


<p>&nbsp;</p>

### <a href="/bitsy-bye">Bitsy Bye</a>
* Upgraded version of **<a href="/bitsy-bye">Bitsy Bye</a>**
* Bottom border in Bitsy Bye has been removed so the number of files that can be viewed at once is has increased from 20 to 22.
* Merges in features from **<a href="/bitsy-boot">Bitsy Boot</a>**:
  * When using GS/OS, and running ProDOS, pressing **DELETE** will take you back to the GS/OS Finder.
  * Can boot to a slot by selecting it and pressing **RESET**.


<p>&nbsp;</p>

### BASIC.system
* Previously, on the Apple IIe or IIc, if you hit the DELETE key you would get the checkerboard. Now if you hit the delete key it will actualy delete the character.
* New **online** command will list devices in the system showing the slot, drive, volume name, and free space.
* Dash _(-)_ will run ProCMD files
  * Runs **CMD** files at $4000 _(ProCMD)_
  * Now allows for file arguments

<div class="highlight"><pre><code data-lang="prodos">
-binfile arg1,arg2
</code></pre></div>


<p>&nbsp;</p>

## Looking for Contributors

_<a href="/contact/#johnbrooks">Please contact John Brooks to get involved.</a>_

* Code writers
* Testers




<p>&nbsp;</p>

### In-Progress Features

* Modify Global Page so it's easier to turn on/off features without changing the machine type.<br />_Features like ike the large-date support or the lowercase filenames could then easily be disabled to support apps which do not play nice with those features._
* Modify COPY+ and Cat Doctor to support lowercase filenames and the longer-date.<br />_When COPY+ doesn't see a normal ProDOS filename it assumes that the disk is DOS3.3 and tries to use the DOS3.3 parser._








