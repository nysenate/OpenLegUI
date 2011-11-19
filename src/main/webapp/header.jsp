<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="openstyles.css" rel="stylesheet" type="text/css" />



<div id="navzone">
    A link
</div>
<div id="headerzone" onload="init()">
    <img src="http://m.nysenate.gov/legislation/img/openleglogo.gif"/>
    <div id="filters">
        <input type="button" value="Bills" onclick="filter('Bills')" id="unclicked"/>
        <input type="button" value="Meetings" onclick="filter('Meetings')" id="unclicked"/>
        <input type="button" value="Transcripts" onclick="filter('Transcripts')" id="unclicked"/>
        <input type="button" value="Actions" onclick="filter('Actions')" id="unclicked"/>
        <input type="button" value="Votes" onclick="filter('Votes')" id="unclicked"/>
    <!--  
    <form name="search" action="" method="GET">
        <input type="text" name="search" id="search" value="Start searching here!" style="color:black;"/> 
        <input type="button" value="Go" onclick="gosearch(this.form)" id="go"/>
    </form>
    -->
    
    <form name="input" action="" method="get">
    <input type="text" name="search" id="search" value="Start searching here!" style="color:black;"/> 
    <input type="submit" value="Submit" />
    </form>
    
    </div>
    <div id="breadcrumbs"><a href="index.jsp">Home</a> Search</div>
</div>