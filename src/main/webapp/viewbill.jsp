<%@ page language="java" import="java.util.*, java.text.*,java.io.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>

<title>OpenLegislation</title>
<link href="openstyles.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">
function init(){
	var oid = getUrlVars()["oid"];
	var path="http://directory.nysenate.gov/legislation/2.0/bill/" + oid + ".jsonp?";
	//$('#content').html(path);
	$.get(path,
            function(data) {
		         contents=[];
		         var temp="";

		         contents+='<h2>' + data.response.results[0].data.bill.senateBillNo + ': ' + data.response.results[0].data.bill.title + '</h2>';
		         
		         /*if (data.response.results[0].memo!=undefined){
		        	  var temp=data.response.results[0].data.bill.memo;
		        	  var memo=temp.replace(/\n/gi, "<br/>");
		        	  var test="hi";
		        	  contents+=test; 
			     }
			     */
			     if (data.response.results[0].data.bill.memo!=undefined){
				     temp=data.response.results[0].data.bill.memo;
				     var memo=temp.replace(/\n/gi, "<br/>");
				     contents+=memo;
			     }
		         if (data.response.results[0].data.bill.fulltext!=undefined){
                     temp=data.response.results[0].data.bill.fulltext;
                     var fulltext=temp.replace(/\n/gi, "<br/>");
                     contents+=fulltext; 
                 }
                 temp="";
		         //var temp=data.response.results[0].data.bill.fulltext;
		         //var temp2=temp.replace(/\n/gi, "<br/>")
		         //alert(temp);
		         //contents+=temp2;
		         //}
		         $('body').html(contents);
            },
    'jsonp');
}

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}
</script>

<body onload="init()">

</body>
</html>
