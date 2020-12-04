<html>
<head>
<cfoutput>
	<meta charset="utf-8" />
	<link rel="stylesheet" href="#link( 'assets/base.css' )#">
	<link id="theme" rel="stylesheet" href="#link( 'assets/light.css' )#">
	<link href="https://fonts.googleapis.com/css?family=EB+Garamond|Open+Sans&display=swap" rel="stylesheet">
	<!--- 
	<link rel="stylesheet" href=#myst.getPublicPath('default')#>
	<meta name="google-site-verification" content="rAPss2vKbyhbh6uzTuqqhhq2eoXUCKPQosTwcxNHjU4" />
	--->
	<title>#appdata.host# | #appdata.description#</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta name="Language" content="en" />
	<meta name="author" content="Antonio R. Collins II (rc@tubularmodular.com)" />
	<meta name="description" content="Just my own sparse, little development blog">
	<meta name="keywords" content="Javascript,C,C++,Java,MySQL,Lucee,Developer">
	<script src="#link('assets/js/index.js')#"></script>
</cfoutput>
</head>


<body>

<style>
.container {
	width: 60%;
	min-width: 300px;
	max-width: 800px;
	margin: 0 auto;
}

.content-regular {
	margin: 100px 0 50px 0;
}

.content-regular .time {
	margin: 20px 0 20px 0;
}

.content-regular a,
.content-regular a:visited {
	color: black;
}

.content-regular h1 a,
.content-regular h2 a,
.content-regular h3 a,
.content-regular h4 a,
.content-regular h5 a,
.content-regular h6 a {
	text-decoration: none;
}

.content-regular p {
	font-size: 20px;
	line-height: 1.5em;
	margin-bottom: 20px;
}

.single .content-regular p {
	margin-bottom: 10px;
}

.single .content-regular {
	margin: 40px 0 40px 0;
}

pre {
	background-color: #aaa;
	padding: 10px;
}

.aa {
	position: fixed;
	top: -50px;
	background-color: white;
	margin: 0 auto;
	padding-top: 150px;
	width: 60%;
	min-width: 300px;
	max-width: 800px;
	padding-bottom: 20px;
	font-size: 1.3em;
}

.aa li {
	display: inline-block;
	margin-right: 10px;
	padding: 5px 10px 5px 0;
}

.aa li a, .aa li a:visited {
	color: black;	
}

.aa li:hover {
	background-color: black;
}

.aa li:hover a {
	color: white;
}

.aa li:last-child {
	position: absolute;
	bottom: 50px;
	left: 0px;	
	font-weight: bold;
	padding: 5px 10px 5px 0px;
}

.collection {
	padding-top: 50px;
}

.single {
	margin-top: 100px;
}
</style>

<div class="container">
<cfoutput>
	<ul class="aa">
<cfloop list="resume|/resume.pdf,blog|/blog,github|https://github.com/zaiah-dj" item="l">
	<cfset href=ListToArray( l, "|" )> 
		<li><a href="#href[2]#">#href[1]#</a></li>
</cfloop>
		<li><a href="/">ramar.work</a></li>
	</ul>
</cfoutput>
