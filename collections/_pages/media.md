--- 
title: Media  
subtitle: Audio and Video Resources
hide: false
order: 6
---

Each summer, we take a short break from presenting live concerts. During the break in 2021,
we decided to share audio and video performances of some of our favorite music. If this
feature proves to be popular, we'll continue it on an occasional basis throughout the year.

{% assign pages = site.media | where_exp: "item", "item.date < site.time" | sort: "date" | reverse %}
{% include cmm/table-page.html pages=pages %}
