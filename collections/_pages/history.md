---
title: History
subtitle: Complete history of past concerts
hide: false
order: 2
---

<br>

* TOC
{:toc}

{% assign seasons = site.data.seasons | reverse %}

{% for season in seasons %}

{% assign min = season.date1 %}
{% assign max = season.date2 %}
{% assign concerts = site.concerts | where_exp:"item", "item.date > min and item.date < max and item.date < site.time" | reverse %}
{% if concerts.size > 0 %}
### {{ season.title }}
{% include cmm/table-concerts.html concerts=concerts title=false %}
{% endif %}

{% endfor %}
