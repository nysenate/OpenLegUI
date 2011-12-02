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

$('.trigger').live('click', function () {
    
    $(this).next().slideToggle();
    return false;
  });

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

function alertMe(){
	alert("testing");
}


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
                 anchorText='<b>Quick Navigation: </b>';

                 //display the bill information
                 var billInfo='<h1>' + data.response.results[0].data.bill.senateBillNo + ': ' + data.response.results[0].data.bill.title ;
                 billInfo+='<h2>Bill Information</h2></h1><div class="hr"></div>';

                 billInfo+='<b>Sponsor:</b> ';
                 if (data.response.results[0].data.bill.sponsor!=null){
                     billInfo+=data.response.results[0].data.bill.sponsor.fullname;
                 }
                 
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
                 
                 billInfo+='<br/><b>Committee:</b> ' + data.response.results[0].data.bill.currentCommittee;
                 billInfo+='<br/><b>Law Section:</b> ' + data.response.results[0].data.bill.lawSection;
                 billInfo+=' <b>Law:</b> ' + data.response.results[0].data.bill.law;
                 //billInfo+='<div class="hr"></div>';

                 
                 $("#billInfo").html(billInfo);
                 anchorText+='<br/><a href="#top">Top of Page</a>';
                 anchorText+='<br/><a href="#billInfo">Bill Information</a>';            

                 
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
                     anchorText+='<br/><a href="#actions">Actions</a>';
                 }
                 //if there is a memo section, display it and add it to the quick navigation
                 if (data.response.results[0].data.bill.memo!=undefined){
                     temp=data.response.results[0].data.bill.memo;
                     var memo='<h2>Memo</h2>';    
                     memo+='<div class="hr"></div>';    
                     memo+=breakUpText(temp);             
                     //memo+=temp.replace(/\n/gi, "<br/>");                    
                     $("#memo").html(memo);
                     anchorText+='<br/><a href="#memo">Memo</a>';
                 }

               //if there is a full text section, display it and add it to the quick navigation
                 if (data.response.results[0].data.bill.fulltext!=undefined){
                     //initialize variables
                     fullText=data.response.results[0].data.bill.fulltext;
                     /*var fullTextArray=[];
                     var index=0;
                     var beginning;
                     var end;
                     var numBreaks;
                     var tempString;
                     var processedText;
                     beginning=0;

                     //for the first block, select only the first double line break since there won't be one at the beginning of the text
                     end=fullText.indexOf("\n\n", 0);
                     //get the string text and push it to the array
                     tempString=fullText.substring(beginning, end);
                     fullTextArray.push(tempString);

                     while (beginning!=-1 || end!=-1){
                           //set beginning to the previous end
                           beginning=end;
                           //the new end is the next double line break
                           end=fullText.indexOf("\n\n", beginning+1);
                           //if there isn't another double line break, it has reached the end of the text
                           if (end==-1){
                               end=fullText.length;
                           }

                           //pull out the string between beginning and end
                           tempString=fullText.substring(beginning, end);

                           if (tempString==""){
                               break;
                           }
                           //push the text to the array
                           fullTextArray.push(tempString);
                           
                           if (end==-1 || beginning==-1){
                                break;
                           }
                     }     

                     var currentText="";
                     var breakIndex=0;
                     var firstSegment="";
                     var secondSegment="";
                     //iterate through the text array
                     for (var i = 0; i < fullTextArray.length; i++) {
                         breakIndex=0;
                         currentText="";
                         processedText="";
                         currentText=fullTextArray[i];
                         //get the number of line breaks within the text
                         numBreaks=currentText.match(/\n/gi).length-1;
                         //if the numbe is greater than 10, reformat it so it is now within a div
                         if (numBreaks>10){
                                currentText=currentText.substring(3);
                                for (var j=0; j<5; j++){
                                    breakIndex=currentText.indexOf("\n", breakIndex+1);
                                }
                                firstSegment=currentText.substring(0, breakIndex);
                                secondSegment=currentText.substring(breakIndex);
                                processedText+=firstSegment + '...';
                                processedText+='<br/><br/><div class="trigger"><a href="#">Expand text block</a></div>';
                               
                                //processedText+='<div class="toggle">' + currentText + '</div>';
                                processedText+='<div class="toggle">' + secondSegment + '</div>';
                                currentText=processedText;      
                         }
                         fullTextArray[i]=currentText;    
                     }
                     
                     fullText="";
                     
                     //iterate through the array and build the string with all of the full text
                     for (var i = 0; i < fullTextArray.length; i++) {
                          fullText+=fullTextArray[i];
                     }
                     
                     //put the fulltext in the fulltext div and add it to the navigation bar
                     var fulltext='<h2>Full Text</h2>';
                     fulltext+='<div class="hr"></div>';
                     fulltext+=fullText.replace(/\n/gi, "<br/>");     
                     //fulltext+='<div class="hr"></div>'; 
                     */
                     var builtText='<h2>Full Text</h2>';
                     builtText+='<div class="hr"></div>';
                     //builtText+=fullText.replace(/\n/gi, "<br/>");  
                     builtText+=breakUpText(fullText);
                     //$("#fulltext").html(fulltext);
                     $("#fulltext").html(builtText);
                     anchorText+='<br/><a href="#fulltext">Full Text</a>';
                     
                 }
                 anchorText+='<br/><a href="#comments">Comments</a>';
                 $("#anchors").append(anchorText);
            },
    'jsonp');

}


</script>

<body onload="init()">
<%@ include file="header.jsp" %>
<div id="top"></div>
<div id="wrap">

    <div id="main">
    
    
        <div id="billInfo" class="box">
        </div>
    
        <div id="actions" class="box">
        </div>
    
        <div id="meetings" class="box">
        </div>
    
        <div id="calendars" class="box">
        </div>
    
        <div id="votes" class="box">
        </div>
    
       <div id="memo" class="box">
        </div>
    
        <div id="fulltext">
        </div>
        <br/>
        <div id="comments">
        <h2>Comments</h2>
        <div class="hr"></div>
            Disqus comments go here
        </div>
    
    </div>
    
    <div id="anchors">
    </div>
    </div>
    

</body>
</html>
