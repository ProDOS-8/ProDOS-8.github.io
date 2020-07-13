<div class="vertical-spacer"></div>
### Extended Date format

<ul>
<li>The <strong>Legacy</strong> data format uses 4 bytes <em>(32-bits)</em> to store the date and time.</li>
<li>The <strong>Extended</strong> data format uses 4 bytes <em>(32-bits)</em> to store the date and time for <strong>directory listings</strong>.</li>
<li>The <strong>Extended</strong> data format uses 6 bytes <em>(48-bits)</em> to store the date and time for <strong>global entries</strong>.</li>
</ul>

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



  table#extended-date-format-sec-msec { 
    /* border:1px #292929 dashed; */
    padding-bottom:10px;
  }
  td#extended-date-format-sec-msec-title { 
    border:1px #292929 solid;
    background-color:#292929;
    color:#ffffff;
    font-weight:bold;
  }
  td#extended-date-format-sec-msec-details { 
    border:2px #7b9ed9 dashed;
    padding:10px;
    margin:10px;
    /* background-color:#efefef; */
    /* border-radius: 25px; */
    background: repeating-linear-gradient(
      45deg,
      #ced1e3,
      #ced1e3 5px,
      #efefef 5px,
      #ffffff 10px
    );
  }
  td.global-or-directory {
    padding-left:15px;
    width:50px;
  }


  table#extended-date-format {
    width:600px;
  }

</style>

<div class="vertical-spacer"></div>



<table id="extended-date-format">
<tr class="extended-date-format-memory-location"><td class="nobo">&nbsp;</td><td id="memory-location-49041" colspan="8">49041 ($BF91)</td><td id="memory-location-49040" colspan="8">49040 ($BF90)</td></tr>
<tr><td class="nobo">&nbsp;</td><td class="ml49041">7</td><td class="ml49041">6</td><td class="ml49041">5</td><td class="ml49041">4</td><td class="ml49041">3</td><td class="ml49041">2</td><td class="ml49041">1</td><td class="ml49041">0</td><td class="ml49040">7</td><td class="ml49040">6</td><td class="ml49040">5</td><td class="ml49040">4</td><td class="ml49040">3</td><td class="ml49040">2</td><td class="ml49040">1</td><td class="ml49040">0</td></tr>
<tr><td class="memory-location-datetime">DATE</td><td colspan="7"  id="memory-location-year">year</td><td style="border-right:none !important;" colspan="1"  id="memory-location-year">m</td><td style="border-left:none !important;" colspan="3"  id="memory-location-month">onth</td><td colspan="5"  id="memory-location-day">day</td></tr>
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

<table id="extended-date-format-sec-msec">
<tr><td id="extended-date-format-sec-msec-details">

  <table id="extended-date-format">

  <tr class="extended-date-format-memory-location"><td class="nobo">&nbsp;</td><td id="memory-location-49039" colspan="8">49039 ($BF8F)</td><td id="memory-location-49038" colspan="8">49038 ($BF8E)</td></tr>
  <tr><td class="nobo">&nbsp;</td><td class="ml49039">7</td><td class="ml49039">6</td><td class="ml49039">5</td><td class="ml49039">4</td><td class="ml49039">3</td><td class="ml49039">2</td><td class="ml49039">1</td><td class="ml49039">0</td><td class="ml49038">7</td><td class="ml49038">6</td><td class="ml49038">5</td><td class="ml49038">4</td><td class="ml49038">3</td><td class="ml49038">2</td><td class="ml49038">1</td><td class="ml49038">0</td></tr>
  <tr><td class="memory-location-datetime">SEC</td><td class="unused">0</td><td class="unused">0</td><td colspan="6"  id="memory-location-seconds">seconds</td><td colspan="8"  id="memory-location-milliseconds">milliseconds*4</td></tr>
  <tr><td class="nobo">&nbsp;</td><td colspan="16" class="descr">
  <ul>
  <li>seconds = 0-59</li>
  <li>milliseconds = 0-249</li>
  <li>seconds and milliseconds are <strong>NOT</strong> stored in directory entries, <br />only on the global page.</li>
  <li>seconds and milliseconds are <strong>optional</strong> since not all clock drivers support seconds and milliseconds.</li>
  </ul>
  </td></tr>

  <tr><td class="nobo">&nbsp;</td></tr>

  </table>

</td><td class="global-or-directory">&nwarr;<br />Included in the Global page ONLY.<br /><strong>NOT stored in the directory entries.</strong><br />&swarr;</td></tr>

</table>


<div class="vertical-spacer"></div>


<table id="extended-date-format-sec-msec">
  <!-- tr><td id="extended-date-format-sec-msec-title">Stored in the Global page AND Directory Entries</td></tr -->
  <tr><td id="extended-date-format-sec-msec-details">

    <table id="extended-date-format">

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



</td><td class="global-or-directory">&nwarr;<br />Stored in the Global page <strong>AND</strong> Directory Entries<br />&swarr;</td></tr>
</table>



