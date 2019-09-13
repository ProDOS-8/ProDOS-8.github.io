---
layout: page
title: ProDOS 2.5 alpha 3
permalink: /releases/prodos-25/
download_link: 'http://prodos8-releases.s3-website-us-east-1.amazonaws.com/ProDOS_2_5_a5_143k.po'
alpha_title:   "ProDOS 2.5 Alpha 5"
---

<img src="/pix/prodos_25_logo2.svg" onerror="this.onerror=null; this.src='/pix/prodos_25_logo.png'" />

<div class="vertical-spacer"></div>

## {{ alpha_title }}

<img src="/pix/prodos25/ProDOS-2.5a3_orange.png" />

* Download the [{{ alpha_title }}]({{ page.download_link }}) _(143k)_ image

### Please help testing!

* Please **submit all issues** on the [GitHub Project Page](https://github.com/ProDOS-8/ProDOS8-Testing/issues) under the [ProDOS8-Testing Issue section](https://github.com/ProDOS-8/ProDOS8-Testing/issues).



#### There _may_ be a lurking problem in 2.5a3 with using **EXEC** to load Applesoft source code into memory.

{% highlight basic %}
LOAD TEST
LIST
RUN
{% endhighlight %}


#### Filename CASE.compatibility

* Some apps have been identified to break on 2.5a which has introduced lowercase name support.
* Lowercase name app compatibility issues that have been observed so far include:

<style type="text/css">


  div.page-banner span.phone a.btn-secondary {
    background-color:#ffae36 !important;
    border-color:#cd3d41 !important;
    color:#292929 !important;
  }
  div.page-banner span.phone a.btn-secondary:hover {
    background-color:#292929 !important;
    border-color:#ffae36 !important;
    color:#ffae36 !important;
  }

  div.page-banner h1 { color: #ffae36 !important; }

  .table-header-top-row {
    background-color:#292929;
    /* color: #00ff95; */
    color: #ffae36;
    font-family: "Apple2Forever80";
    margin: 5px;
  }
  table#case-compatibility-issues { margin-left:50px; }
  img.indented { margin-left:50px; }
  table#case-compatibility-issues,
  table#case-compatibility-issues tr th,
  table#case-compatibility-issues tr td {
    border: 0.5px #292929 solid;
  }
  table#case-compatibility-issues tr th,
  table#case-compatibility-issues tr td {
    padding:5px;
    margin:0px;
  }
  table#case-compatibility-issues tr.even td {
    background-color:#ffffff;
  }
  table#case-compatibility-issues tr.odd td {
    background-color:#efefef;
  }

  code.language-basic,
  figure.highlight pre code {
    color: #ffae36 !important;
    font-size:21px;
  }

</style>

<table id="case-compatibility-issues">
<tr class="table-header-top-row"><th> App </th><th> Version   </th><th> Description </th></tr>
<tr class="odd"><td> <strong>MouseDesk</strong> </td><td> <em>v1.1</em>         </td><td> Crashes if launched from <code class="highlighter-rouge">BASIC.system</code> </td></tr>
<tr class="even"><td> <strong>Copy ][ +</strong> </td><td> <em>All versions</em> </td><td> Crashes if the volume name contained lowercase. </td></tr>
<tr class="odd"><td> <strong>Diskmaker 8</strong> </td><td> <em>v1.1</em>       </td><td> Drops to the monitor </td></tr>
</table>

* If you observe issues when using UPPERCASE names, that would point to a core OS bug<br />_vs a lowercase name incompatibility._
* Please make us aware of any isuses discovered with name compatibility.
* If you believe an app is incompatible with lowercase names:<br />Try testing those apps again.<br />Change the ProDOS8 MachineID to an `Apple II+`.<br />Using an `Apple II+` MachineID will force ProDOS 2.5a to automatically UPPERCASE all names.<br />Set the MachineID to Apple II+ using the BASIC command:

<!--
{% highlight basic %}
BF98: 63
{% endhighlight %}

_or_
-->

{% highlight basic %}

POKE 49048,99

{% endhighlight %}

* ProDOS memory location 49048 _(`$BF98`)_ stores the Machine ID, which can be altered using a BASIC **POKE** command:

{% highlight basic %}
PRINT PEEK(49048)
POKE 49048,99
PRINT PEEK(49048)
{% endhighlight %}

_In the example above, only the **POKE** command is required. Use the **PEEK** commands to view the contents of memory location 49048 before and after the **POKE**_

<img class="indented" src="/pix/prodos25/basic_poke_49048_99_orange.png" />

<!--

{% highlight basic %}
10 PRINT "IDENTIFY MACHINE TYPE"
20 MACHID = PEEK(49048)
30 IF MACHID > = 192 THEN MACHNAME = "APPLE ///": GOTO 100
50 IF MACHID > = 179 THEN MACHNAME = "Apple IIgs": GOTO 100
60 IF MACHID > = 128 THEN MACHNAME = "Apple //e": GOTO 100
60 IF MACHID > =  64 THEN MACHNAME = "APPLE ][ PLUS": GOTO 100
70 MACHNAME = "APPLE ]["
100 REM 
{% endhighlight %}

-->


* After poking the Machine ID to be 99, you will notice that the **Bitsy-Bye** catalog is all-UPPERCASE.

<img class="indented" src="/pix/prodos25/bitsy-bye-uppercase_orange.png" />



### The 2.5 alpha3 Pre-Release includes

* ProDOS 2.5a3 Kernel
* Latest [Bitsy-Bye](/bitsy-bye/) _(QUIT.system)_
* ProDOS BASIC.system 1.7d8
* `BITSY.BOOT` now built-in to [Bitsy-Bye](/bitsy-bye/).


### Apple III Kernel

* This release includes the experimental ProDOS kernel for the Apple III.
* If you are interested in testing the Apple III ProDOS kernel it would be a great help to the ProDOS 2.5 efforts.

<img class="indented" src="/pix/prodos25/ProDOS-2.5a2-bitsybye_orange.png" />



<div class="vertical-spacer"></div>

## KansasFest 2018 Announcement

<!-- img src="/pix/prodos25/ProDOS-2.5.png" / -->

* **<a href="/about/#johnbrooks">John Brooks</a>** announced **ProDOS 2.5** at <a href="https://www.youtube.com/watch?v=vcYunzxu-0w">KansasFest 2018</a>

<!-- iframe style="margin-left:50px; border:0.5px #dddddd solid;" src="http://www.youtube.com/embed/vcYunzxu-0w" width="560" height="315" frameborder="0" allowfullscreen></iframe -->
<a href="https://www.youtube.com/watch?v=vcYunzxu-0w"><img style="margin-left:50px; border:0.5px #dddddd solid; width:560px; height:315px;" src="/pix/prodos25/youtube_kansasfest_presentation.png" /></a>


<div class="vertical-spacer"></div>

## Changes

* Lowercase volume support.
* Lowercase filenames match what GS/OS and the Finder use.<br />_If an application does not support lowercase filenames they will read the directory and see uppercase filenames._<br />_There is no case sensitivity in the filenames._
* Can pass relative path arguments to commands, such as:

{% highlight basic %}

CAT ..
PREFIX ../..
{% endhighlight %}

* Year has been expanded from 7-bits _(127 years)_ to 10-bits _(1,024 years)_ to allow date support until the year 2924.<br />_There is still a year 2040 problem where the 24-bit timer on the Apple IIgs will wrap around to 1900._


<div class="vertical-spacer"></div>

### <a href="/bitsy-bye">Bitsy Bye</a>
* Upgraded version of **<a href="/bitsy-bye">Bitsy Bye</a>**
* Bottom border in Bitsy Bye has been removed so the number of files that can be viewed at once is has increased from 20 to 22.
* Merges in features from **<a href="/bitsy-boot">Bitsy Boot</a>**:
  * When using GS/OS, and running ProDOS, pressing **DELETE** will take you back to the GS/OS Finder.
  * Can boot to a slot by selecting it and pressing **RESET**.


<div class="vertical-spacer"></div>

### BASIC.system
* Previously, _on the Apple IIe or IIc,_ if you hit the DELETE key you would get the checkerboard. Now if you hit the delete key it will actualy delete the character.
* New **online** command will list devices in the system showing the slot, drive, volume name, and free space.
* Dash _(-)_ will run ProCMD files
  * Runs **CMD** files at $4000 _(ProCMD)_
  * Now allows for file arguments

{% highlight basic %}

-binfile arg1,arg2
{% endhighlight %}


<div class="vertical-spacer"></div>

### 51-file limit on the root directory removed

* The new ProDOS 2.5 boot loader will find the ProDOS file anywhere in the root directory linked-list.
* ProDOS 2.5 should allow unlimited files in the root directory level.

#### GS/OS support for more than 51 files in the root directory

* There is a new GS/OS **PRO.FST** driver to support the removal of the 51 files restriction.


### No More Wacky Slot Remapping and Raised Max Drive Count

_As of ProDOS 2.5 alpha5:_
* Support has been added for up to 8 drives per slot.
* Up to 37 total drives can be mounted at once.

<div class="vertical-spacer"></div>

### ProDOS 2.5 on the Apple /// ?

* ProDOS 2.5 includes a new Boot Loader that works on Apple ///.
* With this new Boot Loader, _along with some future development work,_ <br />ProDOS could **potentially** run on the Apple /// !

<img style="margin-left:100px;" src="/pix/prodos25/prodos-2.5_on_appleiii.png" />

<div class="vertical-spacer"></div>

### New Boot Loader

* The new boot loader can also load all, _or just part,_ of the ProDOS file at boot so new versions of ProDOS  can append machine-specific drivers after the core ProDOS kernel without having to load all drivers on all platforms during every boot.



<div class="vertical-spacer"></div>

## Looking for Contributors

_<a href="/contact/#johnbrooks">Please contact John Brooks to get involved.</a>_

* Code writers
* Testers




<div class="vertical-spacer"></div>

## In-Progress Features

* Modify Global Page so it's easier to turn on/off features without changing the machine type.<br />_Features like the large-date support or the lowercase filenames could then easily be disabled to support apps which do not play nice with those features._
* Modify COPY+ and Cat Doctor to support lowercase filenames and the longer-date.<br />_When COPY+ doesn't see a normal ProDOS filename it assumes that the disk is DOS3.3 and tries to use the DOS3.3 parser._


### Conversion of ProDOS source code to [Merlin32](https://www.brutaldeluxe.fr/products/crossdevtools/merlin/)

- Some **initial** R&D work to convert the ProDOS source code from Apple's MPW AsmIIGS cross-assembler syntax into Merlin32 syntax.
- _[Merlin 32 is a multi-pass Cross Assembler running under Windows, Linux and Mac OS X targeting 8 bit processors in the 6502 series (such as 6502 and 65c02) and the 16 bit 65c816 processor.](https://www.brutaldeluxe.fr/products/crossdevtools/merlin/)_
- The goal is to _eventually_ have one build environment and assembly syntax for the ProDOS kernel, [Bitsy Bye](/bitsy-bye/), the new loader, and the new drivers.
- _This is a long term goal and may not be included in the ProDOS 2.5 release._






