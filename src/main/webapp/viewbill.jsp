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
                 var billInfo='<h2>Bill Information</h2>';
                 billInfo+=data.response.results[0].data.bill.senateBillNo + ': ' + data.response.results[0].data.bill.title;
                 billInfo+='<br/>Sponsor: ' + data.response.results[0].data.bill.sponsor.fullname;
                 billInfo+=' Committee: ' + data.response.results[0].data.bill.currentCommittee;
                 billInfo+='<br/>Law Section: ' + data.response.results[0].data.bill.lawSection;
                 billInfo+=' Law: ' + data.response.results[0].data.bill.law;
                 billInfo+='<br/><br/>';

                 //display the title
                 $("#billInfo").html(billInfo);
                 anchorText+='<br/><a href="#billInfo">Bill Information</a>';            

                 //if there is a memo section, display it and add it to the quick navigation
                 if (data.response.results[0].data.bill.memo!=undefined){
                     temp=data.response.results[0].data.bill.memo;
                     var memo='<h2>Memo</h2>';
                     
                     memo+=temp.replace(/\n/gi, "<br/>");
                     
                     $("#memo").html(memo);
                     
                     anchorText+='<br/><a href="#memo">Memo</a>';
                 }

               //if there is a full text section, display it and add it to the quick navigation
                 if (data.response.results[0].data.bill.fulltext!=undefined){
                     temp=data.response.results[0].data.bill.fulltext;
                     //console.log(temp);
                     var textArray=[];
                     var index=0;
                     var firstMatch;
                     var beginning;
                     var end;
                     var numBreaks;
                     var secondMatch;
                     var tempString;
                     beginning=0;
                     end=temp.indexOf("\n\n", 0);
                     tempString=temp.substring(beginning, end);
                     textArray.push(tempString);
                     //alert (tempString);

                     while (beginning!=-1 || end!=-1){
                         //alert(tempString);
                    	   beginning=end;
                    	   end=temp.indexOf("\n\n", beginning+1);
                    	   if (end==-1){
                    		   end=temp.length;
                    	   }
                    	   tempString=temp.substring(beginning, end);
                    	   
                    	   
                    	   if (tempString==""){
                        	   break;
                    	   }
                    	   textArray.push(tempString);
                    	   /*numBreaks=tempString.match(/\n/gi).length-1;
                    	   if (numBreaks>10){
                        	  //alert (tempString);
                        	  var copyText=tempString;
                        	  tempString='<div class="bigBlock">' + copyText + '</div>';
                        	  //alert(tempString);
                        	  temp=temp.replace(copyText, tempString);
                        	  end=end+28;
                    	   }
                    	   */
                    	   
                    	   
                    	   if (end==-1 || beginning==-1){
                    		    break;
                    	   }
                     }     
                     for (var i = 0; i < textArray.length; i++) {
                    	 var currentText=textArray[i];
                    	 numBreaks=currentText.match(/\n/gi).length-1;
                    	 if (numBreaks>10){
                    		    currentText='<div class="bigBlock">' + currentText + '</div>';
                    		    //alert (currentText);
                    	 }
                    	 textArray[i]=currentText;
                         
                     }
                     temp="";
                     for (var i = 0; i < textArray.length; i++) {
                    	  temp+=textArray[i];
                     }
                     var fulltext='<h2>Full Text</h2>';
                     
                     fulltext+=temp.replace(/\n/gi, "<br/>");      
                     $("#fulltext").html(fulltext);
                     anchorText+='<br/><a href="#fulltext">Full Text</a>';
                 }

                 $("#anchors").append(anchorText);
            },
    'jsonp');
    
}

</script>

<body onload="init()">
<%@ include file="header.jsp" %>
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
    
    </div>
    
    <div id="anchors">
    </div>
    </div>
    

</body>
</html>
