<!--- work.cfm --->
<!--- use js to navigate this --->
<div class="container">
<ul>
<cfoutput>
<cfloop array=#model.projects# item=t>
	<li class="project-inner" style="background:#t.background#">
		<div class="backdrop">
			<img src=#t.images[1]#>
		</div> 

		<div class="description js-no-show">
			<h3>#t.title#</h3>

			<h4>Description</h4>
			#t.description#	

			<h4>Tech Stack</h4>
			#t.tech#
		</div>

		<div class="more">
		<cfif StructKeyExists(t,"adjust") && t.logo neq "">
			<img style="#t.adjust#" src="#t.logo#">
		<cfelseif t.logo neq "">
			<img src="#t.logo#">
		<cfelseif StructKeyExists(t,"name")>
			<h2>#t.name#</h2>
		</cfif>
			<ul>
			<cfif !StructKeyExists(t, "noinfo")>
				<a class="descinfo"><li>Info</li></a>
			</cfif>
			<cfif StructKeyExists(t, "github")>
				<a target="_blank" href="#t.github#"><li>Github</li></a>
			</cfif>
			<cfif StructKeyExists(t, "link")>
				<a target="_blank" href="#t.link#"><li>Link to Work</li></a>
			</cfif>
			</ul>
			<div class="next"></div>
		</div>

		<div class="images">
			<ul>
			<cfloop array=#t.images# item="file">
				<li><img src="#file#"></li>
			</cfloop>
			</ul>
		</div>
	</li>
</cfloop>
</cfoutput>
</ul>
</div>
