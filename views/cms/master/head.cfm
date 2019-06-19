<html>
<head>
	<cfoutput>
	<!--- The CMS may usually have a name that can be overridden via property dec --->
	<title>#cms.getAdminTitle()#</title>

	<!--- Let's loop through these --->
	<script src="#cms.getAssetPath( "js", "cms.js" )#"></script>

	<!--- Let's loop through these --->
	<cfloop list="#cms.getCssFilelist()#" item="file">
		<link rel=stylesheet type=text/css href="#cms.getAssetPath( 'css', file & '.css' )#">
	</cfloop>

	<!--- Always use a view port tag, b/c we'll probably need to do mobile access --->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	</cfoutput>
</head>


<body>

	<!--- This area is for all of the menu HTML --->
	<header>

		<!--- Links to different content sections go here --->
		<!--- Populated via headLinks property --->
		<div class="links">
			<cfoutput>
			<ul class="head-links">
				<a class="head-link" href="#cms.getPublicPath( 'settings.cfm' )#">
					<li class="head-link">Settings</li>
				</a>
				<a class="head-link" href="#cms.getPublicPath( 'list.cfm' )#">
					<li class="head-link">Content</li>
				</a>
			</ul>	
			</cfoutput>
		</div>

		<!--- I'd like this to be a drop down menu, b/c thats easy --->
		<!---
		<div id="avatar">
			Log Out
		</div>
		--->
		<div class="menu">
			<div>
			<ul class="head-links">
				<li>Log Out</li>
			</ul>
			</div>
			<cfoutput>
			<div class="head-logo bubble"> <!--- style="#cms.getCssImagePath('aeon-thumb.jpg')#"> --->
				<img src="#cms.getAssetPath("img","aeon-thumb.jpg")#">
			</div>
			<div class="cms-logo bubble"> <!--- style="#cms.getCssImagePath('simplelogo.png')#"> --->
				<img src="#cms.getAssetPath("img","simplelogo.png")#">
			</div>
			</cfoutput>
		</div>

	</header>


