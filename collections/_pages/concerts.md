---
title: Schedule
subtitle: Complete schedule of upcoming concerts
hide: true
---

<br>

* TOC
{:toc}

<br/>

{% for season in site.data.seasons %}
{% assign min = season.date1 %}
{% assign max = season.date2 %}
{% assign concerts = site.concerts | where_exp:"item", "item.date > site.time
and item.date > min and item.date < max" %}
{% if concerts.size > 0 -%}
### {{ season.title }}
{% include cmm/table-concerts.html concerts=concerts %}
{% endif %}
{% endfor %}
