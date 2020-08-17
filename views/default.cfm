<cfoutput>
	<link rel="stylesheet" href="#link( 'assets/project.css' )#">
	<div class="projects">
		<ul class="project">
		<cfloop array=#model.projects# item=t>
			<li class="project-li">
				<div class="full">
					<div class="half">
					<cfif t.logo neq "">
						<div class="logo-img">
							<img src="#t.logo#">
						</div>
					<cfelse>
						<h1>#t.title#</h1>
					</cfif>
					<cfif t.link neq "">
						<p><a class="link" href="#t.link#">See Project</a></p>
					</cfif>
						<h6>Description</h6>
						#t.description#	

					<cfif t.tech neq "">
						<br />
						<h6>Tech Stack</h6>
						<p>#t.tech#</p>
					</cfif>
					</div>

					<div class="images">
						<ul>
						<cfloop array=#t.images# item="file">
							<li><img src="#file#"></li>
						</cfloop>
						</ul>
					</div>
				</div>
			</li>
		</cfloop>
		</ul>
	</div>
</cfoutput>
