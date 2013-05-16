<%inherit file="main.html.mako" />
<%namespace name="message"  file="message.mako"  />
<%namespace name="image"    file="image.mako"    />
<%namespace name="schedule" file="schedule.mako" />
<%namespace name="weather"  file="weather.mako"  />
<%namespace name="rotate"   file="rotate.mako"   />
<%namespace name="clock"    file="clock.mako"    />

<%doc>
<%message:message textcolor="red" textsize="36pt" left="50px" top="180px">
Department Pizza Lunch Friday!<br />
<div style="font-size: 15pt;">Engineering Computing Students &amp; Faculty
Invited, Bldg 52 FORUM, 12:30pm</div>
</%message:message>
</%doc>

<%doc>
${image.placed_image(image='pizza_slice_256.png', 
                     width='200px', left='980px', top='20px')}
</%doc>

${schedule.schedule(width='880px', height='640px', left='50px', top='260px')}

${weather.weather(left='50px', top='900px')}

${rotate.rotate(id='demo', pagesets=[
                'rotate/gourma/frames.txt',
                'rotate/jenkins/frames.txt',
                'http://www.cranfield.ac.uk/~toby.breckon/amac_sign/frames.txt',
                'rotate/armitage/frames.txt'], 
                seconds='30',
                width='840px', height='650px', left='950px', top='235px')}


${clock.clock(textcolor='blue', textsize='48pt', 
              width='840px', height='400px', left='950px', top='900px')}