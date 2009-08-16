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

};

ErlDocs.prototype.searchApps = function(str)
{
  var html = "";
  var preurl = document.location.href.match("index.html") == null ? "../" : "";

  for( var i=0, count=0; i < ErlDocs.index.length; i++ ) {
    var item = ErlDocs.index[i];
    if ( item[2].match(str) !== null ) {
      var url = preurl+item[1]+"/"+item[2].split(":")[0]+".html";
      html += '<li class="'+item[0]+'"><a href="'+url+'">'
        +'<span class="dat">'+item[0]+'</span>'+item[2]
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

ErlDocs.index = index;

var docs = new ErlDocs();



