function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

function getSearchResults(term){	
	var path="http://directory.nysenate.gov/legislation/2.0/search.jsonp?term="+term;	
	$.get(path,
			function(data) {
				alert("pulled json file");

            },
           	'jsonp');

}

