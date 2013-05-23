<%def name="rotate(pagesets, seconds, width, height, left, top, id)">

  % for index in range(2):
    <iframe id="rotate_${id}_${index}" class="rotate widget" style="
        position: absolute; border: 0px; overflow: hidden;
        width: ${width}; height: ${height}; top: ${top}; left: ${left};"
        src="" onload="$('this').hide();"></iframe>
  % endfor

  <script type="text/javascript">
  <!--

  var rotateUrls_${id} = new Array();
  <?php 
      $rotateUrls = array(); 
      % for pageset in pagesets:
          $response = file_get_contents("${pageset}");
          $url_list = preg_split('/\s+/', trim($response));
          foreach($url_list as $url) {
              $rotateUrls[] = $url;
          }
      % endfor
      <%doc>
      % for page in pages:
          $rotateUrls[] = "${page}";
      % endfor
      </%doc> 
      foreach($rotateUrls as $url) {
          echo "rotateUrls_${id}.push(\"" . $url . "\")\n";
      }
  ?>
  var rotateUrlIndex_${id} = 
      Math.floor(Math.random() * rotateUrls_${id}.length);
  var rotateFrameIndex_${id} = 0;

  $('#rotate_${id}_' + rotateFrameIndex_${id}).hide();
  $('#rotate_${id}_' + rotateFrameIndex_${id}).attr('src', 
      rotateUrls_${id}[rotateUrlIndex_${id}] + '?now=' + (new Date()).getTime());

  function rotateContent(urls) {
      rotateUrlIndex_${id} = (rotateUrlIndex_${id} + 1 + 
          Math.floor(Math.random() * (urls.length - 1))) % urls.length;
      otherFrameIndex = (rotateFrameIndex_${id} + 1) % 2;
      $('#rotate_${id}_' + otherFrameIndex).css('z-index', 0);
      $('#rotate_${id}_' + rotateFrameIndex_${id}).css('z-index', 1);
      document.getElementById('rotate_${id}_' + 
          rotateFrameIndex_${id}).contentWindow.postMessage('start', '*');
      $('#rotate_${id}_' + rotateFrameIndex_${id}).fadeIn(1000, function () {
          $('#rotate_${id}_' + otherFrameIndex).hide();
          $('#rotate_${id}_' + otherFrameIndex).attr('src', 
            urls[rotateUrlIndex_${id}] + '?now=' + (new Date()).getTime());
          rotateFrameIndex_${id} = otherFrameIndex;
      });
  } 

  setTimeout(function () {
      rotateContent(rotateUrls_${id});
      setInterval(function () { rotateContent(rotateUrls_${id}); }, 
                  ${seconds} * 1000);
  } , 2000);

  //-->
  </script>
</%def>
