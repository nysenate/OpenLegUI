
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
    }
    */
    return vars;
}

function breakUpText(text){
	var textArray=[];
    var index=0;
    var beginning;
    var end;
    var numBreaks;
    var tempString;
    var processedText;
    beginning=0;

    //for the first block, select only the first double line break since there won't be one at the beginning of the text
    end=text.indexOf("\n\n", 0);
    //get the string text and push it to the array
    tempString=text.substring(beginning, end);
    textArray.push(tempString);

    while (beginning!=-1 || end!=-1){
          //set beginning to the previous end
          beginning=end;
          //the new end is the next double line break
          end=text.indexOf("\n\n", beginning+1);
          //if there isn't another double line break, it has reached the end of the text
          if (end==-1){
              end=text.length;
          }

          //pull out the string between beginning and end
          tempString=text.substring(beginning, end);

          if (tempString==""){
              break;
          }
          //push the text to the array
          textArray.push(tempString);
          
          if (end==-1 || beginning==-1){
               break;
          }
    }     

    var currentText="";
    var breakIndex=0;
    var firstSegment="";
    var secondSegment="";
    //iterate through the text array
    for (var i = 0; i < textArray.length; i++) {
        breakIndex=0;
        currentText="";
        processedText="";
        currentText=textArray[i];
        //get the number of line breaks within the text
        if (currentText.match(/\n/gi)!=null){
        	numBreaks=currentText.match(/\n/gi).length-1;
        }
        //if the number is greater than 10, reformat it so it is now within a div
        if (numBreaks>10){
               currentText=currentText.substring(3);
               for (var j=0; j<5; j++){
                   breakIndex=currentText.indexOf("\n", breakIndex+1);
               }
               firstSegment=currentText.substring(0, breakIndex);
               secondSegment=currentText.substring(breakIndex);
               processedText+=firstSegment + '...';
               //processedText+='<br/><br/><div class="trigger"><a href="#">Expand text block</a></div>';
               processedText+='<div class="trigger"><a href="#">Expand text block</a></div>';
              
               //processedText+='<div class="toggle">' + currentText + '</div>';
               processedText+='<div class="toggle">' + secondSegment + '</div>';
               currentText=processedText;      
        }
        textArray[i]=currentText;    
    }
    
    text="";
    
    //iterate through the array and build the string with all of the full text
    for (var i = 0; i < textArray.length; i++) {
         text+=textArray[i];
    }
    
    //put the fulltext in the fulltext div and add it to the navigation bar
    //var fulltext='<h2>Full Text</h2>';
    //fulltext+='<div class="hr"></div>';
    text=text.replace(/\n/gi, "<br/>");
	return text;
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
