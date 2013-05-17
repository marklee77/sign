<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <style type="text/css">
      body {
        background: white url(img/engcomp_background.svg) left top no-repeat;
        font-family: DefusedLight, sans-serif; 
        width: 1920px;
        height: 1080px;
        overflow: hidden;
        font-size: 18pt;
        margin: 50px;
      }
      body header h1 {
        color: white;
        font-size: 60pt;
        margin: 0px;
        padding: 0px;
      }
      body header h2 {
        font-size: 30pt;
        margin: 0px;
        padding: 0px;
      }
      body header #cranfield_logo {
        width: 360px;
        position: absolute;
        top: 50px; right: 50px;
      }
      body footer {
        color: #9a9b9c;
        font-size: 18pt;
        position: absolute;
        bottom: 50px; right: 50px;
      }
    </style>
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script> 
  </head>
  <body>
     <header>
       <h1>Engineering Computing</h2>
       <h2>Applied Mathematics &amp; Computing Group</h2> 
       <img id="cranfield_logo" src="img/cranfield_logo.svg" 
            alt="Cranfield University" />
     </header>
     ${next.body()}
     <footer>http://www.cranfield.ac.uk/soe/amac/</footer>
  </body>
</html>
