<!DOCTYPE html>
<html lang="en">

  <head>
    <meta charset="utf-8" />
    <title>#TITLE# - erldocs.com (Erlang Documentation)</title>
    <link type="text/css" rel="stylesheet" href="#BASE#erldocs.css" />
  </head>
  
  <body>

    <div id="sidebar">
      <input type="text" value="Loading..." id="search" autocomplete="off" />
      <ul id="results"> </ul>
    </div>

    <div id="content">
      #CONTENT#
    </div>

    <script type="text/javascript" src="#BASE#jquery.js"></script>
    <script type="text/javascript" src="#BASE#erldocs_index.js"></script>
    <script type="text/javascript" src="#BASE#erldocs.js"></script>

    <script type="text/javascript">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-XXXXX-X']);
      _gaq.push(['_trackPageview']);
      
      (function() {
        var ga = document.createElement('script');
        ga.src = ('https:' == document.location.protocol ?
          'https://ssl' : 'http://www') +
          '.google-analytics.com/ga.js';
        ga.setAttribute('async', 'true');
        document.documentElement.firstChild.appendChild(ga);
      })();
    </script>
  </body>
</html>

