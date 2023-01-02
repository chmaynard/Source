---
title: Archive
subtitle: Artists, Concerts, and Repertoire
hide: true
order: 2
---

[All Artists](artists)

[Past Concerts](concerts)

[Concert Repertoire](repertoire)

<!-- extract repertoire performance dates -->

<!-- 
{% for concert in site.concerts %}
{% for item in concert.program %}
{{ concert.date | date: "%Y-%m-%d" }} {{ item }}
{% endfor %}
{% endfor %}
 -->

<!-- extract concert dates -->

<!-- 
{% assign all_dates = site.concerts | map: "date" %}

{% for item in all_dates %}
{{ forloop.index }}  {{ item }}
{% endfor %}
 -->
