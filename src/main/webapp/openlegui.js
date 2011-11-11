function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

function showSearchResults(term){	
	var path="http://directory.nysenate.gov/legislation/2.0/search.jsonp?term="+term;
	$.get(path,
            function(data) {
            console.log();
            var contents=[];
            var odd;
            
            $.each(data.response.results, function(i,item){
            	if(odd=='odd')
                    odd='';
                else
                    odd='odd';
                contents+='<div id="'+odd+'">'+ 'Name: <a href=view' + item.otype + '.jsp?oid=' + item.oid + '>' + item.oid +'</a> | Type: ' + item.otype +  '</div><br/>';	     
            });

            $('#content').html(contents);
            $('#content').css('display','block');
            $('#contentfilters').css('display','block');
            $('#breadcrumbs').css('display','block');
            //alert(data.response.metadata.totalresults);
            },
            'jsonp');
}

