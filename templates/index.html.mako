<%inherit file="main.html.mako" />

<%namespace file="message.mako"  import="message"      />
<%namespace file="image.mako"    import="placed_image" />
<%namespace file="schedule.mako" import="schedule"     />
<%namespace file="weather.mako"  import="weather"      />
<%namespace file="rotate.mako"   import="rotate"       />
<%namespace file="clock.mako"    import="clock"        />

<%call 
  expr="message(width='880px', left='50px', top='180px', textsize='36pt', textcolor='red')">
Pizza Lunch Friday!<br />
<div style="font-size: 15pt;">CSTE Students &amp; Faculty Invited, 
Bldg 52 FORUM, 4:30pm</div>
</%call>

${placed_image(width='200px', left='900px', top='20px', 
               image='pizza_slice_256.png')}


<%doc>'6ciph13spq4rmq28shlai1s83s@group.calendar.google.com'];</%doc>
${schedule(width='880px', height='640px', left='50px', top='260px',
           apiKey=meta['google_apikey'], calIdList=[ 
             'amac.cranfield@googlemail.com',
             'p2t1d9qvbg69lq59klqng5dc6s@group.calendar.google.com',
             'ls6tjllu1ko99fl9j3vm1kpmio@group.calendar.google.com',
             'e85187a6fn6jc818bp9mphgpmk@group.calendar.google.com',
             'hhn8pbbqdhur0r7pq1vh1m31m8@group.calendar.google.com'],
           ignoreTitleList=[ 'seminar slot', 'to be decided', 'tbd', 
                             'assignment work' ],
           maxDays=14, maxResults=20, 
           dataRefreshSeconds=600, layoutRefreshSeconds=10)}

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
