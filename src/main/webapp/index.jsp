<%@ page language="java" import="java.util.*, java.text.*,java.io.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
<script type="text/javascript" src="openlegui.js"></script>

<script type="text/javascript">
//set up the necessarey variables
var filtered=[];
var popular=['Puppy bill', 'Meeting about puppy', 'Transcript of barking puppy', 'A puppy taking action', 'People voting on puppies'];
var newstuff=['This happened just now','This happened after that','Wow this happened today','Some other things happened recently too','Still recent enough to show up'];
var searchTerm = getUrlVars()["search"];
var pageId = getUrlVars()["pageId"];
//if there was no pageId parameter, set it to 1
if (pageId==undefined){
	pageId=1;
}

//var filters = getUrlVars()["filters"].split(',');
var filters = getUrlVars()["filters"].split(',');
if(filters!=undefined){
	filtered = filters;
	for(f in filters)
	{
		var temp = filters[f].charAt(0).toUpperCase() + filters[f].slice(1)+"s";
		filter(temp);
	}
}


function init(){
	
	$("#searchzone").css("left", ( $(window).width() - $("#searchzone").width()) / 2+$(window).scrollLeft() + "px");
	$(window).bind('resize', function(){$("#searchzone").css("left", ( $(window).width() - $("#searchzone").width()) / 2+$(window).scrollLeft() + "px");});
	
	announcements('popular');

	//if a search term was defined, perform the search
    if (searchTerm!=undefined){
    	   gosearch();
    }
}

function filter(choice){
	
	if($("#filters input[value*='"+choice+"']").val()=="Popular"||$("#filters input[value*='"+choice+"']").val()=="New")
	{
		if($("#filters input[value*='"+choice+"']").attr('id')=='unclicked')
		{
			$("#filters input[value*='"+choice+"']").attr('id','clicked');
			if($("#filters input[value*='"+choice+"']").val()=="Popular")
			{
				$("#filters input[value*='New']").attr('id','unclicked');
				announcements('popular');
			}
			else
			{
				$("#filters input[value*='Popular']").attr('id','unclicked');
				announcements('new');
			}
		}
	}
	
	else
	{
		if($("#filters input[value*='"+choice+"']").attr('id')=='unclicked')
		{
			$("#filters input[value*='"+choice+"']").attr('id','clicked');
		    filtered.push(choice.substring(0, choice.length-1).toLowerCase());
		    
		    if(results!=null){
		    	  attr = getUrlVars();
		    	  var newurl = 'search='+attr['search']+'&filters='+filtered;
		    	  parent.location.hash=newurl; 

		    	  $('.pages').each(function(index) {
		    		    $(this).attr('href',$(this).attr('href')+'&filters='+filtered);
		    	  });

		    	  gosearch();
		    }
		}
		else
		{
			$("#filters input[value*='"+choice+"']").attr('id','unclicked');
			
		    if(filtered.indexOf(choice.substring(0, choice.length-1).toLowerCase())!=-1)
		    {
			    filtered.splice(filtered.indexOf(choice.substring(0, choice.length-1).toLowerCase()), 1);
		         if(results!=null){
	                  attr = getUrlVars();
	                  if(filtered[0]!=null)
	                  {
	                	   var newurl = 'search='+$('#search').val()+'&filters='+filtered;
                         $('.pages').each(function(index) {
                        	    oldlink = $(this).attr('href');
                        	    oldlink = oldlink.split('&');
                                oldlink = $(this).attr('href');
                                oldlink = oldlink.split('&');
                                oldlink = oldlink.slice(0,2).join('&');
                                $(this).attr('href', oldlink);
                                $(this).attr('href',oldlink+'&filters='+filtered);
                          });
	                  }
	                  else
	                  {
	                	  var newurl = 'search='+$('#search').val();
                         $('.pages').each(function(index) {
                                oldlink = $(this).attr('href');
                                oldlink = oldlink.split('&');
                                oldlink = oldlink.slice(0,2).join('&');
                                $(this).attr('href', oldlink);
                          });
	                  }
	                  parent.location.hash=newurl;
	                  gosearch();
	            }
		    }
		}
		
	}
}

function announcements(filter){
	var contents = '';
	var odd='odd';
	if(filter=="popular")
	{
		for(article in popular)
		{
			if(odd=='odd')
				odd='';
			else
				odd='odd';
			contents+='<div id="'+odd+'">'+popular[article]+'</div><br/>';
		}	
	}
	else
	{
		for(article in newstuff)
		{
			if(odd=='odd')
				odd='';
			else
				odd='odd';
			contents+='<div id="'+odd+'">'+newstuff[article]+'</div><br/>';
		}	
	}
	$('#announcements').html(contents);
}


function gosearch(){	
	$("#filters.second").css('display','none');
	$(window).unbind('resize');
	$('#searchzone').animate({top: '-10px',width: '100%', height:'70px', left: '-20px'},200,function(){
	var newurl = 'search='+$('#search').val();
	if(filtered[0]!=null)
	{
	    newurl+='&filters='+filtered;
	}
	parent.location.hash=newurl;
    //showSearchResults(pageId, 20, searchTerm);
	if (pageId==undefined){
	    pageId=1;
	}
	showSearchResults(pageId, 20, $('#search').val());
    
});
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//                     For dynamic object resizing and page centering
	//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	$("#filters").css({position:'absolute',left:( $(window).width() - $("#filters").width()) / 2+$(window).scrollLeft() + "px"});
	$("#breadcrumbs").css({position:'absolute',left:parseInt($("#filters").css('left'))});
	if($(window).width()/2<($("#searchzone #filters").width()/2)+$("#searchzone img").width())
		$("#searchzone img").css({display:'none'});
	else
		$("#searchzone img").css({position:'absolute',left:parseInt($("#filters").css('left').replace('px','')-$("#searchzone img").width())+"px",top:'50px'});
	
	$(window).bind('resize', function(){
		$("#filters").css("left", ( $(window).width() - $("#filters").width()) / 2+$(window).scrollLeft() + "px");
		$("#breadcrumbs").css({position:'absolute',left:parseInt($("#filters").css('left'))});
		if($(window).width()/2<($("#searchzone #filters").width()/2)+$("#searchzone img").width())
			$("#searchzone img").css({display:'none'});
		else
			$("#searchzone img").css({display:'block',position:'absolute',left:parseInt($("#filters").css('left').replace('px','')-$("#searchzone img").width())+"px",top:'50px'});	
	});
}

function order(choice){
	if($("#contentfilters input[value*='"+choice+"']").attr('id')=='unclicked')
	{
		$('#contentfilters').find('input').attr('id','unclicked');		
		$("#contentfilters input[value*='"+choice+"']").attr('id','clicked');
	}
}
</script>
<title>OpenLegislation</title>
<link href="openstyles.css" rel="stylesheet" type="text/css" />
</head>

<body onload="init()">
<div id="navzone">
	NYS Senate Links
</div>
<div id="searchzone">
	<img src="http://m.nysenate.gov/legislation/img/openleglogo.gif"/>
    <div id="filters">
    	<input type="button" value="Bills" onclick="filter('Bills')" id="unclicked"/>
    	<input type="button" value="Meetings" onclick="filter('Meetings')" id="unclicked"/>
    	<input type="button" value="Transcripts" onclick="filter('Transcripts')" id="unclicked"/>
        <input type="button" value="Actions" onclick="filter('Actions')" id="unclicked"/>
        <input type="button" value="Votes" onclick="filter('Votes')" id="unclicked"/>
     
	
		<input type="text" name="search" id="search" value="Start searching here!" style="color:black;"/> 
        <input type="button" value="Go" onclick="gosearch()" id="go"/>
	
	
	<!-- 
	<form name="input" action="" method="get">
    <input type="text" name="search" id="search" value="Start searching here!" style="color:black;"/> 
    <input type="submit" value="Search" id="go"/>
    </form> -->
    
	</div>
    <div id="breadcrumbs"><a href="index.jsp">Home</a> Search</div>
    <div id="filters" class="second">
    	<input type="button" value="Popular" onclick="filter('Popular')" id="clicked"/>
    	<input type="button" value="New" onclick="filter('New')" id="unclicked"/>
        <div id="announcements">
        </div>
    </div>
</div>
<div id="contentfilters">
	Order By:<br/>
	<input type="button" value="None" onclick="order('None')" id="clicked"/>
	<input type="button" value="Best Fit" onclick="order('Best Fit')" id="unclicked"/>
    <input type="button" value="Recent Updates" onclick="order('Recent Updates')" id="unclicked"/>
    <input type="button" value="Oldest Updates" onclick="order('Oldest Updates')" id="unclicked"/>
    <input type="button" value="Committee" onclick="order('Committee')" id="unclicked"/> 
</div>
<div id="content">
	
</div>
</body>
</html>
