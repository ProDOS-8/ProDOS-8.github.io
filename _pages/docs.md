---
layout: page
title: Documentation
permalink: /docs/
---

<style type="text/css">
  div.table        { display:table;      width:100%; padding-bottom:10px; }
  div.table-row    { display:table-row;  text-align: left; vertical-align: top; }
  div.table-cell   { display:table-cell; text-align: left; vertical-align: top; }
</style>

<div class="table">
<div class="table-row">
  <div class="table-cell" style="width:355px;"><img src="/pix/appleii_take_apart.png" /></div>
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
