	<div class="projects">
	<cfoutput>
	<ul class="project">
		<!--- <cfloop from=1 to=3 index=w> --->
		<cfloop collection=#model# index=title>
			<cfset temp=model[title]>
		<li class="project-li">
			<div class="full">
				<div class="half">
				<cfif temp.logo neq "">
					<img src="#temp.logo#">
				<cfelse>
					<h1>#temp.title#</h1>
				</cfif>
				<cfif temp.link neq "">
					<p><a class="link" href="#temp.link#">See Project</a></p>
				</cfif>
					<h6>Description</h6>
					#temp.description#	

				<cfif temp.tech neq "">
					<br />
					<h6>Tech Stack</h6>
					<p>#temp.tech#</p>
				</cfif>
					<div class="container-full"></div>
				</div>

				<div class="images">
					<ul>
					<cfloop query=temp.images> 
						<li><img src="#link('files/projects/#temp.title#/screenshots/#iname#')#"></li>
					</cfloop>
					</ul>
				</div>
			</div>
		</li>
		</cfloop>
	</ul>
	</cfoutput>
	</div>
