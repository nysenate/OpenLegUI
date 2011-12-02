<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

    var path="http://directory.nysenate.gov/legislation/2.0/transcript/" + oid + ".jsonp?";
    $.get(path,
            function(data) {
                 var transcriptInfo='<h1>Transcript:' + data.response.results[0].data.transcript.timeStamp + '</h2>';
                 //=data.response.results[0].data.transcript.location
                 $("#transcriptInfo").html(transcriptInfo);

                 var transcriptText=data.response.results[0].data.transcript.transcriptText;
                 var temp=transcriptText;
                 transcriptText=temp.replace(/\n/gi, "<br/>");
                 $("#transcriptText").html(transcriptText);
    },
    'jsonp');
}
</script>
<body onload="init()">
<%@ include file="header.jsp" %>
<div id="top"></div>
<div id="wrap">

    <div id="main">
    <div id="transcriptInfo">
    </div>
    <div id="transcriptText">
    </div>
    </div>
</div>

</body>
</html>