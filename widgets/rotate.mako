<%def name="rotate(width, height, left, top, pagesets, seconds)">

    <%doc>
        FIXME:
            handle frame load failure by trying again, not fading in
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

        var pagesets = new Array();
        var loadedPagesetCount = 0;

        % for pageset in pagesets:
            pagesets.push('${pageset}');
        % endfor

        var urls = new Array();
        var lastUrl = ''; 

        var frames = [ $('#${frameIds[0]}'), $('#${frameIds[1]}') ];
        var frameIdx = 0;

        frames[0].hide();
        frames[1].hide();
        frames[0].css('z-index', 0);
        frames[1].css('z-index', 1);

        var rotationStarted = false;
        var bottomFrameUrlSelected = false;
        var bottomFrameReady = false;
        var timeToRotate = false;

        function bottomToFront() {
            var bottomFrame = frames[frameIdx];
            frameIdx = (frameIdx + 1) % 2;
            var topFrame = frames[frameIdx];
            bottomFrame.css('z-index', 1);
            topFrame.css('z-index', 0);
            timeToRotate = false;
            bottomFrameReady = false;
            bottomFrame[0].contentWindow.postMessage('start', '*');
            bottomFrame.fadeIn(1000, function () {
                topFrame.hide();
                loadBottomFrame()
            });
        }

        function doRotate() {
            timeToRotate = true;
            if (bottomFrameReady) {
                bottomToFront();
            }
            setTimeout(doRotate, ${seconds}*1000);
        }

        function frameLoadHandler () {
            if (!bottomFrameUrlSelected) return; // ignore startup events
            bottomFrameReady = true; 
            if (timeToRotate) {
                bottomToFront();
            }
            if (!rotationStarted) {
                rotationStarted = true;
                doRotate();
            }
        }

        frames[0].load(frameLoadHandler)
        frames[1].load(frameLoadHandler)

        function selectBottomFrameUrl() {
            if (!bottomFrameUrlSelected) {
                bottomFrameUrlSelected = true;
                nextUrl = lastUrl;
                while (nextUrl == lastUrl) {
                    nextUrl = urls[Math.floor(Math.random() * urls.length)];
                }
                frames[frameIdx].attr('src', 
                  nextUrl + '?now=' + (new Date()).getTime());
            }
        }

        function pagesetLoadHandler(text) {
            $.merge(urls, $.trim(text).split(/\s+/));
            pagesetLoadCount++;
            if (pagesetLoadCount == pagesets.length) {
                selectBottomFrameUrl();
            } else {
                setTimeout(selectBottomFrameUrl, 5000);
            }
        }

        function loadBottomFrame() {
            pagesetLoadCount = 0;
            bottomFrameUrlSelected = false;
            urls.length = 0;
            for(var i = 0; i < pagesets.length; i++) 
                $.get(pagesets[i], pagesetLoadHandler);
        }

        loadBottomFrame();

    });
    </script>

</%def>
