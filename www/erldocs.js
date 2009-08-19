ErlDocs = function() {

  var that = this;

  this.search   = $("#search");
  this.results  = $("#results");
  this.selected = null;
  this.resultsCount = 0;

  that.search.focus( function() {
      that.search.val("");
  });

  that.search.keydown( function(e) {
    setTimeout( function() {
      that.keypress(e);
    },0);
  });

  $(window).bind('resize', function(e) {
    that.window_resize();
  });
  this.window_resize();

  var qs = ErlDocs.parse_query(document.location.href);

  if( qs && qs.search ) {
      var search_val = decodeURIComponent(qs.search.replace(/\+/g,  " "));
      this.search.val(search_val);
      this.filter(search_val);
  } else {
      this.showModules();
  }

  if( qs && qs.i ) {
      this.setSelected(parseInt(qs.i, 10));
  }

  this.search.focus();
};

ErlDocs.prototype.setSelected = function(x, down)
{
    down = (typeof down == "undefined") ? false : down;

    if( x >= 0 && x < this.resultsCount ) {
	if( this.selected != null ) {
	    this.results.children("li").eq(this.selected).removeClass("selected");
	}
	this.selected = x;
	var selection = this.results.children("li").eq(x).addClass("selected");
	selection[0].scrollIntoView(down);
    }
};

ErlDocs.prototype.keypress = function(e)
{
    if( e.keyCode == 40 ) {        //DOWN
	this.setSelected(this.selected + 1, false);
    } else if( e.keyCode == 38 ) {    //UP
	this.setSelected(this.selected - 1, false);
    } else if ( e.keyCode == 13 ) { //ENTER
	document.location.href = this.results.children("li:eq("+this.selected+") a").attr("href");
    } else {
	this.filter(this.search.val());
    }
};

ErlDocs.prototype.window_resize = function()
{
    this.results.height($(window).height() - 47);
};

ErlDocs.prototype.showModules = function()
{
  var html = "";
  var preurl = !ErlDocs.is_home() ? "../" : "";

  for( var i=0, count=0; i < ErlDocs.index.length; i++ ) {
    var item = ErlDocs.index[i];
    if ( item[0] == "mod" ) {
      var url = preurl+item[1]+"/"+item[2].split(":")[0]+".html?i="+i;
      html += '<li class="'+item[0]+'"><a href="'+url+'">'
        +'<span class="dat">'+item[0]+'</span><span class="name">'+item[2]+"</span>"
        +'<br /><span class="sub">'+item[3]+'</span>'
        +'</a></li>';
      count++;
    }
  }
  this.results[0].innerHTML = html;
  this.resultsCount = count;
  this.setSelected(0);
};

ErlDocs.prototype.searchApps = function(str)
{
  var html = "";
  var preurl = !ErlDocs.is_home() ? "../" : "";
  var terms = str.split(" ");

  for( var i=0, count=0; i < ErlDocs.index.length; i++ ) {
    var item = ErlDocs.index[i];
    if ( ErlDocs.match(item[2], terms) ) {

	var hash = (item[0] == "fun") ? "#"+item[2].split(":")[1] : "";
	
	var url = preurl+item[1]+"/"+item[2].split(":")[0]+".html?search="+str+"&i="+count + hash;
	html += '<li class="'+item[0]+'"><a href="'+url+'">'
	    +'<span class="dat">'+item[0]+'</span><span class="name">'+item[2]+"</span>"
	    +'<br /><span class="sub">'+item[3]+'</span>'
	    +'</a></li>';
	
      if( count++ > 30 ) {
        break;
      }
    }
  }
  this.resultsCount = count;
  return html;
};

ErlDocs.prototype.filter = function(str)
{
  if( str != "" ) {
    this.results[0].innerHTML = this.searchApps(str);
    this.setSelected(0);
  } else {
      this.showModules();
  }
};

ErlDocs.match = function(str, terms)
{
    for( var i = 0; i < terms.length; i++ ) {
	if( str.match(new RegExp(terms[i], "i")) == null ) {
	    return false;
	}
    }
    return true;
};
   
// This is a nasty check
ErlDocs.is_home = function() 
{
    return document.title == "index - erldocs.com";
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



