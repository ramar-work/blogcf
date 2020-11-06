<html>
<head>
<cfoutput>
	<title>#model.base.title#</title>
<cfloop array="#model.base.jsfilelist#" item="file">
	<script src="#file#"></script>
</cfloop>
<cfloop array="#model.base.cssfilelist#" item="file">
	<link rel=stylesheet type=text/css href="#file#">
</cfloop>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>
	<header>
		<div class="links">
			<ul class="head-links">
			<cfloop array=#model.base.navigation# item="i">
				<a class="head-link" href="#i.href#">
					<li class="head-link">#i.name#</li>
				</a>
			</cfloop>
			</ul>	
		</div>

		<!--- I'd like this to be a drop down menu, b/c thats easy --->
		<div class="menu">
			<div>
			<ul class="head-links">
				<li><a href="/cms/logout">Log Out</a></li>
			</ul>
			</div>
			<div class="head-logo bubble">
				<img src="#model.base.profile#">
			</div>
		</div>
	</header>
</cfoutput>
