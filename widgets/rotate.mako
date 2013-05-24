<%def name="rotate(width, height, left, top, pagesets, seconds)">

    <%doc>
        FIXME:
            add frames reload while keeping no-repeat guarnantee
            handle frame load failure by trying again, not fading in
            frameLoadStarted, bottomFrameReady, timeToRotate
    </%doc>

    <% 
        import os
        frameIds = [] 
    %>

    % for index in range(2):
        <%
            frameId = os.urandom(16).encode('hex')
            frameIds.append(frameId);
        %>
        <iframe id="${frameId}" style="position: absolute; 
        width: ${width}; height: ${height}; left: ${left}; top: ${top}; 
        border: 0px; overflow: hidden;" src=""></iframe>
    % endfor

    <script>
    $(document).ready(function() {

        var rotationStarted = false;
        var frames = [$('#${frameIds[0]}'), $('#${frameIds[1]}')];
        var frameIdx = 0;
        var urls = new Array();
        var urlIdx;

        frames[0].hide();
        frames[1].hide();
        frames[0].css('z-index', 0);
        frames[1].css('z-index', 1);

        function rotate() {
            var nextTopFrame = frames[frameIdx];
            frameIdx = (frameIdx + 1) % 2;
            var nextBottomFrame = frames[frameIdx];
            nextTopFrame.css('z-index', 1);
            nextBottomFrame.css('z-index', 0);
            urlIdx = (urlIdx + 1 + 
                Math.floor(Math.random() * (urls.length - 1))) % urls.length;
            var nextUrl = urls[urlIdx] + '?now=' + (new Date()).getTime();
            nextTopFrame[0].contentWindow.postMessage('start', '*');
            nextTopFrame.fadeIn(1000, function () {
                nextBottomFrame.hide();
                nextBottomFrame.attr('src', nextUrl);
            });
        }

        function addUrlsAndStart(text) {
            $.merge(urls, $.trim(text).split(/\s+/));
            setTimeout(function () {
                if (urls.length > 0 && ! rotationStarted) {
                    var nextTopFrame = frames[frameIdx];
                    urlIdx = Math.floor(Math.random() * urls.length);
                    rotationStarted = true;
                    nextTopFrame.attr('src', urls[urlIdx]);
                    nextTopFrame.load(function () {
                        rotate();
                        setInterval(rotate, ${seconds}*1000);
                        nextTopFrame.off('load');
                    });
                }
            }, 500);
        }

        % for pageset in pagesets:
            $.get('${pageset}', addUrlsAndStart);
        % endfor

    });
    </script>

</%def>
