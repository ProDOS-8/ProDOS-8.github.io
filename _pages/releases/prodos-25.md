---
layout: page
title: ProDOS 2.5 Alpha 7
permalink: /releases/prodos-25/
download_link: 'http://prodos8-releases.s3-website-us-east-1.amazonaws.com/ProDOS_2_5_a7_143k.dsk'
alpha_title:   "ProDOS 2.5 Alpha 7"
---

<img src="/pix/prodos_25_logo2.svg" onerror="this.onerror=null; this.src='/pix/prodos_25_logo.png'" />

<div class="vertical-spacer"></div>

## {{ page.alpha_title }}

<img src="/pix/prodos25/ProDOS-2.5a3_orange.png" />

* Download the [{{ page.alpha_title }}]({{ page.download_link }}) _(143k)_ image

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
* ProDOS BASIC.system 1.7a8
* `BITSY.BOOT` now built-in to [Bitsy-Bye](/bitsy-bye/).



### The 2.5 alpha7 Pre-Release includes

* ProDOS 2.5a7 kernel
* ProDOS BASIC.system 1.7a10
* [Copy II Plus 8.5a1](/copy-ii-plus/)




### [Copy II Plus 8.5a1](/copy-ii-plus/)

* Patched to work with ProDOS 2.5's multi-case filesystem and dates.


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
* Support has been added for up to **8 drives per slot**.
* Up to 37 total drives can be mounted at once.

#### Application support for 37 drives

* It is likely that Applications which directly call a drive's card ROM driver, _such as Total Replay_, will need an update, _or modification,_ to take advantage of drives 3-8 on ProDOS 2.5.
* In addition to mounting up to 37 drives, a goal of the new **8 drives per slot** feature is to make it easier and more reliable for applications which use **[ProRWTS](https://github.com/peterferrie/prorwts)** to find the **SmartPort Driver** and device from which they are being launched.

<div class="vertical-spacer"></div>
### Extended Date format
<div class="vertical-spacer"></div>
_As seen in ProDOS Alpha 4_

<div class="vertical-spacer"></div>
#### Legacy ProDOS 8 Date Format:

<!--
```

        49041 ($BF91)     49040 ($BF90)
       7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0 
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
DATE: |    year     |  month  |   day   |
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

        49043 ($BF93)     49042 ($BF92)
       7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0 
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
TIME: |0 0 0|   hour  | |0 0|  minute   |
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
```
-->

<style type="text/css">
  table#extended-date-format tr td {
    font-family:monospace;
    border:1px #000000 solid;
    padding:5px;
  }
  table#extended-date-format tr.extended-date-format-memory-location td {
    text-align:center;
    font-weight:bold;
  }


  td#memory-location-49039 { background-color:#513898; color:#ffffff; font-weight:bold; } /* BCA9F5 */
  td#memory-location-49038 { background-color:#a2249e; color:#ffffff; font-weight:bold; } /* F5A9F2 */

  td#memory-location-49041 { background-color:#c43030; color:#ffffff; font-weight:bold; } /* F5A9A9 */
  td#memory-location-49040 { background-color:#90942b; color:#ffffff; font-weight:bold; } /* F2F5A9 */
  td#memory-location-49043 { background-color:#3f8826; color:#ffffff; font-weight:bold; } /* 9FF781 */
  td#memory-location-49042 { background-color:#22619b; color:#ffffff; font-weight:bold; } /* A9D0F5 */


  td.ml49039 { background-color:#BE81F7; }
  td.ml49038 { background-color:#F781F3; }

  td.ml49041 { background-color:#F78181; }
  td.ml49040 { background-color:#F4FA58; }
  td.ml49043 { background-color:#A5DF00; }
  td.ml49042 { background-color:#58ACFA; }


  td.memory-location-datetime { font-weight:bold; background-color:#000000; color:#ffffff; }

  td#memory-location-seconds      { background-color:#BCA9F5; }
  td#memory-location-milliseconds { background-color:#F5A9F2; }

  td#memory-location-year   { background-color:#F5A9A9; }
  td#memory-location-month  { background-color:#F2F5A9; }
  td#memory-location-day    { background-color:#F2F5A9; }
  td#memory-location-hour   { background-color:#9FF781; }
  td#memory-location-minute { background-color:#A9D0F5; }

  td.unused { background-color:#cccccc; }
  td.nobo { border:none !important; }
  td.descr { background-color:#efefef; }
</style>

<div class="vertical-spacer"></div>
<table id="extended-date-format">
<tr class="extended-date-format-memory-location"><td class="nobo">&nbsp;</td><td id="memory-location-49041" colspan="8">49041 ($BF91)</td><td id="memory-location-49040" colspan="8">49040 ($BF90)</td></tr>
<tr><td class="nobo">&nbsp;</td><td class="ml49041">7</td><td class="ml49041">6</td><td class="ml49041">5</td><td class="ml49041">4</td><td class="ml49041">3</td><td class="ml49041">2</td><td class="ml49041">1</td><td class="ml49041">0</td><td class="ml49040">7</td><td class="ml49040">6</td><td class="ml49040">5</td><td class="ml49040">4</td><td class="ml49040">3</td><td class="ml49040">2</td><td class="ml49040">1</td><td class="ml49040">0</td></tr>
<tr><td class="memory-location-datetime">DATE</td><td colspan="7"  id="memory-location-year">year</td><td style="border-right:none !important;" colspan="1"  id="memory-location-year">m</td><td style="border-left:none !important;" colspan="4"  id="memory-location-month">onth</td><td colspan="5"  id="memory-location-day">day</td></tr>
<tr><td class="nobo">&nbsp;</td></tr>
<tr class="extended-date-format-memory-location"><td class="nobo">&nbsp;</td><td id="memory-location-49043" colspan="8">49043 ($BF93)</td><td id="memory-location-49042" colspan="8">49042 ($BF92)</td></tr>
<tr><td class="nobo">&nbsp;</td><td class="ml49043">7</td><td class="ml49043">6</td><td class="ml49043">5</td><td class="ml49043">4</td><td class="ml49043">3</td><td class="ml49043">2</td><td class="ml49043">1</td><td class="ml49043">0</td><td class="ml49042">7</td><td class="ml49042">6</td><td class="ml49042">5</td><td class="ml49042">4</td><td class="ml49042">3</td><td class="ml49042">2</td><td class="ml49042">1</td><td class="ml49042">0</td></tr>
<tr><td class="memory-location-datetime">TIME</td><td class="unused">0</td><td class="unused">0</td><td class="unused">0</td><td colspan="5"  id="memory-location-hour">hour</td><td class="unused">0</td><td class="unused">0</td><td colspan="6"  id="memory-location-minute">minute</td></tr>
</table>




<div class="vertical-spacer"></div>
#### 2.5.0a4+ Extended time/date returned by Clock driver:

<!--
```
        49039 ($BF8F)     49038 ($BF8E)  
       7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0 
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
SEC:  |0 0|  seconds  | |milliseconds*4 |
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
      seconds = 0-59, milliseconds = 0-249

        49041 ($BF91)     49040 ($BF90)
       7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0 
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
TIME: |  day    |    hour   |  minute   |
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
      day = 1-31, hour = 0-23, minute = 0-59

        49043 ($BF93)     49042 ($BF92)
       7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0 
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
DATE: | month |     year from 0 CE      |
      +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
      month = 2-13, year = 0-4095
      * month +1 keeps top 3 bits from being 0,
        differentiating it from pre-2.5 format
```
-->

<div class="vertical-spacer"></div>
<table id="extended-date-format">
<tr class="extended-date-format-memory-location"><td class="nobo">&nbsp;</td><td id="memory-location-49039" colspan="8">49039 ($BF8F)</td><td id="memory-location-49038" colspan="8">49038 ($BF8E)</td></tr>
<tr><td class="nobo">&nbsp;</td><td class="ml49039">7</td><td class="ml49039">6</td><td class="ml49039">5</td><td class="ml49039">4</td><td class="ml49039">3</td><td class="ml49039">2</td><td class="ml49039">1</td><td class="ml49039">0</td><td class="ml49038">7</td><td class="ml49038">6</td><td class="ml49038">5</td><td class="ml49038">4</td><td class="ml49038">3</td><td class="ml49038">2</td><td class="ml49038">1</td><td class="ml49038">0</td></tr>
<tr><td class="memory-location-datetime">SEC</td><td class="unused">0</td><td class="unused">0</td><td colspan="6"  id="memory-location-seconds">seconds</td><td colspan="8"  id="memory-location-milliseconds">milliseconds*4</td></tr>
<tr><td class="nobo">&nbsp;</td><td colspan="16" class="descr">
<ul>
<li>seconds = 0-59</li>
<li>milliseconds = 0-249</li>
</ul>
</td></tr>

<tr><td class="nobo">&nbsp;</td></tr>
<tr class="extended-date-format-memory-location"><td class="nobo">&nbsp;</td><td id="memory-location-49041" colspan="8">49041 ($BF91)</td><td id="memory-location-49040" colspan="8">49040 ($BF90)</td></tr>
<tr><td class="nobo">&nbsp;</td><td class="ml49041">7</td><td class="ml49041">6</td><td class="ml49041">5</td><td class="ml49041">4</td><td class="ml49041">3</td><td class="ml49041">2</td><td class="ml49041">1</td><td class="ml49041">0</td><td class="ml49040">7</td><td class="ml49040">6</td><td class="ml49040">5</td><td class="ml49040">4</td><td class="ml49040">3</td><td class="ml49040">2</td><td class="ml49040">1</td><td class="ml49040">0</td></tr>
<tr><td class="memory-location-datetime">TIME</td><td colspan="5"  id="memory-location-year">day</td><td style="border-right:none !important; text-align:right;" colspan="3"  id="memory-location-year">ho</td><td style="border-left:none !important;" colspan="2"  id="memory-location-month">ur</td><td colspan="6"  id="memory-location-day">minute</td></tr>
<tr><td class="nobo">&nbsp;</td><td colspan="16" class="descr">
<ul>
<li>day = 1-31</li>
<li>hour = 0-23</li>
<li>minute = 0-59</li>
</ul>
</td></tr>

<tr><td class="nobo">&nbsp;</td></tr>
<tr class="extended-date-format-memory-location"><td class="nobo">&nbsp;</td><td id="memory-location-49043" colspan="8">49043 ($BF93)</td><td id="memory-location-49042" colspan="8">49042 ($BF92)</td></tr>
<tr><td class="nobo">&nbsp;</td><td class="ml49043">7</td><td class="ml49043">6</td><td class="ml49043">5</td><td class="ml49043">4</td><td class="ml49043">3</td><td class="ml49043">2</td><td class="ml49043">1</td><td class="ml49043">0</td><td class="ml49042">7</td><td class="ml49042">6</td><td class="ml49042">5</td><td class="ml49042">4</td><td class="ml49042">3</td><td class="ml49042">2</td><td class="ml49042">1</td><td class="ml49042">0</td></tr>
<tr><td class="memory-location-datetime">DATE</td><td colspan="4"  id="memory-location-hour">month</td><td style="border-right:none !important; text-align:right;" colspan="4"  id="memory-location-hour">year</td><td style="border-left:none !important;" colspan="8"  id="memory-location-minute">from 0 CE</td></tr>
<tr><td class="nobo">&nbsp;</td><td colspan="16" class="descr">
<ul>
<li>month = 2-13</li>
<li>year = 0-4095</li>
<li>month +1 keeps top 3 bits from being 0,<br />differentiating it from pre-2.5 format</li>
</ul>
</td></tr>

</table>




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


<div class="vertical-spacer"></div>
### Conversion of ProDOS source code to [Merlin32](https://www.brutaldeluxe.fr/products/crossdevtools/merlin/)

- Some **initial** R&D work to convert the ProDOS source code from Apple's MPW AsmIIGS cross-assembler syntax into Merlin32 syntax.
- _[Merlin 32 is a multi-pass Cross Assembler running under Windows, Linux and Mac OS X targeting 8 bit processors in the 6502 series (such as 6502 and 65c02) and the 16 bit 65c816 processor.](https://www.brutaldeluxe.fr/products/crossdevtools/merlin/)_
- The goal is to _eventually_ have one build environment and assembly syntax for the ProDOS kernel, [Bitsy Bye](/bitsy-bye/), the new loader, and the new drivers.
- _This is a long term goal and may not be included in the ProDOS 2.5 release._






