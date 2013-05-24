<%def name="message(width, left, top, textsize, textcolor)">

    <div style="
        position: absolute; width: ${width}; left: ${left}; top: ${top};
        font-size: ${textsize}; color: ${textcolor};"
    />${caller.body()}</div>

</%def>
