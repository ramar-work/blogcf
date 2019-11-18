	<div class="projects">
	<cfoutput>
	<ul class="project">
		<!--- <cfloop from=1 to=3 index=w> --->
		<cfloop collection=#model# index=title>
			<cfset temp=model[title]>
		<li class="project-li">
			<div class="full">
				<div class="half">
					<h1>#title#</h1>
					#temp.description#	
					<div class="container-full"></div>
				</div>

				<div class="images">
					<ul>
					<cfloop query=temp.images> 
						<li><img src="#link('files/projects/#temp.title#/screenshots/#iname#')#"></li>
					</cfloop>
<!---
--->
					</ul>
				</div>
			</div>
		</li>
		</cfloop>
	</ul>
	</cfoutput>
	</div>
