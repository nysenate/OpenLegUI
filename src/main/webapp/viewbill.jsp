<%@ page language="java" import="java.util.*, java.text.*,java.io.*"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>

<script type="text/javascript" src="openlegui.js"></script>

<title>OpenLegislation</title>

</head>
<script type="text/javascript">

//trigger that highlights an expanded text block when the collapse link is hovered over
$('.trigger').live("mouseenter", function() {	
           $(this).prev().css('background-color','#D9E5FF');
	})
	.live("mouseleave", function() {
		   $(this).prev().css('background-color','transparent');
	});

//trigger that expands all collapsed text blocks
$('.expandAll').live('click', function () {
	//if expand is displayed as the link, expand all blocks
    if ($(this).html()=='<a href="#">Expand all text blocks</a>'){
        $(this).html('<a href="#">Collapse all text blocks</a>');
        $('.toggle').next().html('<a href="#">Collapse text block</a>');
        $('.toggle').slideDown('slow');
    }
    //otherwise, collapse all blocks
    else{
        $(this).html('<a href="#">Expand all text blocks</a>');
        $('.toggle').next().html('<a href="#">Expand text block</a>');
        $('.toggle').slideUp('slow');
    }

	//prevents the code from finalizing the link and adding a # to the url
	return false;
});

//trigger that expands text blocks
$('.trigger').live('click', function () {
	$(this).prev().slideToggle('slow');
	//if expand is displayed, expand the block
    if ($(this).html()=='<a href="#">Expand text block</a>'){
    	 $(this).html('<a href="#">Collapse text block</a>');
    }
    //otherwise collapse the block
    else{
    	$(this).html('<a href="#">Expand text block</a>');
    }
  //prevents the code from finalizing the link and adding a # to the url
    return false;
  });

//handles the navigation bar automatically moving with the scrolling of the page
$(function() {
    var offset = $("#anchors").offset();
    var topPadding = 15;
    $(window).scroll(function() {
        if ($(window).scrollTop() > offset.top) {
            $("#anchors").stop().animate({
                marginTop: $(window).scrollTop() - offset.top + topPadding
            });
        } else {
            $("#anchors").stop().animate({
                marginTop: 0
            });
        };
    });
});

//function is called when the page is loaded
function init(){
    $('#searchzone').animate({top: '-10px',width: '100%', height:'70px', left: '-20px'},200,function(){
                
    });

    //get the id of the document
    var oid = getGetVars()["oid"];
    
    //removes the hashtag from the GET parameter if it exists. this is a quick fix
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
                 anchorText+='<ul><li><div class="expandAll"><a href="#">Expand all text blocks</a></div></li>';
                 anchorText+='<b>Quick Navigation:<hr> </b>';

                 //display the bill information
                 var billInfo='<h1>' + data.response.results[0].data.bill.senateBillNo + ': ' + data.response.results[0].data.bill.title ;
                 billInfo+='<h2>Bill Information</h2></h1><div class="hr"></div>';

                 billInfo+='<b>Sponsor:</b> ';
                 if (data.response.results[0].data.bill.sponsor!=null){
                     billInfo+=data.response.results[0].data.bill.sponsor.fullname;
                 }

                 //get the co sponsors
                 billInfo+='<br/><b>Co-sponsor(s):</b> ';
                 if (data.response.results[0].data.bill.coSponsors!=null){               	    
                       for (var i=0; i<data.response.results[0].data.bill.coSponsors.length; i++){   
                    	    if (i!= data.response.results[0].data.bill.coSponsors.length-1){
                    	    	   billInfo+= data.response.results[0].data.bill.coSponsors[i].fullname + ', ';
                    	    }
                    	    else {
                            billInfo+= data.response.results[0].data.bill.coSponsors[i].fullname;
                            }
                       }
                 }

                 //get the multi sponsors
                 billInfo+='<br/><b>Multi-sponsor(s):</b> ';
                 if (data.response.results[0].data.bill.multiSponsors!=null){
                	   for (var i=0; i<data.response.results[0].data.bill.multiSponsors.length; i++){   
                		   if (i!= data.response.results[0].data.bill.multiSponsors.length-1){
                		       billInfo+= data.response.results[0].data.bill.multiSponsors[i].fullname + ', ';
                		   }
                		   else {
                			   billInfo+= data.response.results[0].data.bill.multiSponsors[i].fullname;
                		   }
                	   }
                 }

                 //get other document sections
                 billInfo+='<br/><b>Committee:</b> ' + data.response.results[0].data.bill.currentCommittee;
                 billInfo+='<br/><b>Law Section:</b> ' + data.response.results[0].data.bill.lawSection;
                 billInfo+=' <b>Law:</b> ' + data.response.results[0].data.bill.law;

                 //append the string to the bill info div
                 $("#billInfo").html(billInfo);
                 anchorText+='<li><a href="#top">Top of Page</a></li>';
                 anchorText+='<li><a href="#billInfo">Bill Information</a></li>';            

                 
                 //if there is an actions section, display it and add it to the quick navigation
                 if (data.response.results[0].data.bill.actions!=undefined){
                	 var actionsText='<h2>Actions</h2>';    
                     actionsText+='<div class="hr"></div>';
                	 actionsText+='<ul>';
                     for (var i=0; i<data.response.results[0].data.bill.actions.length;i++){
                    	    actionsText+='<li>' + data.response.results[0].data.bill.actions[i].date + ' ' + data.response.results[0].data.bill.actions[i].text + '</li>';
                         }
                     actionsText+='</ul>';
                     $("#actions").html(actionsText);
                     anchorText+='<li><a href="#actions">Actions</a></li>';
                 }
                 //if there is a memo section, display it and add it to the quick navigation
                 if (data.response.results[0].data.bill.memo!=undefined){
                     temp=data.response.results[0].data.bill.memo;
                     var memo='<h2>Memo</h2>';    
                     memo+='<div class="hr"></div>'; 
                     //check for any long text blocks and break them up if necessary   
                     memo+=breakUpText(temp);                                
                     $("#memo").html(memo);
                     anchorText+='<li><a href="#memo">Memo</a></li>';
                 }

               //if there is a full text section, display it and add it to the quick navigation
                 if (data.response.results[0].data.bill.fulltext!=undefined){
                     //initialize variables
                     fullText=data.response.results[0].data.bill.fulltext;
                     
                     var builtText='<h2>Full Text</h2>';
                     builtText+='<div class="hr"></div>';
                     builtText+=breakUpText(fullText);
                     $("#fulltext").html(builtText);
                     anchorText+='<li><a href="#fulltext">Full Text</a></li>';             
                 }
                 anchorText+='<li><a href="#comments">Comments</a></li></ul>';
                 $("#anchors").append(anchorText);
            },
    'jsonp');

}


</script>

<body onload="init()">

<%@ include file="header.jsp"%>
<div id="top"></div>
<div id="wrap">

<div id="main">



<div id="billInfo" class="box"></div>

<div id="actions" class="box"></div>

<div id="meetings" class="box"></div>

<div id="calendars" class="box"></div>

<div id="votes" class="box"></div>

<div id="memo" class="box"></div>

<div id="fulltext"></div>
<br />
<div id="comments">
<h2>Comments</h2>
<div class="hr"></div>
Disqus comments go here</div>

</div>

<div id="anchors"></div>
</div>


</body>
</html>
