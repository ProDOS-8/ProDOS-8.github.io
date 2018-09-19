---
layout: page
title: Documentation
permalink: /docs/
---


<div class="table">
<div class="table-row">
  <div class="table-cell" style="width:355px;">
    <img src="/pix/appleii_take_apart3.svg"
         width="352"
         height="478"
         alt="Apple II parts"
         title="Apple II parts"
         onerror="this.onerror=null; this.src='/pix/appleii_take_apart3.png'" />
  </div>
<div class="table-cell">

{% for nav in site.data.navigation %}
  {% if nav.title == "Docs" %}
    {% for doc in nav.subcategories %}
      <li><a href="{{ doc.subhref }}">{{ doc.subtitle }}</a></li>
    {% endfor %}
  {% endif %}
{% endfor %}

</div>
</div>
