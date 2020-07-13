<div class="vertical-spacer"></div>

### BASIC.system
* Previously, _on the Apple IIe or IIc,_ if you hit the DELETE key you would get the checkerboard. Now if you hit the delete key it will actualy delete the character.
* New **online** command will list devices in the system showing the slot, drive, volume name, and free space.
* Dash _(-)_ will run ProCMD files
  * Runs **CMD** files at `$4000` _(ProCMD)_
  * Now allows for file arguments

{% highlight basic %}

-binfile arg1,arg2
{% endhighlight %}

