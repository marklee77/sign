<%def name="message(textcolor, textsize, left, top)">
    <div style="position: absolute; color: ${textcolor}; font-size: ${textsize};
        top: ${top}; left: ${left};"
    />${caller.body()}</div>
</%def>
