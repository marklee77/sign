<%inherit file="main.html.mako" />

<%namespace file="message.mako"  import="message"      />
<%namespace file="image.mako"    import="placed_image" />
<%namespace file="schedule.mako" import="schedule"     />
<%namespace file="weather.mako"  import="weather"      />
<%namespace file="rotate.mako"   import="rotate"       />
<%namespace file="clock.mako"    import="clock"        />

<%doc>
<%call 
  expr="message(textcolor='red', textsize='36pt', left='50px', top='180px')">
Department Pizza Lunch Friday!<br />
<div style="font-size: 15pt;">Engineering Computing Students &amp; Faculty
Invited, Bldg 52 FORUM, 12:30pm</div>
</%call>

${placed_image(image='pizza_slice_256.png', 
                     width='200px', left='980px', top='20px')}


                'http://www.cranfield.ac.uk/~toby.breckon/amac_sign/frames.txt',
</%doc>

${schedule(width='880px', height='640px', left='50px', top='260px')}

${weather(width='640px', left='50px', top='900px')}

${rotate(width='840px', height='650px', left='950px', top='235px',
         pagesets=[
                'rotate/armitage/frames.txt',
                'rotate/breckon/frames.txt',
                'rotate/gourma/frames.txt',
                'rotate/jenkins/frames.txt',
                'rotate/stillwell/frames.txt'], 
                seconds='30'
)}


${clock(width='840px', left='950px', top='900px', 
        textsize='36pt', textcolor='#9a9b9c')}