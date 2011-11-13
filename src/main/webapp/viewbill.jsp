<%@ page language="java" import="java.util.*, java.text.*,java.io.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
<script type="text/javascript" src="openlegui.js"></script>

<title>OpenLegislation</title>
<link href="content.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">
function init(){
	$('#searchzone').animate({top: '-10px',width: '100%', height:'70px', left: '-20px'},200,function(){
	            
	});

	//get the id of the document
	var oid = getUrlVars()["oid"];
	
	//removes the hashtag from the GET parameter if it exists. this is a quick fix but should be implemented better in the javascript library
	if (oid.indexOf("#")!=-1){
		   oid=oid.substring(0,oid.indexOf("#"));
	}

	//construct the path to retrieve the json document
	var path="http://directory.nysenate.gov/legislation/2.0/bill/" + oid + ".jsonp?";

	//get the json document
	$.get(path,
            function(data) {
		         //set up the needed variables
		         var contents=[];
		         var anchorText=[];	         
		         anchorText='<b>Quick Navigation</b>';
		         var title='<h2>' + data.response.results[0].data.bill.senateBillNo + ': ' + data.response.results[0].data.bill.title + '</h2>';

		         //display the title
		         $("#billTitle").html(title);
		         anchorText+='<hr><a href="#billTitle">Title</a>';	         

		         //if there is a memo section, display it and add it to the quick navigation
			     if (data.response.results[0].data.bill.memo!=undefined){
				     temp=data.response.results[0].data.bill.memo;
				     var memo=temp.replace(/\n/gi, "<br/>");
				     $("#memo").html(memo);
				     anchorText+='</br><a href="#memo">Memo</a>';
			     }

			   //if there is a full text section, display it and add it to the quick navigation
		         if (data.response.results[0].data.bill.fulltext!=undefined){
                     temp=data.response.results[0].data.bill.fulltext;
                     var fulltext=temp.replace(/\n/gi, "<br/>");
                     //contents+=fulltext; 
                     $("#fulltext").html(fulltext);
                     anchorText+='</br><a href="#fulltext">Full Text</a>';
                 }

		         $("#anchors").append(anchorText);
            },
    'jsonp');
	
}

</script>

<body onload="init()">

<div id="content">
    <div id="anchors">
    </div>
    
    <div id="billTitle">
    </div>
    
    <div id="actions">
    </div>
    
    <div id="meetings">
    </div>
    
    <div id="calendars">
    </div>
    
    <div id="votes">
    </div>
    
    <div id="memo">
    </div>
    
    <div id="fulltext">
    </div>

 </div>
</body>
</html>
