<%@ page language="java" import="java.util.*, java.text.*,java.io.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>

<script type="text/javascript">
var filtered=[];
var popular=['Puppy bill', 'Meeting about puppy', 'Transcript of barking puppy', 'A puppy taking action', 'People voting on puppies'];
var newstuff=['This happened just now','This happened after that','Wow this happened today','Some other things happened recently too','Still recent enough to show up'];

function init(){
	
	$("#searchzone").css("left", ( $(window).width() - $("#searchzone").width()) / 2+$(window).scrollLeft() + "px");
	$(window).bind('resize', function(){$("#searchzone").css("left", ( $(window).width() - $("#searchzone").width()) / 2+$(window).scrollLeft() + "px");});
	
	announcements('popular');
}

function filter(choice){
	//filtered+=[choice];
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
			$("#filters input[value*='"+choice+"']").attr('id','clicked');
		else
			$("#filters input[value*='"+choice+"']").attr('id','unclicked');
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

function gosearch(form){
	
	//alert($("#searchzone input[id*='search']").val());
	//var url='http://open.nysenate.gov/legislation/api/json/search/'+$("#search").val()+'/1/20?callback=?';
	//var url='http://open.nysenate.gov/legislation/2.0/search.json?term='+$("#search").val()'&callback=stuff';
	$("#filters.second").css('display','none');

	//var patt=new RegExp('(<br>)?','');
	//$("#searchzone").html($("#searchzone").html().replace(patt,""));

	$(window).unbind('resize');
	$('#searchzone').animate({top: '-10px',width: '100%', height:'70px', left: '-20px'},200,function(){
		var term = form.search.value;
		var path="http://directory.nysenate.gov/legislation/2.0/search.jsonp?term="+term;
		//$.get('http://directory.nysenate.gov/legislation/2.0/search.jsonp?term=dog',
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
		
        
			/*$.getJSON(url, function(data) { 
				alert("hi");
			});*/
			
			/*
			var everything = popular.concat(newstuff);
			odd='odd';
			contents=[];
			for (article in everything)
			{	
				if(odd=='odd')
					odd='';
				else
					odd='odd';
				contents+='<div id="'+odd+'">'+everything[article]+'</div><br/>';
			}
			$('#content').html(contents);
			$('#content').css('display','block');
			$('#contentfilters').css('display','block');
			$('#breadcrumbs').css('display','block');
			*/
			
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
	A link
</div>
<div id="searchzone">
	<img src="http://m.nysenate.gov/legislation/img/openleglogo.gif"/>
    <div id="filters">
    	<input type="button" value="Bills" onclick="filter('Bills')" id="unclicked"/>
    	<input type="button" value="Meetings" onclick="filter('Meetings')" id="unclicked"/>
    	<input type="button" value="Transcripts" onclick="filter('Transcripts')" id="unclicked"/>
        <input type="button" value="Actions" onclick="filter('Actions')" id="unclicked"/>
        <input type="button" value="Votes" onclick="filter('Votes')" id="unclicked"/>
    
	<form name="search" action="" method="GET">
		<input type="text" name="search" id="search" value="Start searching here!" style="color:black;"/> 
        <input type="button" value="Go" onclick="gosearch(this.form)" id="go"/>
	</form></div>
    <div id="breadcrumbs"><a href="">Home</a> Search</div>
    <div id="filters" class="second">
    	<input type="button" value="Popular" onclick="filter('Popular')" id="clicked"/>
    	<input type="button" value="New" onclick="filter('New')" id="unclicked"/>
        <div id="announcements">
        </div>
    </div>
</div>
<div id="contentfilters">
	Order By:<br/>
	<input type="button" value="Best Fit" onclick="order('Best Fit')" id="unclicked"/>
    <input type="button" value="Recent Updates" onclick="order('Recent Updates')" id="unclicked"/>
    <input type="button" value="Oldest Updates" onclick="order('Oldest Updates')" id="unclicked"/>
    <input type="button" value="Committee" onclick="order('Committee')" id="unclicked"/>
</div>
<div id="content">
	
</div>
</body>
</html>
