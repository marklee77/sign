<%def name="clock(textcolor, textsize, width, height, left, top)">
    <div id="clock" style="position: absolute; text-align: center; 
        color: ${textcolor}; 
        font-family: Droid Sans Mono; font-size: ${textsize}; 
        width: ${width}; height: ${height}; left: ${left}; top: ${top};"></div>
    <script type="text/javascript">
    <!--
        function zPad(i) { return (i < 10) ? "0" + i : i; }
        function startTime() {
            var now = new Date();
            document.getElementById('clock').innerHTML = zPad(now.getHours()) +
                ":" + zPad(now.getMinutes()) + ":" + zPad(now.getSeconds());
        }
        setInterval(startTime, 500);
    // -->
    </script>
</%def>
