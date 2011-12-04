<html>
    <head>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
        <script type="text/javascript">
	        function redirect()
	        {
	        	var parts = window.location.href.split("?");
	        	var url = parts[0].replace("transfer","index")+"#"+parts[1];
	        	//alert(url);
	            //$('head').append('<meta http-equiv="Refresh" content="1;url="http://www.google.com" />');
	        	window.location=url;
	        }
        </script>
    </head>
    <body onload="redirect()">
    </body>
</html>
