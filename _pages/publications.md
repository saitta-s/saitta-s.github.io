---
layout: page
permalink: /publications/
title: publications
description: publications in reversed chronological order. 
years: [2023, 2022, 2021, 2019]
years_ : [2022, 2021, 2018]
nav: true
nav_order: 1
---
<!-- _pages/publications.md -->
<div class="publications">


<h2>Articles</h2>

{% for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}


<h2>Conferences</h2>

{% for y in page.years_ %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f proceedings -q @*[year={{y}}]* %}
{% endfor %}

</div>
