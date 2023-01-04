---
title: Core Memory Music
subtitle: Great music, memorable performances
---

**Core Memory Music** is a performing arts venture based in southern Rhode Island. We
organize and host concerts in a [modern home](this-new-house.html) near a scenic mill pond.
The performance space is a spacious living room with comfortable seating and a concert grand
piano. Accomplished musicians from around the world come here to perform great music in a
relaxed, informal setting.

<br>

* TOC
{:toc}

## Upcoming Concerts

We welcome reservation requests for these upcoming concerts.

{% assign upcoming = site.concerts | where_exp: "item", "item.capacity" %}

{% include cmm/table-concerts.html concerts=upcoming title=true %}

[Complete Schedule](schedule.html)

## Our Venue

{% include cmm/venue.html %}

{% include cmm/figure.html name="concert-venue.jpg" align="left" %}

## Join us!

* **Attend a concert.** Read about our [next concert]({{ upcoming[0].url}}) and learn how to reserve your seats.

* **Learn more about us.** Listen to an entertaining and informative [radio interview](/media/radio-interview-2) 
with our host. 

* **Perform for us.** Visit our [performers page](performers.html) to learn about performance opportunities.

<!-- 
We live on the traditional lands of the Narragensett peoples, who have stewarded this land
throughout many generations and are its past, present, and future caretakers.
 -->
