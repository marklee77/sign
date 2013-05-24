<%def name="clock(width, left, top, textsize, textcolor)">

    <% 
      import os
      clockId = os.urandom(16).encode('hex')
    %>

    <div id="${clockId}" style="
        position: absolute; width: ${width}; left: ${left}; top: ${top};
        font-family: site-monospace, monospace; font-size: ${textsize};
        text-align: center; color: ${textcolor};"
        ></div>

    <script>
        $(document).ready(function () {
            var element = document.getElementById('${clockId}');
            setInterval(function () { 
                element.innerHTML = (new Date()).toLocaleTimeString();
            }, 500);
        });
    </script>

</%def>
