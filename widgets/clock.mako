<%def name="clock(textcolor, textsize, width, height, left, top)">
    <% 
      import os
      clockId = os.urandom(16).encode('hex')
    %>
    <!-- FIXME: just ask for mono, set mono elsewhere... -->
    <div id="${clockId}" style="
        font-family: Droid Sans Mono; font-size: ${textsize};
        text-align: center; color: ${textcolor}; position: absolute; 
        width: ${width}; height: ${height}; left: ${left}; top: ${top};"
        ></div>
    <script type="text/javascript">
    <!--
        function addClock(element) {
            setInterval(function () { 
                element.innerHTML = (new Date()).toLocaleTimeString("en-GB");
            }, 500);
        }
        addClock(document.getElementById('${clockId}'));
    // -->
    </script>
</%def>
