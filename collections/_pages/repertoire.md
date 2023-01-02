---
title: Repertoire
subtitle: Works performed by type and composer
hide: false
order: 3

# TODO: Don't list repertoire if the corresponding concert is hidden or unpublished.
---

<br>

* TOC
{:toc}

{% assign categories = site.data.repertoire | group_by:"category" %}

{% for category in categories %}

### {{ category.name }}

{% include cmm/table-repertoire.html items=category.items %}

{% endfor %}
