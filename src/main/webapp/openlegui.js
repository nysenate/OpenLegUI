//allows you to pull parameters from the url. especially useful for GET requests
function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

//performs a search according to the provided search term. pulls the results and places them in the page
function showSearchResults(pageId, pageSize, term){	
	var path='http://directory.nysenate.gov/legislation/2.0/search.jsonp?pageIdx=' + pageId + '&pageSize=' + pageSize + '&term=' + term;
	var pages=0;
	$.get(path,
            function(data) {
            console.log();
            var contents=[];
            var odd;
            //pages=data.response.metadata.totalresults;
            
            $.each(data.response.results, function(i,item){
            	if(odd=='odd')
                    odd='';
                else
                    odd='odd';
                contents+='<div id="'+odd+'">'+ 'Name: <a href=view' + item.otype + '.jsp?oid=' + item.oid + '>' + item.oid +'</a> | Type: ' + item.otype +  '</div><br/>';	     
            });
            
            if (data.response.metadata.totalresults%pageSize==0)
            {
            	pages=1;
            }
            else {
            	pages = ~~(data.response.metadata.totalresults/pageSize);
            	pages++;
            }
            //alert(pages);
            
            
            var links=[];
            links='<br/>Jump to page: <a href=?search='+term+'&pageId=1>1</a> ';
            
            for (var i=2; i<pages+1; i++){
            	links+='<a href=?search='+term+'&pageId='+i+'>'+i+'</a> ';
            }
            
            $('#content').html(contents);
            $('#content').append(links);
            $('#content').css('display','block');
            $('#contentfilters').css('display','block');
            $('#breadcrumbs').css('display','block');
           // alert();
            },
            'jsonp');
}

