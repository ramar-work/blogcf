<html>
<head>
	<cfoutput>
	<!--- The CMS may usually have a name that can be overridden via property dec --->
	<title>#cms.getAdminTitle()#</title>

	<!--- Let's loop through these --->
	<script src="#cms.getAssetPath( "js", "cms.js" )#"></script>

	<!--- Let's loop through these --->
	<link rel=stylesheet type=text/css href="#link('assets/css/zero.css')#">
	<cfloop list="#cms.getCssFilelist()#" item="file">
		<link rel=stylesheet type=text/css href="#cms.getAssetPath( 'css', file & '.css' )#">
	</cfloop>

	<!--- Always use a view port tag, b/c we'll probably need to do mobile access --->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	</cfoutput>
</head>

<body>
	
	<!--- This area is for all of the menu HTML --->
	<div class="head">

		<!--- A company can optionally put in their own logo here --->
		<div class="head-logo">
		</div>

		<!--- Links to different content sections go here --->
		<!--- Populated via headLinks property --->
		<ul class="head-links">
			<a class="head-link" href="/admin/settings.cfm">
				<li class="head-link">Settings</li>
			</a>
			<a class="head-link" href="/admin/list.cfm">
				<li class="head-link">Content</li>
			</a>
		</ul>	
	</div>


</body>
</html>
