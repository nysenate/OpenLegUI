
var results;


//allows you to pull parameters from the url. especially useful for GET requests
function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    /*var attr = window.location.href.split('#')[1].split('&');
    for(a in attr){
    	
    	vars[attr[a].split('=')[0]]=attr[a].split('=')[1]
    }*/
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
            
            //go through each result from the search
            $.each(data.response.results, function(i,item){
            	if(odd=='odd')
                    odd='';
                else
                    odd='odd';
            	if(filtered[0]==null){
            		contents+='<div id="'+odd+'">'+ 'Name: <a href=view' + item.otype + '.jsp?oid=' + item.oid + '>' + item.oid +'</a> | Type: ' + item.otype +  '</div><br/>';}
            	else{
            		if(jQuery.inArray(item.otype,filtered) >= 0)
            		{
            			contents+='<div id="'+odd+'">'+ 'Name: <a href=view' + item.otype + '.jsp?oid=' + item.oid + '>' + item.oid +'</a> | Type: ' + item.otype +  '</div><br/>';
            		}
            	}
            });
            
            if (data.response.metadata.totalresults==0){
            	contents="No results found. Please try searching again.";
            	
            }
            
            else {
            	results = data.response;
            	//if the total results is the same number as the page size, set the pages to 1
            	if (data.response.metadata.totalresults%pageSize==0)
            	{
            		pages=1;
            	}
            
            	//otherwise, perform integer division to find the number of pages'+i+''+i+' needed. pages++ brings the number up to the correct value
            	else {
            		pages = ~~(data.response.metadata.totalresults/pageSize);
            		pages++;
            	}
            
            	//sets up the first page link, which will always display no matter the number of results
            	var links=[];'+i+'
            	urlfilter = '';
            	if(filtered[0]!=null)
            	{
            		urlfilter = '&filters='+filtered;
            	}
            	//links='<br/>Jump to page: <a class="pages" href=#search='+term+'&pageId=1'+urlfilter+' onclick="showSearchResults(1,20,"'+term+'")">1</a> ';
            	fun = 'showSearchResults(1,20,"'+term+'"';
            	links='<br/>Jump to page: <a class="pages" href=#search='+term+'&pageId=1'+urlfilter+' onclick='+fun+'>1</a> ';
            	//for each additional page, create a link for it
            	for (var i=2; i<pages+1; i++){
            		links+='<a class="pages" href=#search='+term+'&pageId='+i+urlfilter+' onclick="showSearchResults('+i+',20,"'+term+'")">'+i+'</a> ';
            	}
            }showSearchResults
            
            //display the contents
            $('#content').html(contents);
            $('#content').append(links);
            $('#content').css('display','block');
            $('#contentfilters').css('display','block');
            $('#breadcrumbs').css('display','block');
            
            },
            'jsonp');
}
