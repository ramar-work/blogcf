<html>
<head>
<cfoutput>
	<meta charset="utf-8" />
	<link rel="stylesheet" href="#link( 'assets/default.css' )#">
	<link href="https://fonts.googleapis.com/css?family=EB+Garamond|Open+Sans&display=swap" rel="stylesheet">
	<!--- 
	<link rel="stylesheet" href=#myst.getPublicPath('default')#>
	<meta name="google-site-verification" content="rAPss2vKbyhbh6uzTuqqhhq2eoXUCKPQosTwcxNHjU4" />
	--->
	<title>#data.host# | #data.description#</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta name="Language" content="en" />
	<meta name="author" content="Antonio R. Collins II (rc@tubularmodular.com)" />
	<meta name="description" content="Just my own sparse, little development blog">
	<meta name="keywords" content="Javascript,C,C++,Java,MySQL,Lucee,Developer">
	<script src="#link('assets/index.js')#"></script>
</cfoutput>
</head>


<body>
<cfoutput>
<header>
	<div class="icon">
		<span>collins</span>
		<span>design</span>
	</div>

	<ul>
<!---
		<cfloop collection=#data.routes# item="w">
		<li><a href="/">#w#</a></li>
		</cfloop>
--->
		<li><a href="#link( 'default.cfm' )#">work</a></li>
		<li><a href="#link( 'contact.cfm' )#">contact</a></li>
		<li><a href="#link( 'blog.cfm' )#">blog</a></li>
		<!--- <li><a href="#link( '.cfm' )#">about</a></li> --->
	</ul>

<!---
	<div class="social">
		<a class="" href="http://facebook.com/antonio.r.collins" alt="Find Me on Facebook">
			<img class="icon" src="#link( "assets/facebook-logo_318-49940.jpg" )#"></img></a>
		
		<a class="" href="http://twitter.com/CollinsRamar" alt="Tweet With Me, Bro">
			<img class="icon" src="#link( "assets/twitter-logo_318-40459.jpg" )#"></img></a>

		<a class="" href="https://www.linkedin.com/in/antonio-collins-8391ba19" alt="Find Me on LinkedIn">
			<img class="icon" src="#link( "assets/linkedin-1.png" )#"></img></a>
	</div>
--->

</header>
<div class="container-prefix">
	<div class="container-full"></div>
	<div class="container-top"></div>
</div>
</cfoutput>

<div class="container">

