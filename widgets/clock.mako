<%def name="clock(width, left, top, textsize, textcolor)">
    <% 
      import os
      clockId = os.urandom(16).encode('hex')
    %>
    <!-- FIXME: just ask for mono, set mono elsewhere... -->
    <div id="${clockId}" style="
        position: absolute; width: ${width}; left: ${left}; top: ${top};
        font-family: Droid Sans Mono; font-size: ${textsize};
        text-align: center; color: ${textcolor};"
        ></div>
    <script>
        (function () {
            var element = document.getElementById('${clockId}');
            setInterval(function () { 
                element.innerHTML = (new Date()).toLocaleTimeString();
            }, 500);
        })();
    </script>
</%def>
