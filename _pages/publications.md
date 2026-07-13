---
layout: page
permalink: /publications/
title: publications
description: Peer-reviewed publications in reverse chronological order. For the most up-to-date list, see my <a href="https://scholar.google.com/citations?user=RnJGH34AAAAJ&hl=en" target="_blank" rel="noopener noreferrer">Google Scholar</a> profile.
nav: true
nav_order: 2
years: [2025, 2024, 2023, 2022, 2021, 2019]
conf_years: [2025, 2023, 2022, 2021, 2018]
---
<!-- _pages/publications.md -->
<div class="publications">

<h2>Journal articles</h2>
{% for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

<h2>Preprints</h2>
{% bibliography -f preprints %}

<h2>Conference proceedings</h2>
{% for y in page.conf_years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f proceedings -q @*[year={{y}}]* %}
{% endfor %}

</div>
