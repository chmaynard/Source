---
title: Artists
subtitle: Complete list of artists by instrument
hide: false
order: 4
---

<style>

.div-columns {
   columns:     100px 3;
   column-gap:  45px;
   font-size:   14px; 
   height:      2000px; 
}
  
.div-columns p {
   line-height: 8px;   /* within paragraph */
   &:not(:last-child)  {
      margin-bottom: 4px;
   }
}

.div-columns div {
   display: inline-block;
}

</style>

{% assign instruments = site.data.instruments %}
{% assign groups = site.data.artists | group_by:"instrument" %}

<br/>

<div class="div-columns" markdown="1">

{% for instrument in instruments %}
{% assign group_name = instrument.name | downcase %}
{% assign group = groups | find_exp:"item", "item.name == group_name" %}

#### {{ instrument.name }}
{% for artist in group.items %}
{{ artist.name }}
{% endfor %}

{% endfor %}

</div>
