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

