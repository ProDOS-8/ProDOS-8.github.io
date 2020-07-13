<div class="vertical-spacer"></div>
### No More Wacky Slot Remapping and Raised Max Drive Count

_As of ProDOS 2.5 alpha5:_
* Support has been added for up to **8 drives per slot**.
* Up to 37 total drives can be mounted at once.

<div class="vertical-spacer"></div>
#### _How_ ProDOS 2.5 supports 8 drives per slot

<div class="vertical-spacer"></div>
##### **Bit layout for the ProDOS 2.5 unitnum:**
* `76543210`
* `DSSS00XY`


<div class="vertical-spacer"></div>
##### **Where**

<div class="vertical-spacer"></div>
<table id="case-compatibility-issues">
<tr class="table-header-top-row"><th>DSSS</th><th>00</th><th>X</th><th>Y</th></tr>
<tr><td><strong>Drive bit 0</strong> and <strong>Slot bits 2:0</strong> like previous ProDOS versions</td><td></td><td>Drive bit 2</td><td>Drive bit 1</td></tr>
</table>






<div class="vertical-spacer"></div>
##### **To calculate the drive number _(1-8)_ from a ProDOS 2.5 unitnum in Acc:**

{% highlight asm %}
ASL
AND #7
ADC #1
{% endhighlight %}

* The internal `/RAM` drive in slot 3, drive 2 has a unitnum of `$B0` _(vs `$BF` in 2.4)_.

* ProDOS 2.5 now supports up to 37 drives stored at `$BF32-$BF56`, with a `$00` terminator at `$BF57`.

* All 8 drives per slot use the per-slot driver handler at `$BF12-$BF1F` with the **drive 2** driver unused. 
* However the internal `/RAM` driver is still called through the **slot 3, drive 2** handler at `$BF26` for compatibility with apps which disconnect `/RAM` in order to use **aux memory**.



<div class="vertical-spacer"></div>
#### Application support for 37 drives

* It is likely that Applications which directly call a drive's card ROM driver, _such as Total Replay_, will need an update, _or modification,_ to take advantage of drives 3-8 on ProDOS 2.5.
* In addition to mounting up to 37 drives, a goal of the new **8 drives per slot** feature is to make it easier and more reliable for applications which use **[ProRWTS](https://github.com/peterferrie/prorwts)** to find the **SmartPort Driver** and device from which they are being launched.

