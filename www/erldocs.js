ErlDocs = function() {

  var that = this;

  this.search  = $("#search");
  this.results = $("#results");

  that.search.focus( function() {
    if( that.search.val() == "Search" ) {
      that.search.val("");
    }
  });

  that.search.keypress( function(e) {
    setTimeout( function() {
      that.filter(that.search.val());
    },0);
  });

  $(window).bind('resize', function(e) {
    that.window_resize();
  });
  this.window_resize();

  var qs = ErlDocs.parse_query(document.location.href);

  if( qs && qs.search ) {
      this.search.val(qs.search);
      this.filter(qs.search);
  } else {
      this.showModules();
  }

};

ErlDocs.prototype.window_resize = function()
{
    this.results.height($(window).height() - 47);
};

ErlDocs.prototype.showModules = function()
{
  var html = "";
  var preurl = document.location.href.match("index.html") == null ? "../" : "";

  for( var i=0; i < ErlDocs.index.length; i++ ) {
    var item = ErlDocs.index[i];
    if ( item[0] == "mod" ) {
      var url = preurl+item[1]+"/"+item[2].split(":")[0]+".html";
      html += '<li class="'+item[0]+'"><a href="'+url+'">'
        +'<span class="dat">'+item[0]+'</span><span class="name">'+item[2]+"</span>"
        +'<br /><span class="sub">'+item[3]+'</span>'
        +'</a></li>';
    }
  }
  this.results[0].innerHTML = html;
};


ErlDocs.prototype.searchApps = function(str)
{
  var html = "";
  var preurl = document.location.href.match("index.html") == null ? "../" : "";

  for( var i=0, count=0; i < ErlDocs.index.length; i++ ) {
    var item = ErlDocs.index[i];
    if ( item[2].match(str) !== null ) {
      var url = preurl+item[1]+"/"+item[2].split(":")[0]+".html?search="+str;
      html += '<li class="'+item[0]+'"><a href="'+url+'">'
        +'<span class="dat">'+item[0]+'</span><span class="name">'+item[2]+"</span>"
        +'<br /><span class="sub">'+item[3]+'</span>'
        +'</a></li>';

      if( count++ > 30 ) {
        break;
      }
    }
  }
  return html;
};

ErlDocs.prototype.filter = function(str)
{
  if( str != "" ) {
    this.results[0].innerHTML = this.searchApps(str);
  }
};

ErlDocs.parse_query = function(url)
{
    var qs = url.split("?")[1];
    if( typeof qs !== "undefined" ) {
	var arr = qs.split("&"), query = {};
	for( var i = 0; i < arr.length; i++ ) {
	    var tmp = arr[i].split("=");
	    query[tmp[0]] = tmp[1];
	}
	return query;
    }
    return false;
};



ErlDocs.index = index;

var docs = new ErlDocs();



