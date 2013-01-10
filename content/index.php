---
background: white url(img/engcomp.png) no-repeat left top
---
{%- from "message.j2"  import message -%}
{%- from "schedule.j2" import schedule -%}
{%- from "image.j2"    import placed_image -%}
{%- from "rotate.j2"   import rotate -%}
{%- from "clock.j2"    import clock -%}
{%- from "weather.j2"  import weather -%}

{%- call message(textcolor='red', textsize='36pt', left='50px', top='180px') %}
Department Pizza Lunch Friday!<br />
<div style="font-size: 15pt;">Engineering Computing Students &amp; Faculty Invited, Bldg 52 FORUM, 12:30pm</div>
{% endcall -%}

{%- call placed_image(image='pizza_slice_256.png', width='200px', left='980px', top='20px') %}
{% endcall -%}

{%- call rotate(name='sched', pages=['schedule.php'], allowrepeat=true, seconds=60, 
                width='880px', height='820px', left='50px', top='260px') %}
{% endcall -%}

{%- call rotate(name='demo',
    pagesets=[ 'rotate/gourma/frames.txt', 
               'rotate/jenkins/frames.txt', 
               'http://www.cranfield.ac.uk/~toby.breckon/amac_sign/frames.txt' 
    ], seconds='30', 
    width='840px', height='650px', left='950px', top='235px') %}
{% endcall -%}

{%- call clock(textcolor='blue', textsize='48pt', 
               width='840px', height='400px', left='950px', top='900px') %}
{% endcall -%}

{%- call weather(left='50px', top='900px') %}
{% endcall -%}
