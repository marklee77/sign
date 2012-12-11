---
bgimage: engcomp.png
---
{%- from "message.j2"  import message -%}
{%- from "schedule.j2" import schedule -%}
{%- from "image.j2"    import placed_image -%}
{%- from "rotate.j2"   import rotate -%}
{%- from "clock.j2"    import clock -%}
{%- from "weather.j2"  import weather -%}

{%- call message(textcolor='red', textsize='36pt', left='50px', top='180px') %}
{% endcall -%}

{%- call schedule(width='880px', height='820px', left='50px', top='260px') %}
{% endcall -%}

{#
{%- call placed_image(image='B52_ground_floor.png', width='840px', left='950px', top='235px') %}
  Building 52, Ground Floor
{% endcall -%}
#}

{%- call rotate(framesets=[ 
    'rotate/gourma/frames.txt', 
    'rotate/jenkins/frames.txt',
    'http://www.cranfield.ac.uk/~toby.breckon/amac_sign/frames.txt' ], 
    seconds='30', width='840px', height='650px', left='950px', top='235px') %}
{% endcall -%}

{%- call clock(textcolor='blue', textsize='48pt', width='840px', height='400px', left='950px', top='900px') %}
{% endcall -%}

{%- call weather(left='50px', top='900px') %}
{% endcall -%}
