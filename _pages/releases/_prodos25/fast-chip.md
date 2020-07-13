<div class="vertical-spacer"></div>
#### [FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147) Compatibility

* The [FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147) //e accelerates the Apple //e up to 16.6 Mhz by replacing the microprocessor with a faster one.
* There is a known issue with **[FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147) //e NTSC** _(firmware 0.5b)_ in slot 1.
* When booting the machine, with the [FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147) //e installed, the machine will drop to the monitor.
* **ProDOS** leverages a CPU call to determine if you are using an Apple IIe, IIc, or IIgs.
* Specifically, the `REP #2` CPU call is used in **Bitsy Bye** to determine if `$C029` can be safely changed because the machine is not a **//c+**.

{% highlight asm %}
ldx   #$ff-$20

:ZpLoop
lda InitZpEnd-$FF,x ;Init ZP vars
sta ZpMoveEnd-$FF&$FF,x
inx
bne :ZpLoop ;Loop ends with Z=1
rep #2  ;Clr Z. Test for 65816 CPU
beq :NotGS
trb IoNewVideo ;Disable SHR
:NotGS
{% endhighlight %}

* That CPU call, `REP #2`, has documented behavior on the **65c02** and **65816** chips.<br />On the **6502** it is undocumented but effectively a NOP.
* The problem is that **[FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147)** does not execute this instruction as documented and instead uses it for internal purposes.
* Unfortunately, the **[FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147)** is not 100% compatible with the official processors.
* It has been reported that machines with the **[FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147)** will boot successfully on ProDOS 2.5a7 or later, although no code changes were made in ProDOS to accomodate the **[FASTChip](http://www.a2heaven.com/webshop/index.php?rt=product/product&product_id=147)**, so your mileage may vary.

